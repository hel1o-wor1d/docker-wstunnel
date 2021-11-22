#!/usr/bin/env sh

sshd_port=10022
wstunnel_port=10033
nginx_port=10080
root_pwd=root!

cat << EOF > /etc/ssh/sshd_config.d/wstunnel.conf
Port $sshd_port
PasswordAuthentication yes
PermitRootLogin yes
EOF
mkdir /run/sshd

if [ "$PORT" != "" ]; then
    nginx_port=$PORT
fi
cat << EOF > /etc/nginx/sites-enabled/wstunnel
server {
	listen $nginx_port;
	listen [::]:$nginx_port;

	location /wstunnel {
        proxy_pass http://127.0.0.1:$wstunnel_port;
        proxy_http_version  1.1;

        proxy_set_header    Upgrade \$http_upgrade;
        proxy_set_header    Connection "upgrade";
        proxy_set_header    Host \$http_host;
        proxy_set_header    X-Real-IP \$remote_addr;
    }
}
EOF
rm -f /etc/nginx/sites-enabled/default

cat << "EOF" > /etc/supervisor/conf.d/sshd.conf
[program:sshd]
command=/usr/sbin/sshd -D
autostart=true
startsecs=3
autorestart=true
startretries=3
EOF
cat << EOF > /etc/supervisor/conf.d/wstunnel.conf
[program:wstunnel]
command=wstunnel --server ws://0.0.0.0:$wstunnel_port
autostart=true
startsecs=3
autorestart=true
startretries=3
EOF
cat << "EOF" > /etc/supervisor/conf.d/nginx.conf
[program:nginx]
command=nginx -g "daemon off;"
autostart=true
startsecs=3
autorestart=true
startretries=3
EOF

supervisord -n
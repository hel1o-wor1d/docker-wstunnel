#!/usr/bin/env sh

netcat_port=10022
wstunnel_port=10033
nginx_port=10080

if [ "$PORT" != "" ]; then
    nginx_port=$PORT
fi

# nginx
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

# netcat
cat << EOF > /etc/supervisor/conf.d/netcat.conf
[program:netcat]
command=/usr/local/bin/mync.sh
autostart=true
startsecs=3
autorestart=true
startretries=3
EOF

# wstunnel
cat << EOF > /etc/supervisor/conf.d/wstunnel.conf
[program:wstunnel]
command=/usr/local/bin/wstunnel --server ws://127.0.0.1:$wstunnel_port --websocketPingFrequencySec 10
autostart=true
startsecs=3
autorestart=true
startretries=3
EOF

#nginx
cat << "EOF" > /etc/supervisor/conf.d/nginx.conf
[program:nginx]
command=nginx -g "daemon off;"
autostart=true
startsecs=3
autorestart=true
startretries=3
EOF

supervisord -n
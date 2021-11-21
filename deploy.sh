#!/usr/bin/env sh

cat << "EOF" > /etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
#deb-src http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse
#deb-src http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse
#deb-src http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse
#deb-src http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse
deb http://archive.canonical.com/ubuntu focal partner
#deb-src http://archive.canonical.com/ubuntu focal partner
EOF
apt-get update && apt-get dist-upgrade && apt-get -y autoremove

echo "root:root!" | chpasswd

apt-get install -y openssh-server
cat << "EOF" > /etc/ssh/sshd_config
Port 10022
PasswordAuthentication yes
PermitRootLogin yes
EOF
mkdir /run/sshd

apt-get install -y wget
wget -O /usr/local/bin/wstunnel https://github.com/erebe/wstunnel/releases/download/v4.0/wstunnel-x64-linux
chmod +x /usr/local/bin/wstunnel

apt-get install nginx -y
cat << "EOF" > /etc/nginx/sites-enabled/wstunnel
server {
	listen 10080;
	listen [::]:10080;

	location /wstunnel {
        proxy_pass http://127.0.0.1:10033;
        proxy_http_version  1.1;

        proxy_set_header    Upgrade $http_upgrade;
        proxy_set_header    Connection "upgrade";
        proxy_set_header    Host $http_host;
        proxy_set_header    X-Real-IP $remote_addr;
    }
}
EOF
rm -f /etc/nginx/sites-enabled/default

apt-get install -y supervisor
cat << "EOF" > /etc/supervisor/conf.d/sshd.conf
[program:sshd]
command=/usr/sbin/sshd -D
autostart=true
startsecs=3
autorestart=true
startretries=3
EOF
cat << "EOF" > /etc/supervisor/conf.d/wstunnel.conf
[program:wstunnel]
command=wstunnel --server ws://0.0.0.0:10033
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
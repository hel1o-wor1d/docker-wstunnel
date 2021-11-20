 FROM ubuntu:20.04

RUN printf "\
deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse\n\
#deb-src http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse\n\
deb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse\n\
#deb-src http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse\n\
deb http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse\n\
#deb-src http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse\n\
deb http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse\n\
#deb-src http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse\n\
deb http://archive.canonical.com/ubuntu focal partner\n\
#deb-src http://archive.canonical.com/ubuntu focal partner\n\
" > /etc/apt/sources.list
RUN apt-get update && apt-get dist-upgrade && apt-get autoremove -y


RUN echo "root:root!" | chpasswd
RUN apt-get install -y openssh-server
RUN printf "\n\
Port 10022\n\
PasswordAuthentication yes\n\
PermitRootLogin yes\n\
" >> /etc/ssh/sshd_config
RUN mkdir /run/sshd
RUN echo "/usr/sbin/sshd -D &" >> /run.sh

RUN wget -O /usr/local/bin/wstunnel https://github.com/erebe/wstunnel/releases/download/v4.0/wstunnel-x64-linux
RUN chmod +x /usr/local/bin/wstunnel
RUN echo "wstunnel --server ws://0.0.0.0:10033 &" >> /run.sh

RUN apt-get install nginx -y
RUN printf "\
server {\n\
	listen 10080;\n\
	listen [::]:10080;\n\
\n\
    location /wstunnel {\n\
        proxy_pass http://127.0.0.1:10033;\n\
        proxy_http_version  1.1;\n\
\n\
        proxy_set_header    Upgrade \$http_upgrade;\n\
        proxy_set_header    Connection \"upgrade\";\n\
        proxy_set_header    Host \$http_host;\n\
        proxy_set_header    X-Real-IP \$remote_addr;\n\
    }\n\
}\n\
" >> /etc/nginx/sites-enabled/wstunnel
RUN echo "nginx -g \"daemon off;\"" >> /run.sh

EXPOSE 10080

RUN chmod +x /run.sh
CMD /run.sh

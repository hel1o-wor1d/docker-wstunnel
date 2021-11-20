#!/usr/bin/env sh

# heroku
if [ $PORT ];then
cat << EOF > /etc/nginx/sites-enabled/wstunnel
server {
	listen $PORT;
	listen [::]:$PORT;

	location /wstunnel {
        proxy_pass http://127.0.0.1:10033;
        proxy_http_version  1.1;

        proxy_set_header    Upgrade \$http_upgrade;
        proxy_set_header    Connection \"upgrade\";
        proxy_set_header    Host \$http_host;
        proxy_set_header    X-Real-IP \$remote_addr;
    }
}
EOF
fi

supervisord -n

#!/bin/bash
# Thanks to https://gist.github.com/Lewiscowles1986/ce14296e3f5222082dbaa088ca1954f7

if [ "$(whoami)" != "root" ]; then
	echo "Only ROOT user can run this script."
	exit
fi

echo "deb http://mirrordirector.raspbian.org/raspbian/ stretch main contrib non-free rpi" > /etc/apt/sources.list.d/stretch.list
echo "APT::Default-Release \"jessie\";" > /etc/apt/apt.conf.d/99-default-release

apt-get update -y
apt-get upgrade -y
apt-get dist-upgrade -y

apt-get install -y rpi-update

apt-get install -t stretch -y php7.0 php7.0-fpm php7.0-cli php7.0-opcache php7.0-mbstring php7.0-curl php7.0-xml php7.0-gd php7.0-mysql
apt-get install -t stretch -y nginx

update-rc.d nginx defaults
update-rc.d php7.0-fpm defaults

sed -i 's/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.0/fpm/php.ini
sed -i 's/# server_names_hash_bucket_size/server_names_hash_bucket_size/' /etc/nginx/nginx.conf

cat > /etc/nginx/sites-enabled/default << "EOF"
# Default server
server {
	listen 80 default_server;
	listen [::]:80 default_server;
	
	server_name _;
	root /var/www/default/public;
	index index.php index.html index.htm default.html;

	location / {
		try_files $uri $uri/ =404;
	}

	# pass the PHP scripts to FastCGI server
	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/run/php/php7.0-fpm.sock;
	}

	# optimize static file serving
	location ~* \.(jpg|jpeg|gif|png|css|js|ico|xml)$ {
		access_log off;
		log_not_found off;
		expires 30d;
	}

	# deny access to .htaccess files, should an Apache document root conflict with nginx
	location ~ /\.ht {
		deny all;
	}
}
EOF

mkdir -p /var/www/default/public
cat > /var/www/default/public/index.php << "EOF"
<?php

class Application
{
	public function __construct()
	{
		phpinfo();
	}
}

$application = new Application();
EOF

rm -rf /var/www/html

usermod -a -G www-data pi
chown -R pi:www-data /var/www
chgrp -R www-data /var/www
chmod -R g+rw /var/www

setfacl -d -R -m g::rw /var/www

apt-get -y autoremove

service nginx restart
service php7.0-fpm restart

# MariaDB
apt-get -t stretch -y install mariadb-server

read -s -p "Set mariadb root password: " dbPass

mysql --user="root" --password="$dbPass" --database="mysql" --execute="GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$dbPass'; FLUSH PRIVILEGES;"

sed -i 's/^bind-address/#bind-address/' /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i 's/^skip-networking/#skip-networking/' /etc/mysql/mysql.conf.d/mysqld.cnf

service mysql restart

apt-get -y autoremove
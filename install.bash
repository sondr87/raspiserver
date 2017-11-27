#!/bin/bash

# Check root
if [ "$(whoami)" != "root" ]; then
	echo "Only ROOT user can run this script."
	exit
fi

# Update
apt-get update -y
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get install -y rpi-update

# Access login via SSH by ROOT
sed -i 's/^#PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Install php, php modules, nginx, tools
apt-get install -y php7.0 php7.0-fpm php7.0-cli php7.0-opcache php7.0-mbstring php7.0-curl php7.0-xml php7.0-gd php7.0-mysql php7.0-json php7.0-mcrypt php7.0-xmlrpc php7.0-zip
apt-get install -y nginx nginx-extras
apt-get install -y mc

# We can make sure that our web server will restart automatically when the server is rebooted by typing:
update-rc.d nginx defaults
update-rc.d php7.0-fpm defaults

# Fix php parameter 
sed -i 's/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.0/fpm/php.ini

# php.ini [fpm]
cat > /etc/php/7.0/fpm/php.ini << "EOF"
[PHP]
engine = On
short_open_tag = On
precision = 14
output_buffering = 4096
zlib.output_compression = Off
implicit_flush = Off
unserialize_callback_func =
serialize_precision = 17
disable_functions = pcntl_alarm,pcntl_fork,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wifcontinued,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority,
disable_classes =
realpath_cache_size = 8M
zend.enable_gc = On
expose_php = Off
max_execution_time = 60
max_input_time = 60
max_input_vars = 10000
memory_limit = 256M
error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT
display_errors = On
display_startup_errors = On
log_errors = On
log_errors_max_len = 1024
ignore_repeated_errors = Off
ignore_repeated_source = Off
report_memleaks = On
track_errors = Off
html_errors = On
variables_order = "GPCS"
request_order = "GP"
register_argc_argv = Off
auto_globals_jit = On
post_max_size = 10M
auto_prepend_file =
auto_append_file =
default_mimetype = "text/html"
default_charset = "UTF-8"
doc_root =
user_dir =
enable_dl = Off
cgi.fix_pathinfo=0
file_uploads = On
upload_max_filesize = 10M
max_file_uploads = 20
allow_url_fopen = Off
allow_url_include = Off
default_socket_timeout = 60
[CLI Server]
cli_server.color = On
[Date]
date.timezone = Europe/Moscow
[Pdo_mysql]
pdo_mysql.cache_size = 2000
pdo_mysql.default_socket=
[mail function]
SMTP = localhost
smtp_port = 25
mail.add_x_header = On
[SQL]
sql.safe_mode = Off
[MySQLi]
mysqli.max_persistent = -1
mysqli.allow_persistent = On
mysqli.max_links = -1
mysqli.cache_size = 2000
mysqli.default_port = 3306
mysqli.default_socket =
mysqli.default_host =
mysqli.default_user =
mysqli.default_pw =
mysqli.reconnect = Off
[mysqlnd]
mysqlnd.collect_statistics = On
mysqlnd.collect_memory_statistics = Off
[bcmath]
bcmath.scale = 0
[Session]
session.save_handler = files
session.save_path = "/var/lib/php/sessions"
session.use_strict_mode = 0
session.use_cookies = 1
session.use_only_cookies = 1
session.name = PHPSESSID
session.auto_start = 0
session.cookie_lifetime = 0
session.cookie_path = /
session.cookie_domain =
session.cookie_httponly =
session.serialize_handler = php
session.gc_probability = 0
session.gc_divisor = 1000
session.gc_maxlifetime = 1440
session.referer_check =
session.cache_limiter = nocache
session.cache_expire = 180
session.use_trans_sid = 0
session.hash_function = 0
session.hash_bits_per_character = 5
url_rewriter.tags = "a=href,area=href,frame=src,input=src,form=fakeentry"
[Assertion]
zend.assertions = -1
[mbstring]
mbstring.internal_encoding = UTF-8
mbstring.func_overload = 2
[Tidy]
tidy.clean_output = Off
[soap]
soap.wsdl_cache_enabled=1
soap.wsdl_cache_dir="/tmp"
soap.wsdl_cache_ttl=86400
soap.wsdl_cache_limit = 5
[ldap]
ldap.max_links = -1
[opcache]
opcache.max_accelerated_files=100000
opcache.revalidate_freq=0
EOF

# php.ini [fpm]
cat > /etc/php/7.0/cli/php.ini << "EOF"
[PHP]
engine = On
short_open_tag = On
precision = 14
output_buffering = 4096
zlib.output_compression = Off
implicit_flush = Off
unserialize_callback_func =
serialize_precision = 17
disable_functions =
disable_classes =
realpath_cache_size = 8M
zend.enable_gc = On
expose_php = On
max_input_vars = 10000
memory_limit = -1
error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT
display_errors = On
display_startup_errors = On
log_errors = On
log_errors_max_len = 1024
ignore_repeated_errors = Off
ignore_repeated_source = Off
report_memleaks = On
track_errors = Off
html_errors = On
variables_order = "GPCS"
request_order = "GP"
register_argc_argv = Off
auto_globals_jit = On
post_max_size = 10M
auto_prepend_file =
auto_append_file =
default_mimetype = "text/html"
default_charset = "UTF-8"
doc_root =
user_dir =
enable_dl = Off
file_uploads = On
upload_max_filesize = 10M
max_file_uploads = 20
allow_url_fopen = Off
allow_url_include = Off
default_socket_timeout = 60
[CLI Server]
cli_server.color = On
[Date]
date.timezone = Europe/Moscow
[Pdo_mysql]
pdo_mysql.cache_size = 2000
pdo_mysql.default_socket=
[mail function]
SMTP = localhost
smtp_port = 25
mail.add_x_header = On
[SQL]
sql.safe_mode = Off
[MySQLi]
mysqli.max_persistent = -1
mysqli.allow_persistent = On
mysqli.max_links = -1
mysqli.cache_size = 2000
mysqli.default_port = 3306
mysqli.default_socket =
mysqli.default_host =
mysqli.default_user =
mysqli.default_pw =
mysqli.reconnect = Off
[mysqlnd]
mysqlnd.collect_statistics = On
mysqlnd.collect_memory_statistics = Off
[bcmath]
bcmath.scale = 0
[Session]
session.save_handler = files
session.save_path = "/var/lib/php/sessions"
session.use_strict_mode = 0
session.use_cookies = 1
session.use_only_cookies = 1
session.name = PHPSESSID
session.auto_start = 0
session.cookie_lifetime = 0
session.cookie_path = /
session.cookie_domain =
session.cookie_httponly =
session.serialize_handler = php
session.gc_probability = 0
session.gc_divisor = 1000
session.gc_maxlifetime = 1440
session.referer_check =
session.cache_limiter = nocache
session.cache_expire = 180
session.use_trans_sid = 0
session.hash_function = 0
session.hash_bits_per_character = 5
url_rewriter.tags = "a=href,area=href,frame=src,input=src,form=fakeentry"
[Assertion]
zend.assertions = -1
[mbstring]
mbstring.internal_encoding = UTF-8
mbstring.func_overload = 2
[Tidy]
tidy.clean_output = Off
[soap]
soap.wsdl_cache_enabled=1
soap.wsdl_cache_dir="/tmp"
soap.wsdl_cache_ttl=86400
soap.wsdl_cache_limit = 5
[ldap]
ldap.max_links = -1
[opcache]
opcache.max_accelerated_files=100000
opcache.revalidate_freq=0
EOF

# php-fpm config
cat > /etc/php/7.0/fpm/pool.d/www.conf << "EOF"
[www]
user = pi
group = pi
listen = /run/php/php7.0-fpm.sock
listen.owner = pi
listen.group = pi
pm = static
pm.max_children = 3
pm.start_servers = 3
pm.min_spare_servers = 3
pm.max_spare_servers = 3
pm.max_requests = 100
EOF

# nginx.conf
cat > /etc/nginx/nginx.conf << "EOF"
user pi;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
	worker_connections 768;
	# multi_accept on;
}

http {

	##
	# Basic Settings
	##

	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	keepalive_timeout 65;
	types_hash_max_size 2048;
	server_tokens off;
	
	client_max_body_size 100m;

	fastcgi_buffer_size  128k;
	fastcgi_buffers  4 256k;
	fastcgi_busy_buffers_size  256k;

	server_names_hash_bucket_size 64;
	# server_name_in_redirect off;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	##
	# SSL Settings
	##

	ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
	ssl_prefer_server_ciphers on;

	##
	# Logging Settings
	##

	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	##
	# Gzip Settings
	##

	gzip on;
	gzip_disable "msie6";

	gzip_vary on;
	gzip_proxied any;
	gzip_comp_level 6;
	gzip_buffers 16 8k;
	gzip_http_version 1.1;
	gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

	##
	# Virtual Host Configs
	##

	include /etc/nginx/conf.d/*.conf;
	include /etc/nginx/sites-enabled/*;
}
EOF

# nginx virtual host
cat > /etc/nginx/sites-enabled/default << "EOF"
# Default server
server {
	listen 80 default_server;
	listen [::]:80 default_server;
	
	server_name localhost;
	root /var/www/default/public;
	index index.php index.html index.htm default.html;

	# deny access to .htaccess files, should an Apache document root conflict with nginx
	location ~ (/\.ht|/bitrix/modules|/upload/support/not_image) {
		deny all;
	}
	
	# deny for *.php in /upload/
	location ~* ^/upload/.*\.php$ {
		deny all;
		return 404;
	}

	# url rewrite
	if (!-e $request_filename) {
		rewrite  ^(.*)$  /bitrix/urlrewrite.php last;
	}
	
	#
	location / {
		try_files $uri $uri/ =404;
	}

	# pass the PHP scripts to FastCGI server
	location ~ \.php$ {
		if (!-f $request_filename) {
			rewrite  ^(.*)/index.php$  $1/ redirect;
		}
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/run/php/php7.0-fpm.sock;
		fastcgi_read_timeout 70;
		fastcgi_ignore_client_abort off;
	}

	# optimize static file serving
	location ~* \.(jpg|jpeg|gif|png|bmp|css|js|ico|xml|txt|zip|rar|gz|7z|pdf|doc|docx|xls|xlsx|ppt|pptx|rtf|htm|html)$ {
		access_log off;
		log_not_found off;
		expires 30d;
	}
}
EOF

# nginx fixes
sed -i 's/# server_names_hash_bucket_size/server_names_hash_bucket_size/' /etc/nginx/nginx.conf
sed -i 's/set $path_info $fastcgi_path_info;/#set $path_info $fastcgi_path_info;/' /etc/nginx/snippets/fastcgi-php.conf
sed -i 's/fastcgi_param PATH_INFO $path_info;/#fastcgi_param PATH_INFO $path_info;/' /etc/nginx/snippets/fastcgi-php.conf

# Create site dir + index.php
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

# Remove old html root folder
rm -rf /var/www/html

# Fix user rights
usermod -a -G www-data pi
chown -R pi:pi /var/www
chmod -R g+rw /var/www
setfacl -d -R -m g::rw /var/www
chown -R pi:pi /var/lib/php/sessions
rm /var/lib/php/sessions/*

# MariaDB install, set root password, and db permissions
apt-get install -y mariadb-server
read -s -p "Set mariadb root password: " dbPass
mysql --user="root" --password="$dbPass" --database="mysql" --execute="GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$dbPass'; FLUSH PRIVILEGES;"

# MariaDB config
cat > /etc/mysql/mariadb.conf.d/50-server.cnf << "EOF"
#
# These groups are read by MariaDB server.
# Use it for options that only the server (but not clients) should see
#
# See the examples of server my.cnf files in /usr/share/mysql/
#

# this is read by the standalone daemon and embedded servers
[server]

# this is only for the mysqld standalone daemon
[mysqld]

#
# * Basic Settings
#
user		= mysql
pid-file	= /var/run/mysqld/mysqld.pid
socket		= /var/run/mysqld/mysqld.sock
port		= 3306
basedir		= /usr
datadir		= /var/lib/mysql
tmpdir		= /tmp
lc-messages-dir	= /usr/share/mysql
skip-external-locking

sql_mode = 
default-time-zone = "+03:00"

# Instead of skip-networking the default is now to listen only on
# localhost which is more compatible and is not less secure.
bind-address		= 127.0.0.1

#
# * Fine Tuning
#
key_buffer_size		= 16M
max_allowed_packet	= 16M
thread_stack		= 192K
thread_cache_size       = 8
# This replaces the startup script and checks MyISAM tables if needed
# the first time they are touched
myisam_recover_options  = BACKUP
#max_connections        = 100
#table_cache            = 64
#thread_concurrency     = 10

#
# * Query Cache Configuration
#
query_cache_limit	= 16M
query_cache_size        = 16M

#
# * Logging and Replication
#
# Both location gets rotated by the cronjob.
# Be aware that this log type is a performance killer.
# As of 5.1 you can enable the log at runtime!
#general_log_file        = /var/log/mysql/mysql.log
#general_log             = 1
#
# Error log - should be very few entries.
#
log_error = /var/log/mysql/error.log
#
# Enable the slow query log to see queries with especially long duration
#slow_query_log_file	= /var/log/mysql/mariadb-slow.log
#long_query_time = 10
#log_slow_rate_limit	= 1000
#log_slow_verbosity	= query_plan
#log-queries-not-using-indexes
#
# The following can be used as easy to replay backup logs or for replication.
# note: if you are setting up a replication slave, see README.Debian about
#       other settings you may need to change.
#server-id		= 1
#log_bin			= /var/log/mysql/mysql-bin.log
expire_logs_days	= 10
max_binlog_size   = 100M
#binlog_do_db		= include_database_name
#binlog_ignore_db	= exclude_database_name

#
# * InnoDB
#
# InnoDB is enabled by default with a 10MB datafile in /var/lib/mysql/.
# Read the manual for more InnoDB related options. There are many!

innodb_flush_log_at_trx_commit = 2
innodb_flush_method=O_DIRECT
innodb_doublewrite=0
innodb_support_xa=0

transaction_isolation = READ-COMMITTED

#
# * Security Features
#
# Read the manual, too, if you want chroot!
# chroot = /var/lib/mysql/
#
# For generating SSL certificates you can use for example the GUI tool "tinyca".
#
# ssl-ca=/etc/mysql/cacert.pem
# ssl-cert=/etc/mysql/server-cert.pem
# ssl-key=/etc/mysql/server-key.pem
#
# Accept only connections using the latest and most secure TLS protocol version.
# ..when MariaDB is compiled with OpenSSL:
# ssl-cipher=TLSv1.2
# ..when MariaDB is compiled with YaSSL (default in Debian):
# ssl=on

#
# * Character sets
#
# MySQL/MariaDB default is Latin1, but in Debian we rather default to the full
# utf8 4-byte character set. See also client.cnf
#
character-set-server  = utf8mb4
collation-server      = utf8mb4_general_ci

#
# * Unix socket authentication plugin is built-in since 10.0.22-6
#
# Needed so the root database user can authenticate without a password but
# only when running as the unix root user.
#
# Also available for other users if required.
# See https://mariadb.com/kb/en/unix_socket-authentication-plugin/

# this is only for embedded server
[embedded]

# This group is only read by MariaDB servers, not by MySQL.
# If you use the same .cnf file for MySQL and MariaDB,
# you can put MariaDB-only options here
[mariadb]

# This group is only read by MariaDB-10.1 servers.
# If you use the same .cnf file for MariaDB of different versions,
# use this group for options that older servers don't understand
[mariadb-10.1]
EOF

# Install postfix
apt-get install -y postfix

# Restart services
service nginx restart
service php7.0-fpm restart
service mysql restart
service ssh restart

# Clean dependencies
apt-get -y autoremove
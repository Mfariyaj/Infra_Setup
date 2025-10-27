#!/bin/bash
# ========================================
# WordPress Installation Script for Ubuntu
# ========================================

# Exit immediately if a command fails
set -e

# Update and upgrade system
apt update -y
apt upgrade -y

# Install Apache, MariaDB, PHP and required extensions
apt install -y apache2 mariadb-server php php-mysql php-gd php-xml php-mbstring php-curl php-xmlrpc unzip wget curl

# Enable and start Apache & MariaDB
systemctl enable apache2
systemctl start apache2
systemctl enable mariadb
systemctl start mariadb

# Secure MariaDB installation (non-interactive)
MYSQL_ROOT_PASSWORD="rootpass123"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;"

# Create WordPress database and user
DB_NAME="wordpress"
DB_USER="wpuser"
DB_PASS="wpuserpass123"

mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE ${DB_NAME};"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

# Download and configure WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/

# Configure wp-config.php
cd /var/www/html
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/${DB_NAME}/" wp-config.php
sed -i "s/username_here/${DB_USER}/" wp-config.php
sed -i "s/password_here/${DB_PASS}/" wp-config.php

# Set permissions
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/

# Enable Apache mod_rewrite
a2enmod rewrite
systemctl restart apache2

# Clean up
rm -rf /tmp/wordpress /tmp/latest.tar.gz

# Print installation summary
echo "======================================"
echo "WordPress Installed Successfully!"
echo "Visit your site using the instance public IP."
echo "DB: ${DB_NAME}, User: ${DB_USER}, Pass: ${DB_PASS}"
echo "======================================"

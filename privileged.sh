#!/usr/bin/env bash

# Updating
echo "Updating repositories..."
sudo apt-get update
echo "... done."

# Installing Apache
echo "Installing Apache..."
sudo apt-get -qq install apache2 > /dev/null 2>&1
sudo usermod -a -G www-data vagrant
sudo a2enmod rewrite
sudo service apache2 restart
echo "... done."

# Installing MySql
echo "Installing MySql..."
echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
sudo apt-get install -qq mysql-server > /dev/null 2>&1
echo "... done."

# Installing PHP
echo "Installing PHP..."
sudo apt-get install -qq php5 > /dev/null 2>&1
sudo apt-get install -qq libapache2-mod-php5 > /dev/null 2>&1
sudo apt-get install -qq php5-mcrypt > /dev/null 2>&1
sudo apt-get install -qq php5-mysql > /dev/null 2>&1
sudo apt-get install -qq php5-sqlite > /dev/null 2>&1
sudo apt-get install -qq php5-cli > /dev/null 2>&1
sudo apt-get install -qq php5-curl > /dev/null 2>&1
sudo apt-get install -qq php5-gd > /dev/null 2>&1
sudo apt-get install -qq php5-json > /dev/null 2>&1
sudo apt-get install -qq php5-xdebug > /dev/null 2>&1

sudo php5enmod mcrypt

sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php5/cli/php.ini
sudo sed -i "s#;date.timezone.*#date.timezone = Europe/Rome#" /etc/php5/cli/php.ini

sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php5/apache2/php.ini
sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php5/apache2/php.ini
sudo sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php5/apache2/php.ini
sudo sed -i "s#;date.timezone.*#date.timezone = Europe/Rome#" /etc/php5/apache2/php.ini

sudo echo "xdebug.remote_enable = 1" >> /etc/php5/apache2/conf.d/20-xdebug.ini
sudo echo "xdebug.remote_connect_back = 1" >> /etc/php5/apache2/conf.d/20-xdebug.ini
sudo echo "xdebug.remote_port = 9000" >> /etc/php5/apache2/conf.d/20-xdebug.ini
sudo echo "xdebug.max_nesting_level = 512" >> /etc/php5/apache2/conf.d/20-xdebug.ini
sudo service apache2 restart
echo "... done."

# Installing Composer
echo "Installing Composer..."
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer
echo "... done."

# Installing Deployer
echo "Installing Deployer..."
wget http://deployer.org/deployer.phar
sudo mv deployer.phar /usr/local/bin/dep
sudo chmod +x /usr/local/bin/dep
echo "... done."

# Configuring virtual hosts
echo "Configuring virtual hosts..."
sudo a2dissite 000-default.conf
sudo rm -rf /var/www/html
echo "... done."

# Installing Mailcatcher
echo "Installing Mailcatcher..."
sudo apt-get install -qq libsqlite3-dev > /dev/null 2>&1
sudo apt-get install -qq ruby1.9.1-dev > /dev/null 2>&1
gem install --no-rdoc --no-ri mailcatcher
sudo tee /etc/init/mailcatcher.conf <<EOL
description "Mailcatcher"
start on runlevel [2345]
stop on runlevel [!2345]
respawn
exec /usr/bin/env $(which mailcatcher) --foreground --http-ip=0.0.0.0
EOL
sudo service mailcatcher start
echo "... done."
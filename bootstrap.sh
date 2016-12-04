#!/usr/bin/env bash

###
#
# bootstrap.sh - Realiza o provisionamento da VM.
#
# Instala os pacotes necessários e realiza configurações.
# A ordem de instalação é importante, pois algumas aplicações dependem de outras, ou usuários criados por outras.
# Lista macro de softwares instalados:
#  - Wget
#  - PHP
#  - NodeJS e npm
#  - Nginx
#  - MariaDB
#
# @author André Luiz Haag <andreluizhaag@gmail.com>
#
###

#
# SELinux
# --------------------------------
sudo setenforce Permissive

#
# Time/Zone
# --------------------------------
sudo timedatectl set-timezone America/Sao_Paulo

#
# Basic dependencies
# --------------------------------
sudo yum install -y wget

#
# Enable EPEL (Extra Packages Enterprise Linux)
# --------------------------------
sudo wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo wget http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo rpm -Uvh remi-release-7.rpm epel-release-latest-7.noarch.rpm

#
# Basic softwares
# --------------------------------
sudo yum install -y vim
sudo yum install -y git

#
# Nginx
# --------------------------------
# Install package
sudo yum install -y nginx
# Enable and start
sudo systemctl enable nginx.service
sudo systemctl start nginx.service
# Install global node modules
sudo npm install -g gulp
sudo npm install -g bower

#
# Install PHP 5.6.x
# --------------------------------
# install package and modules
sudo yum-config-manager --enable remi-php56
sudo yum update -y
sudo yum install -y php php-fpm php-bcmath php-gd php-intl php-mbstring php-mysql php-xml php-mcrypt php-apcu
# permissions
sudo chown root:nginx -R /var/lib/php/session
# Configurações php.ini
sudo sed -i '/;date.timezone.*=/c date.timezone = America/Sao_Paulo' /etc/php.ini
sudo sed -i '/display_errors.*=.*Off/c display_errors = On' /etc/php.ini
sudo sed -i '/display_startup_errors.*=.*Off/c display_startup_errors = On' /etc/php.ini
# Enable and start
sudo systemctl enable php-fpm.service
sudo systemctl start php-fpm.service
# composer (PHP Package manager)
sudo curl -sS https://getcomposer.org/installer | sudo  php -- --install-dir=/usr/local/bin --filename=composer

#
# Node JS
# --------------------------------
sudo yum install -y nodejs
sudo yum install -y npm
# Install NVM (Node Version Manager)
#sudo curl https://raw.githubusercontent.com/creationix/nvm/v0.13.1/install.sh | bash
#source ~/.bash_profile
#nvm list-remote
#nvm install v6.3.1
#nvm use v6.3.1
#sudo cp /usr/local/bin/node /bin/node

#
# MariaDB
# --------------------------------
# Repository include
cat > /etc/yum.repos.d/MariaDB.repo <<EOL
# MariaDB 10.1 CentOS repository list - created 2016-08-06 00:07 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOL
# Install package
sudo yum install -y MariaDB-server MariaDB-client
# Enable service
sudo systemctl enable mariadb.service
sudo systemctl start mariadb.service
# Configure
# Make sure that NOBODY can access the server without a password
# sudo mysql -e "UPDATE mysql.user SET Password = PASSWORD('123abc') WHERE User = 'root'"
# Kill the anonymous users
sudo mysql -e "DROP USER ''@'localhost'"
# Because our hostname varies we'll use some Bash magic here.
sudo mysql -e "DROP USER ''@'$(hostname)'"
# Kill off the demo database
sudo mysql -e "DROP DATABASE test"
# Create user
sudo mysql -e "CREATE USER '${MARIA_DB_USER}'@'localhost' IDENTIFIED BY '${MARIA_DB_PASSWD}'"
sudo mysql -e "GRANT ALL PRIVILEGES ON * . * TO '${MARIA_DB_USER}'@'localhost'"
# Make our changes take effect
sudo mysql -e "FLUSH PRIVILEGES"

#
# ~/.bashrc
# --------------------------------
sudo cat /vagrant/bashrc >> /home/vagrant/.bashrc


#!/bin/bash

#This Script will setup and install a pHp 7, Nginx, phpMyAdmin and MariaDB
#Durning the Install process you will be prompted for some input. such as set password for MariaDB

clear
echo "This is a script that will install and configure a php7, Nginx, phpMyAdmin and MariaDB lemp stack"
echo "You will be prompted to input some information, such as password for mariadb"
echo "

"

read -p  "Do you wish to continue with this Script. Press [ENTER] to continue"

sleep 2

echo "






"

echo "--------------------------------------------------------------------------------------------------"
echo "---------------------------------Removing Previous Installations----------------------------------"
echo "--------------------------------------------------------------------------------------------------"

echo "Removing Apache2"
echo "

"

service apache2 stop | echo "Apache2 Stopped"
update-rc.d -f apache2 remove
apt-get -y remove apache2 |  echo "Apache2 Removed"

echo "Removing MySQL"
echo "

"
apt-get purge -y mysql-server mysql-client

echo "MySQL Removed"

echo "

"
echo "Removing PHP"
apt-get -y purge php7

echo "

"
sleep 1

clear

sleep 2
echo "-----------------------------------------------------------------------"
echo "------------------------Begining Installation--------------------------"
echo "-----------------------------------------------------------------------"

echo "


"
###########################
### Installation of PHP ###
##########################
echo "Installing PHP"
echo "

"
sleep 1

add-apt-repository -y ppa:ondrej/php -y
apt update
apt -y install php7.2 php7.2-cli php7.2-gd php7.2-mysql php7.2-pdo php7.2-mbstring php7.2-tokenizer php7.2-bcmath php7.2-xml php7.2-fpm php7.2-curl php7.2-zip

sleep 0.5
sed -i 's/;cgi\.fix_pathinfo=1/cgi\.fix_pathinfo=0/g' /etc/php/7.2/fpm/php.ini

echo "

"
service php7.2-fpm restart | echo "Restarted PHP"

echo "PHP Installed"

echo "


"
#######################################
### Installation Of Nginx Webserver ###
#######################################
echo "Installing Nginx"
echo "

"
sleep 1
apt-get -y install nginx
clear
sleep 0.5
read -p "Downloading Nginx Conf. Press [ENTER] to begin"
wget https://pastebin.com/raw/ih3f011P
mv ih3f011P default
mv default /etc/nginx/sites-available/default

echo "

"

service nginx restart | echo "Restarted Nginx"

echo "Creating info.php, if the page opens correctly then Ngix and PHP is working"
echo "<?php phpinfo(); ?>" | tee /var/www/html/info.php

echo "

"
sleep 0.2
echo "Nginx Installed"

echo "

"

#######################################
### Installation Of PhpmyAdmin ###
#######################################
echo "Installing phpMyAdmin"
echo "

"
echo "When installing phpMyAdmin you will be prompted to select which webserver your using\n 
When this prompt appears press [TAB] then [ENTER]

Please follow the steps shown on screen"

read -p "Please press [ENTER] to begin"

sleep 1
apt-get -y install phpmyadmin
clear
sleep 0.5

ln -s /usr/share/phpmyadmin /var/www/html/

echo "

"
echo "phpMyAdmin Installed"

echo "

"
sleep 1
clear


#######################################
### Installation Of MariaDB ###
#######################################
echo "Installing MariaDB"
echo "

"
echo "For the installation of MariaDB I will need some information to setup your account privalges for phpMyAdmin"
echo "

"

sleep 1
apt-get -y install mariadb-server mariadb-client
clear
sleep 2

echo "

"
clear 

read -p "Please enter your desired MySQL username:  " USER
echo $USER
read -p "Please enter your desired MySQL password:  " PASS
echo $PASS
read -p "Please enter your desired ROOT password:  " ROOTPASS
echo $ROOTPASS

########################################
### Secure MySQL Installation Script ###
#######################################
apt-get -y install expect

MYSQL_ROOT_PASSWORD=$ROOTPASS

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"

apt-get -y purge expect

sleep 1


######################
### MySQL Commands ###
######################
echo "
CREATE USER '$USER'@'localhost' IDENTIFIED BY '$PASS';
GRANT ALL PRIVILEGES ON *.* TO '$USER'@'localhost' WITH GRANT OPTION;
CREATE USER '$USER'@'%' IDENTIFIED BY '$PASS';
GRANT ALL PRIVILEGES ON *.* TO '$USER'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;" >> commands.sql

mysql < "commands.sql"

echo "MariaDB Installed"

echo "

"
sleep 1
clear


#############################
### Installation Complete ###
#############################
echo "PHP, phpMyAdmin, Ngix and MariaDB are installed and ready for you to use, enjoy"
sleep 0.2
echo "Thank for you using my script. Please report any issues that occurr during the installation"
sleep 2
clear

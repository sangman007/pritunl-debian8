#!/bin/bash

# go to root
cd

# Install Command
apt-get -y install ufw
apt-get -y install sudo

# Install Pritunl
echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.2 main" > /etc/apt/sources.list.d/mongodb-org-3.2.list
echo "deb http://repo.pritunl.com/stable/apt jessie main" > /etc/apt/sources.list.d/pritunl.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 42F3E95A2C4F08279C4960ADD68FA50FEA312927
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
apt-get -y update
apt-get -y upgrade
apt-get install pritunl mongodb-org
systemctl start mongod pritunl
systemctl enable mongod pritunl

# Install Squid
apt-get -y install squid3
cp /etc/squid3/squid.conf /etc/squid3/squid.conf.orig
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/dathai/pritunl-debian8/master/API/squid.conf" 
MYIP=$(wget -qO- ipv4.icanhazip.com);
sed -i s/xxxxxxxxx/$MYIP/g /etc/squid3/squid.conf;
service squid3 restart

# Enable Firewall
sudo ufw allow 22,80,81,222,443,8080,9700,60000,1194/tcp
sudo ufw allow 22,80,81,222,443,8080,9700,60000,1194/udp
sudo yes | ufw enable

#FIGlet In Linux
sudo apt-get install figlet
yum install figlet

# About
clear
echo "Script Pritunl Auto Install"
figlet "THAI-VPN"
echo "-Pritunl"
echo "-MongoDB"
echo "-Squid Proxy Port 80,8080"
echo "BY THAIVPN"
echo "TimeZone   :  Bangkok"
echo "Pritunl    :  https://$MYIP"
echo "Please Copy Code Go To Installer"
pritunl setup-key

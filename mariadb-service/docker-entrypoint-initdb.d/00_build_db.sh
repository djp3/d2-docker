#!/bin/bash
#This work is done by the image on build

#The docker-compose file is making sure that all ip address have the same first
# 16 bits of address, eg., 172.30.*.*

DP_IP_DB=`host db | cut -d' ' -f4 | cut -d'.' -f1,2`
#DP_IP_MONO=`host mono | cut -d' ' -f4 | cut -d'.' -f1,2`
#DP_IP_ADMINER=`host adminer | cut -d' ' -f4 | cut -d'.' -f1,2`

#echo $DP_IP_DB
#echo $DP_IP_MONO
#echo $DP_IP_ADMINER
mysql --user root --password="$MYSQL_ROOT_PASSWORD" << EOF
create database opensim;
create user '$DP_DATABASE_USER'@'localhost' IDENTIFIED BY '$DP_DATABASE_USER_PASSWORD';
grant all on opensim.* to '$DP_DATABASE_USER'@'localhost';
create user '$DP_DATABASE_USER'@'$DP_IP_DB.0.0/255.255.0.0' IDENTIFIED BY '$DP_DATABASE_USER_PASSWORD';
grant all on opensim.* to '$DP_DATABASE_USER'@'$DP_IP_DB.0.0/255.255.0.0';
FLUSH PRIVILEGES;
EOF

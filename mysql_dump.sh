#!/bin/bash
############################################################################################
# This is a simple script to create a snapshot of a MySQL server.
# It finds all databases in the server, and creates a single gzipped dump
# of each one using the mysqldump command, suitable for being backed up by bacula.
#
# Run it from cron like that
# 01 4 * * * /root/bin/dumpmysql.sh 2>&1 |logger
# Send bugreports, fixes, enhancements, t-shirts, money, beer & pizza to devnull@mielnet.pl
#############################################################################################

#------------ variables
# Directory to store backups in
DST=/backup/dbback_mysql
# Dump the MySQL database
#----------- variables
# A regex, passed to egrep -v, for which databases to ignore
IGNREG='^snort$'
# The MySQL username and password
DBUSER=root
DBPASS=password_goes_here
# Any backups older than this will be deleted first
KEEPDAYS=4
DATE=$(date  +%Y-%m-%d)
#------------ code
/bin/logger "Starting MySQL Dump....."
# cd $DST
find ${DST} -type f -mtime +${KEEPDAYS} -exec rm -f {} \;
rmdir $DST/* 2>/dev/null

mkdir -p ${DST}/${DATE}
for db in $(echo 'show databases;' | mysql -s -u ${DBUSER} -p${DBPASS} | egrep -v ${IGNREG}) ; do
        echo -n "Backing up ${db}... "
        mysqldump --opt -u ${DBUSER} -p${DBPASS} $db | gzip -c > ${DST}/${DATE}/${db}.txt.gz
        echo "Done."
done
/bin/logger "OK, all MySQl dumps done in $DST"

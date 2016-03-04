#!/bin/bash
#############################################################################
# This is a simple script to create a snapshot of a PostgreSQL server.
# We need to list databases we want to back up in `db` variable below,
# existing dbs can be identified with
# psql --username=postgres -l 
# 
# Send bugreports, fixes, enhancements, t-shirts, money, beer & pizza to devnull@mielnet.pl
#############################################################################

#------------ variables
# Directory to store backups in
DST=/backup/dbback_postgresql
DATABASES="postgres rhnschema"
# Any backups older than this will be deleted first
KEEPDAYS=7
DATE=$(date  +%Y-%m-%d)
#------------ code
/bin/logger "Starting PostgreSQL Dump....."
# cd $DST
find ${DST} -type f -mtime +${KEEPDAYS} -exec rm -f {} \;
rmdir $DST/* 2>/dev/null
mkdir -p ${DST}/${DATE}
chown postgres. ${DST}/${DATE}
for db in $DATABASES ; do
        echo -n "Backing up ${db}... " | logger
	su - postgres -c  "pg_dump ${db} |gzip -c > ${DST}/${DATE}/${db}-`date +%Y%m%d`.sql.gz"
        echo -n "Done with $db." | logger
done
/bin/logger "OK, all PostgreSQL dumps done in $DST"

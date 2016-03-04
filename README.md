Scripts to be run from cron. For MySQL Stick a copy to /root/bin/dumpmysql.sh 
making sure you provided mysql root password. Then crontab -e and add this line

    01 4 * * * /root/bin/dumpmysql.sh 2>&1 |logger

Adjust execution time to your needs, to fire up script before file backup session takes place.


For PostgreSQL stick a copy to /root/bin/postgresql_dump.sh making usre you specify databases you want to dump

    01 4 * * * /root/bin/postgresql_dump.sh 2>&1 |logger



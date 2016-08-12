#!/bin/bash
# Add this script to cronjob
# 30 6 * * * /root/bin/zfsSync.sh 2>&1 |logger
#  I use zfs-auto-snapshot for daily autosnaphots, otherwise it should be easy to add snapshot below, before being sent
LASTSENT=`cat /root/lastsnap.var`
OLDERSNAP=`/sbin/zfs list -t snapshot|grep vmfs |tail -n2|head -n1|cut -d" " -f1`
LASTSNAP=`/sbin/zfs list -t snapshot|grep vmfs |tail -n1|cut -d" " -f1`

# TODO
# email warning, manual intervention needed
# 	if [ $LASTSENT -eq $OLDERSNAP ]; then 
# zfs send -v -R -i $OLDERSNAP $LASTSNAP | bzip2 | ssh root@abc-nas0 bunzip2 | zfs receive -Fduv tank/vmfs
/sbin/zfs send -v -i $OLDERSNAP $LASTSNAP | ssh root@abc-nas0 /sbin/zfs receive -Fv tank/vmfs
echo $LASTSNAP > /root/lastsnap.var
#	else
# 	echo "Last sent snapshot differs from what we've got. Check manually"
#	exit 0
#fi

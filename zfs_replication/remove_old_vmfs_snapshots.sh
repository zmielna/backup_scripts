#!/bin/bash

# Add this script on target machine (where you are syncing zfs filesystem to) to cron, say:
# 30 23 * * * /root/bin/remove_old_vmfs_snapshots.sh 2>&1 |logger
# 
# OK, lets do it - we only keep last 7 snapshots
HOWMANY=`zfs list -t snapshot|grep vmfs|wc -l`
echo "----------------------------------------------------"
echo "Starting to prune old snapshots of VMFS filesystem"
if [ -z "$HOWMANY" ]; then
	exit 0
fi

if [ "$HOWMANY" -lt 8 ]; then
	# exit 0
	echo "####  we have $HOWMANY snaps, nothing to delete, exiting"
else
	TOREMOVE=`zfs list -t snapshot|grep vmfs |cut -d" " -f1|head -n -7|xargs`
	echo "####  removing older snapshots:"
	for i in $TOREMOVE; 
		do	
			echo zfs destroy $i;
		 	zfs destroy $i;
	done
fi
echo "----------------------------------------------------"

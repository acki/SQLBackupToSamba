#!/bin/bash

# Script for take a MySQL snapshot and save it to a Windows/Samba share
#
# @author Christoph S. Ackermann <info@acki.be>

source /usr/local/etc/SQLBackupToSamba.cfg

if [ ! -d $MOUNTFOLDER ]; then
	mkdir $MOUNTFOLDER
fi

mount -t cifs $SMBFOLDER $MOUNTFOLDER -o user=$SMBUSER,password=$SMBPASS

ndate=`date +%Y%m%d`
date=`date -d "$ndate 00:00" +%s`

tdate=$(($KEEPDAYS*86400))

if [ -f $MOUNTFOLDER/backup.$ndate.sql.gz ]; then
	echo "Backup from today already exists. Do nothing."
	exit 1
fi

files=$(find $MOUNTFOLDER -type f -name "*.sql*")

for file in $files
do
	arr=(${file//./ })
	compare=`date -d ${arr[1]} +%s`
	limit=$(($date-$tdate))
	if [[ $compare < $limit ]]; then
		rm $file
	fi
done

mysqldump -u$SQLUSER -p$SQLPASS --all-databases > $MOUNTFOLDER/backup.$ndate.sql
gzip $MOUNTFOLDER/backup.$ndate.sql

umount $MOUNTFOLDER

sleep 1

rm -rf $MOUNTFOLDER

echo "Created backup from SQL database to \"$SMBFOLDER\" named backup.$ndate.sql.gz"
exit 0
#!/bin/bash

source /usr/local/etc/SQLBackupToSamba.cfg

if [ ! -d $MOUNTFOLDER ]; then
	mkdir $MOUNTFOLDER
fi

mount -t cifs $SMBFOLDER $MOUNTFOLDER -o user=$SMBUSER,password=$SMBPASS

touch $MOUNTFOLDER/backup.20110322.sql.gz

tdate=`date +%Y%m%d`
date=`date -d "$tdate 00:00" +%s`

tdate=$(($KEEPDAYS*86400))

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

mysqldump -u$SQLUSER -p$SQLPASS --all-databases > $MOUNTFOLDER/backup.`date +%d%m%Y`.sql
gzip $MOUNTFOLDER/backup.`date +%d%m%Y`.sql

ls -lah $MOUNTFOLDER

umount $MOUNTFOLDER

cd /tmp

rm -rf $MOUNTFOLDER
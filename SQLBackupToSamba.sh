#!/bin/bash

source /usr/local/etc/SQLBackupToSamba.cfg

mkdir $TEMPFOLDER
mkdir $MOUNTFOLDER

mount -t cifs $SMBFOLDER $MOUNTFOLDER -o user=$SMBUSER,password=$SMBPASS

touch $MOUNTFOLDER/backup.20110322.sql.gz

tdate=`date +%Y%m%d`
date=`date -d "$tdate 00:00" +%s`

tdate=$(($KEEPDAYS*86400))

files=$(find $MOUNTFOLDER -type f -name "*.sql*")

for file in $files
do
	arr=$(echo $file | tr "." "\n")
	if [ `date -d ${arr[1]} +%s` < $(($date-$tdate)) ] then
		echo "hallo"
	fi
done

mysqldump -u$SQLUSER -p$SQLPASS --all-databases > $TEMPFOLDER/backup.sql

cp $TEMPFOLDER/backup.sql $MOUNTFOLDER
ls -lah $MOUNTFOLDER

umount $MOUNTFOLDER

rm -rf $TEMPFOLDER
rm -rf $MOUNTFOLDER
#!/bin/bash

source /usr/local/etc/SQLBackupToSamba.cfg

mkdir $TEMPFOLDER
mkdir $MOUNTFOLDER

mysqldump -u$SQLUSER -p$SQLPASS --all-databases > $TEMPFOLDER/backup.sql

mount -t cifs $SMBFOLDER $MOUNTFOLDER -o user=$SMBUSER,password=$SMBPASS

ls $MOUNTFOLDER
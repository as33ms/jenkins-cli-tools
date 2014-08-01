#!/bin/sh
blacklist="userContent"
backupdir=/home/master/jenkins/backups

cd /var/lib/jenkins

dirs=$(echo */)
#dirs=$(ls -d */)

today=$(date +%Y-%m-%d)

directories=

for adir in $dirs
do
    for black in $blacklist
    do
        echo $adir | grep $black || directories="${adir} ${directories}"
    done
done

# create the backup
tar -czvf $backupdir/${today}.tar.gz $directories

# do some clean up
# policy: last backup from every month kept forever

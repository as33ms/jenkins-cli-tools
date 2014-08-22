#!/bin/sh
id=$(id -ru)
if [ $id -ne 0 ]; then
    echo "You are not allowed to run this script (cron.sh)"
    exit 1
fi
export PATH=$PATH:/sbin:/usr/sbin:/usr/bin:/home/master/maintenance
cd /home/master/maintenance
sh jenkins-backup.sh
sh testlink-backup.sh

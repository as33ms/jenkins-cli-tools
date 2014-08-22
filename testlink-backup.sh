#!/bin/sh
tlink=/var/testlink
today=$(date +%Y-%m-%d)

backupdir=/home/master/backups/testlink
rootcreds=/home/master/maintenance/.rootcreds-mysql

use_root_for_db_backup() {
    sql=$1
    mv $sql $sql.error
    if [ ! -e $rootcreds ]; then
        echo "ERROR: CANNOT COMPLETE BACKUP for testlink"
        exit 1
    fi
    root=$(cat $rootcreds | cut -d ',' -f1)
    rootpass=$(cat $rootcreds | cut -d ',' -f2)
    mysqldump -u$root -p$rootpass $tl_dbname > $sql
}

tl_dbuser=$(cat $tlink/config_db.inc.php | grep DB_USER | cut -d ',' -f2 | sed -e "s:'::g" | sed -e "s:);$::g" | sed -e "s: ::g")
tl_dbpass=$(cat $tlink/config_db.inc.php | grep DB_PASS | cut -d ',' -f2 | sed -e "s:'::g" | sed -e "s:);$::g" | sed -e "s: ::g")
tl_dbname=$(cat $tlink/config_db.inc.php | grep DB_NAME | cut -d ',' -f2 | sed -e "s:'::g" | sed -e "s:);$::g" | sed -e "s: ::g")

mkdir -p $backupdir/$today

backupsql=$backupdir/$today/$tl_dbname.sql
backuptar=$backupdir/$today/installation.tar.gz

mysqldump -u$tl_dbuser -p$tl_dbpass $tl_dbname > $backupsql || use_root_for_db_backup $backupsql
#mysqldump: Got error: 1044: Access denied for user 'testlink'@'localhost' to database 'rwtestlink' when using LOCK TABLES

gzip -f9 $backupsql
tar -cvzf $backuptar $tlink

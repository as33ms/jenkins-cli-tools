#!/bin/sh
today=$(date +%Y-%m-%d)
mwiki=/var/lib/mediawiki

backupdir=/home/master/backups/mediawiki
rootcreds=/home/master/maintenance/.rootcreds-mysql

use_root_for_db_backup() {
    sql=$1
    mv $sql $sql.error
    if [ ! -e $rootcreds ]; then
        echo "ERROR: CANNOT COMPLETE BACKUP for mediawiki"
        exit 1
    fi
    root=$(cat $rootcreds | cut -d ',' -f1)
    rootpass=$(cat $rootcreds | cut -d ',' -f2)
    mysqldump -u$root -p$rootpass $mwikidbase > $sql
}

mwikiuser=$(cat $mwiki/LocalSettings.php | grep wgDBuser | cut -d '=' -f2 | sed -e 's:"::g' | sed -e "s: ::g" | sed -e "s:;::g")
mwikipass=$(cat $mwiki/LocalSettings.php | grep wgDBpassword | cut -d '=' -f2 | sed -e 's:"::g' | sed -e "s: ::g" | sed -e "s:;::g")
mwikidbase=$(cat $mwiki/LocalSettings.php | grep wgDBname | cut -d '=' -f2 | sed -e 's:"::g' | sed -e "s: ::g" | sed -e "s:;::g")

mkdir -p $backupdir/$today

backupsql=$backupdir/$today/$mwikidbase.sql
mysqldump -u$mwikiuser -p$mwikipass $mwikidbase > $backupsql || use_root_for_db_backup $backupsql

backuptar_0=$backupdir/$today/etc_mediawiki.tar.gz
backuptar_1=$backupdir/$today/var_lib_mediawiki.tar.gz
backuptar_2=$backupdir/$today/usr_share_mediawiki.tar.gz
backuptar_3=$backupdir/$today/etc_mediawiki-extensions.tar.gz

gzip -f9 $backupsql
tar -cvzf $backuptar_0 /etc/mediawiki
tar -cvzf $backuptar_1 /var/lib/mediawiki
tar -cvzf $backuptar_2 /usr/share/mediawiki
tar -cvzf $backuptar_3 /etc/mediawiki-extensions

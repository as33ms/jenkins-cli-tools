#!/bin/sh
blacklist="userContent"
backupdir=/home/master/jenkins/backups

# locations
user=buildbot
pass=dPvU3KQhT7Ck
server=http://buildserver:8080
groovy=/home/master/maintenance/status.groovy
clijar=/home/master/maintenance/jenkins-cli.jar

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

echo "Directories to backup:"
echo $directories

java -jar $clijar -s $server groovy $groovy --username $user --password $pass | grep WAIT_MORE -A 10
waitmore=$?


while [ $waitmore -eq 0 ]; do
    sleep 60
    java -jar $clijar -s $server groovy $groovy --username $user --password $pass | grep WAIT_MORE -A 10
    waitmore=$?
done

if [ $waitmore -ne 0 ]; then
    echo "Stop jenkins (safe-shutdown)"
    #java -jar $clijar -s $server safe-shutdown --username $user --password $pass 

    /usr/sbin/service jenkins stop

    echo "Taking backup now"

    mkdir -p $backupdir/$today

    backup=$backupdir/$today/jenkins.tar.gz

    # create the backup
    tar -czvf $backup $directories

    echo "Putting jenkins up again"
    /usr/sbin/service jenkins start
fi

# do some clean up
# policy: last backup from every month kept forever

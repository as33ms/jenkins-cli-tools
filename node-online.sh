#!/bin/sh
# date: Feb 18, 2014
# author: ashakunt <ashakunt@zydus16>
# 
# - brings a node online if its not
# - destined to run only on linux (and not mac at least)
# requirements: ssh-copy-id -i <identity file> <slaveuser>@<slave>

this_file="$(readlink -f $0)"
file_location="$(dirname $this_file)"
export PATH=$file_location:$PATH

# get the slaves we are interested in from the environment
# variable and also the user. If all the salves have different
# user, then this script does not handle that at the moment
SLAVES_TO_CHECK="${SLAVES}"
SLAVE_USER="${SLAVEUSER}"

jenkins-cli.sh groovy $file_location/offline-nodes.groovy | tee offline-nodes.list

echo "bring-online requested for: $SLAVES_TO_CHECK"
echo

for SLAVE in $SLAVES_TO_CHECK; do
    echo "checking: $SLAVE"
    grep -i $SLAVE offline-nodes.list
    if [ $? -eq 0 ]; then
        echo "'$SLAVE' is offline"
        ssh $SLAVE_USER@$SLAVE ls /home/$SLAVE_USER/jenkins
        if [ $? -eq 0 ]; then
            ssh -n -f $SLAVE_USER@$SLAVE "sh -c 'cd /home/$SLAVE_USER/jenkins; nohup ./runjenkins.sh > /dev/null 2>&1 &'"
            if [ $? -ne 0 ]; then
                echo "Failed to bring slave online"
            fi
        else
            echo "Unable to get ssh hook for $SLAVE"
        fi
    else
        echo "$SLAVE is online!"
    fi
done

#!/bin/sh
server="http://buildserver:8080"
if [ ! $@ ]; then
    echo "Please provide an option for the jenkins-cli tool, e.g. help"
else
    java -jar jenkins-cli.jar -s $server $@
fi

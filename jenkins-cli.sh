#!/bin/sh
if [ $1 ]; then
	java -jar jenkins-cli.jar -s http://buildserver:8080/ $1
fi

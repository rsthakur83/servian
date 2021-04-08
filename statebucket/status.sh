#/bin/bash

cmd=`/root/project/terraform show |grep app-alb|awk '{print $3}'|cut -d'"' -f 2`
res=`curl -s $cmd/healthcheck/`
resp="OK"
if [[ $res == $resp ]]
then
   echo "App Responding Ok!!!!!!"
else
   exit 1
fi

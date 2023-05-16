#!/bin/bash

name=`basename $0`
if [ ! -f "/tmp/${name}.lock" ]
then
        touch /tmp/${name}.lock
else

        echo "正在执行";
        exit
fi

# script to collect the cpu and memory usage of the given tool
#
# execute it as a cronjob or in a endless loop:
# while sleep 10; do ./push-top.sh [application-name] ; done;


TOOL=`whoami`
if [ ! -z "$1" ]
then
TOOL=$1
fi

# add load average
var=`cat /proc/loadavg | cut -d' ' -f1 | xargs echo $TOOL"_load_average"`
var="$var
"

# collect cpu usage
# top displays wrong results on the first iteration – run it twice an grep away the firt output
LINES=`top -bcn2 | awk '/^top -/ { p=!p } { if (!p) print }' | tail -n +8`

while read -r LINE
do
IN=`echo "$LINE" | tr -s ' '`
PID=`echo $IN | cut -d ' ' -f1 `
CMD="`echo $IN | cut -d ' ' -f12 ` ` echo $IN | cut -d ' ' -f13` ` echo $IN | cut -d ' ' -f14`"
CPU=`echo $IN | cut -d ' ' -f9 `
MEM=`echo $IN | cut -d ' ' -f10 `



#var=$var$(printf "${TOOL}_cpu_usage{process=\"$CMD\", pid=\"$PID\"} $CPU\n")
var=$var$(printf "cpu_usage{process=\"$CMD\", pid=\"$PID\"} $CPU\n")
var="$var
"
#var=$var$(printf "${TOOL}_memory_usage{process=\"$CMD\", pid=\"$PID\"} $MEM\n")
var=$var$(printf "memory_usage{process=\"$CMD\", pid=\"$PID\"} $MEM\n")
var="$var
"
done <<< "$LINES"

# push to the prometheus pushgateway
# 推送到 prometheus pushgateway
rm -f /tmp/${name}.lock

echo "$var
" | curl -X POST -H "Content-Type: text/plain" --data-binary @- http://192.168.88.35:9091/metrics/job/236-top/instance/machine
#!/bin/bash

ip_list=("192.168.1.2" "192.168.1.3")

script=create-proxy.sh

thread=${#ip_list[@]}

tmp_fifofile=/tmp/$$.fifo
mkfifo $tmp_fifofile
exec 50<> $tmp_fifofile
rm $tmp_fifofile

for i in `seq $thread`
do
        echo >&50
done

i=0
for ip in ${ip_list[@]}
do
  read -u 50
  {

      scp $script root@${ip}:/home/ && ssh root@${ip} "cd /home ;  chmod +x $script ; ./$script $ip;rm -f $script;"

  echo >&50
  }&
done
wait
exec 50>&-







#!/bin/bash

function del_log(){

for file in `ls $1 `
do

f=$1"/"$file


 if [ -d $1"/"$file ]
 then
   echo $f
   del_log $1"/"$file $2

 fi




 if [ -f $1"/"$file ]
 then
	a1=`stat -c %Y $1"/"$file`
	b1=`date +%s`
	if [ $[ $b1 - $a1 ] -gt $2 ];then
        	ls -lh $1"/"$file
        	rm -f $1"/"$file

	fi
 fi

done
}

path=$1
time=$2

if [ ! -d $path ]
then

  echo "请输入文件夹路径"
  exit
fi

del_log $path $time


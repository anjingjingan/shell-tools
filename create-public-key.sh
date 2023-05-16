#!/bin/bash

server=$1
passwd=$2

if [ ${server} = "" ] || [ ${passwd} = "" ]
then

echo "账户密码为空"
exit

fi

#使用密码登录远程服务器，创建公钥
#Log in to the remote server with a password and create a public key
expect << EOF
#远程登录
spawn ssh root@${server}
expect {
    "yes/no" {send "yes\r";exp_continue}
    "*assword" {send "${passwd}\n"}
}

#创建公钥
expect "root@*"  {send "ssh-keygen -t rsa\r"}
expect "*.ssh/id_rsa"  {send "\r"}
expect "*passphrase"  {send "\r"}
expect "*again"  {send "\r"}
expect "*"  {send "\r"}

expect eof
EOF


#本机公钥上传到目标服务器
#Upload the public key to the management server
expect << EOF
spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@${server}

expect {
    "yes/no" {send "yes\r"}
    "*assword" {send "${passwd}\n"}
}

expect eof
EOF


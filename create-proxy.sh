#!/bin/bash

cat > /home/proxy.sh <<-'EOF'
echo off
mkdir /etc/gost
cd /etc/gost
yum install wget -y
wget https://leaddeal.oss-cn-shenzhen.aliyuncs.com/gost/gost_2.11.1/linux_x64/gost

chmod 777 /etc/gost/gost
cd /usr/lib/systemd/system

echo [Unit]>gost.service
echo Description=Gost Proxy>>gost.service
echo After=network.target>>gost.service
echo Wants=network.target>>gost.service
echo [Service]>>gost.service
echo Type=simple>>gost.service
echo ExecStart=/etc/gost/gost -L=https://bluelans:KGr63uApb29cNN2S@0.0.0.0:20008>>gost.service
echo Restart=always>>gost.service
echo [Install]>>gost.service
echo WantedBy=multi-user.target>>gost.service

systemctl daemon-reload
systemctl enable gost
systemctl restart gost

echo 128 > /proc/sys/net/ipv4/ip_default_ttl

echo "00 02 * * * root /sbin/reboot" >>/etc/crontab
service crond start
EOF

cat <<EOF>> /etc/sysctl.conf
net.ipv4.ip_default_ttl = 128
EOF
sysctl -p


chmod +x /home/proxy.sh
/home/proxy.sh

rm -f /home/proxy.sh

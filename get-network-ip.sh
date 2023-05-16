#!/bin/bash

# Get all interfaces
# 获取所有网口接口
interfaces=$(ls /sys/class/net)

# Loop through all interfaces
# 循环所有网口接口
for interface in $interfaces; do
    # Get IP address and subnet mask
    # 获取IP地址和子网掩码
    ip_info=$(ip addr show dev $interface | awk '/inet /{print $2}')

    # Get IP address
    # 获取 IP 地址
    ip=$(echo $ip_info | awk -F/ '{print $1}')

    # Check if IP address starts with 192.168
    # 检查IP地址是否以 192.168 开头，过滤 docker 容器 ip
    if [[ $ip == 192.168* ]]; then
        echo "$interface:$ip"
    fi
done

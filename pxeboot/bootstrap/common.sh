#!/bin/bash

# This file setups the common packages and configurations, including:
#
# 0. change the apt sources
# 1. install packages: sudo, vim, p7zip-full
# 2. change the default shell to /bin/bash
# 3. change the DNS server to 192.168.64.1
# 4. install NTP client, and set the NTP server to 192.168.64.1

# 0. change the apt sources
cat > /etc/apt/sources.list << EOF
deb http://192.168.64.1:8080/debian/ jessie main contrib non-free
deb http://192.168.64.1:8080/debian/ jessie-updates main contrib non-free
deb http://192.168.64.1:8080/debian/ jessie-backports main contrib non-free
deb http://192.168.64.1:8080/debian-security/ jessie/updates main contrib non-free

deb-src http://192.168.64.1:8080/debian/ jessie main contrib non-free
deb-src http://192.168.64.1:8080/debian/ jessie-updates main contrib non-free
deb-src http://192.168.64.1:8080/debian/ jessie-backports main contrib non-free
deb-src http://192.168.64.1:8080/debian-security/ jessie/updates main contrib non-free
EOF

apt-get update

# 1. install packages: sudo, vim, p7zip-full
apt-get install -y vim p7zip-full sudo

# 2. change the default shell to /bin/bash
sed -i 's!SHELL=/bin/sh!SHELL=/bin/bash!g' /etc/default/useradd

# 3. change the DNS server to 192.168.64.1
cat > /etc/resolv.conf << EOF
nameserver 192.168.64.1
EOF

# 4. install NTP client, and set the NTP server to 192.168.64.1
apt-get install -y ntp
cat > /etc/ntp.conf << EOF
driftfile /var/lib/ntp/ntp.drift

statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable

server 192.168.64.1 iburst
restrict -4 default kod notrap nomodify nopeer noquery
restrict -6 default kod notrap nomodify nopeer noquery

restrict 127.0.0.1
restrict ::1
EOF

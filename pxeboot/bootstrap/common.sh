#!/bin/bash

# This file setups the common packages and configurations, including:
#
# 0. change the apt sources
# 1. install packages: sudo vim p7zip-full git build-essential ifenslave iperf dnsutils curl
# 2. change the default shell to /bin/bash
# 3. change the DNS server to 192.168.64.1
# 4. install NTP client, and set the NTP server to 192.168.64.1
# 5. Turn on SSH login for root.
# 6. Load bonding module at boot time.

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

# 1. install packages
apt-get install -y sudo vim p7zip-full git build-essential ifenslave iperf dnsutils curl

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

# 5. Turn on SSH login for root.
#
# Why do we turn on root login?  Just in case the Gateway is out of service.  Under that situation,
# '/home', which is an NFS directory on Gateway, will disappear.  So it will become hard for a local
# user, like 'labmaster', to use the servers.  So we allow root to login.
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# 6. Load bonding module at boot time.
echo "bonding" >> /etc/modules

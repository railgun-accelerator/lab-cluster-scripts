#!/bin/bash

# This script will overwrite the system apt sources with gateway

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

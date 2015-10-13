#!/bin/bash

# This script will install MooseFS and setup config files.

# Add debian sources and accept apt-key
wget -O - http://ppa.moosefs.com/moosefs.key | apt-key add -
echo "deb http://192.168.64.1:8080/moosefs/ jessie main" > /etc/apt/sources.list.d/moosefs.list
apt-get update -y

# Install moosefs client
apt-get install -y moosefs-client fuse

# Mount mfs at /mnt/mfs
mkdir -p /mnt/mfs
echo "/usr/bin/mfsmount  /mnt/mfs  fuse  mfsmaster=192.168.65.1,mfsport=9421,_netdev  0  0" >> /etc/fstab

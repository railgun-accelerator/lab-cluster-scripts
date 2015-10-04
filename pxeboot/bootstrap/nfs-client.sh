#!/bin/bash

# This script will mount NFS home to /etc/fstab

apt-get install -y nfs-common
echo "192.168.64.1:/srv/nfs/home  /home   nfs      rw,sync,soft,intr  0     0" >> /etc/fstab

# Mount all file systems (in case this script is called after system installation)
mount -a

#!/bin/bash

# This file will download and execute these scripts under 'bootstrap' directory:
#
# 1. common.sh
# 2. ldap-client.sh
# 3. nfs-client.sh
# 4. hdfs-client.sh
# 5. mfs-client.sh

function execRemote {
    script_name="$1"
    wget -O - http://192.168.64.1:8081/git-managed/pxeboot/bootstrap/${script_name} | bash
}

execRemote "common.sh"
execRemote "ldap-client.sh"
execRemote "nfs-client.sh"
execRemote "hdfs-client.sh"
execRemote "mfs-client.sh"

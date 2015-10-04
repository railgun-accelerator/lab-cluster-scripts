#!/bin/bash

# This file will download and execute these scripts under 'bootstrap' directory:
#
# 1. common.sh

function execRemote {
    script_name="$1"
    wget -O - http://192.168.64.1:8081/git-managed/pxeboot/bootstrap/${script_name} | bash
}

execRemote "common.sh"

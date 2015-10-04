#!/bin/bash

# Simulate the human configuration on libnss-ldapd
debconf-set-selections << EOF
nslcd   nslcd/ldap-uris string  ldaps://ldap.peidan.me
nslcd   nslcd/ldap-base string  dc=ldap,dc=peidan,dc=me
libnss-ldapd    libnss-ldapd/nsswitch   multiselect aliases, ethers, group, hosts, netgroup, networks, passwd, protocols, rpc, services, shadow
libpam-runtime  libpam-runtime/profiles multiselect unix, ldap
EOF

DEBIAN_FRONTEND=noninteractive apt-get install -y libnss-ldapd libpam-ldapd

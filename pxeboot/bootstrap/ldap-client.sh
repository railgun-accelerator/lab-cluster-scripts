#!/bin/bash

# Simulate the human configuration on libnss-ldapd
debconf-set-selections << EOF
nslcd   nslcd/ldap-uris string  ldaps://ldap.peidan.me
nslcd   nslcd/ldap-reqcert  select  try
nslcd   nslcd/ldap-base string  dc=ldap,dc=peidan,dc=me
libnss-ldapd    libnss-ldapd/nsswitch   multiselect aliases, ethers, group, hosts, netgroup, networks, passwd, protocols, rpc, services, shadow
libpam-runtime  libpam-runtime/profiles multiselect unix, ldap
EOF

DEBIAN_FRONTEND=noninteractive apt-get install -y libnss-ldapd libpam-ldapd

# It seems that Debian 8.x need this special trick to make nslcd work properly, apart from the above debian config
cat > /etc/ldap/ldap.conf << EOF
BASE    dc=ldap,dc=peidan,dc=me
URI     ldaps://ldap.peidan.me
EOF

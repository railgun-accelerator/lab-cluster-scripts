#!/bin/bash

# Simulate the human configuration on libnss-ldapd
cat | debconf-set-selections << EOF
libnss-ldap shared/ldapns/ldap_version  select  3
libpam-ldap shared/ldapns/ldap_version  select  3
libnss-ldap shared/ldapns/ldap-server   string  ldaps://ldap.peidan.me
libpam-ldap shared/ldapns/ldap-server   string  ldaps://ldap.peidan.me
libnss-ldap libnss-ldap/confperm    boolean false
libpam-ldap libpam-ldap/rootbinddn  string  cn=admin,dc=ldap,dc=peidan,dc=me
libnss-ldap shared/ldapns/base-dn   string  dc=ldap,dc=peidan,dc=me
libpam-ldap shared/ldapns/base-dn   string  dc=ldap,dc=peidan,dc=me
EOF

#!/bin/bash

# This script will install HDFS and setup config files.

VERSION=2.7.1

# Install JDK 8
apt-get install -y openjdk-8-jdk

# Install Hadoop to /opt/hadoop-$VERSION, and link to /opt/hadoop
mkdir -p /opt
cd /opt
wget -c -O /tmp/hadoop-$VERSION.tar.gz http://192.168.64.1:8081/hadoop/hadoop-$VERSION.tar.gz
tar xzvf /tmp/hadoop-$VERSION.tar.gz
ln -s /opt/hadoop-$VERSION /opt/hadoop
rm -f /tmp/hadoop-$VERSION.tar.gz

# Setup config files to use HDFS at 192.168.65.1:9000
sed -i 's!export JAVA_HOME=${JAVA_HOME}!export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"!g' /opt/hadoop/etc/hadoop/hadoop-env.sh
wget -O /opt/hadoop/etc/hadoop/core-site.xml http://192.168.64.1:8081/git-managed/pxeboot/resources/hadoop/core-site.xml

# Add HDFS path to system global
echo 'export PATH="$PATH:/opt/hadoop/bin"' >> /etc/profile

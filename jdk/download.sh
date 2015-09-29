#!/bin/bash

# usage: get_jdk.sh <jdk_version> <rpm|tar>
# jdk_version: default 8
# rpm

# source: https://gist.github.com/n0ts/40dd9bd45578556f93e7

JDK_VERSION="8"
EXT="tar.gz"

if [ -n "$1" ]; then
  if [ "$1" == "7" ]; then
    JDK_VERSION="7"
  fi
fi

if [ -n "$2" ]; then
  if [ "$2" == "rpm" ]; then
    EXT="rpm"
  fi
fi

URL="http://www.oracle.com"
JDK_DOWNLOAD_URL1="${URL}/technetwork/java/javase/downloads/index.html"
JDK_DOWNLOAD_URL2=`curl -s $JDK_DOWNLOAD_URL1 | grep -Po "\/technetwork\/java/\javase\/downloads\/jdk${JDK_VERSION}-downloads-.+?\.html" | head -1`
if [ -z "$JDK_DOWNLOAD_URL2" ]; then
  echo "Could not get jdk download url - $JDK_DOWNLOAD_URL1"
  exit 1
fi

JDK_DOWNLOAD_URL3="${URL}${JDK_DOWNLOAD_URL2}"

JDK_DOWNLOAD_URL4=`curl -s $JDK_DOWNLOAD_URL3 | egrep -o "http\:\/\/download.oracle\.com\/otn-pub\/java\/jdk\/[7-8]u[0-9]+\-(.*)+\/jdk-[7-8]u[0-9]+(.*)linux-x64.${EXT}"`

wget -c \
  --no-cookies \
  --no-check-certificate \
  --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  $JDK_DOWNLOAD_URL4

echo "${JDK_DOWNLOAD_URL4##*/}"

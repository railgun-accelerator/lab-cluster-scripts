#!/bin/bash

echo "This script will download the latest version of jdk 7 & 8 and make a deb package."

function package {
    VERSION="$1"

    # download jdk tar.gz archive
    JDK_TAR_FILE=`/bin/bash download.sh $VERSION`
    if [ "$?" != "0" ]; then
        echo "Download JDK$VERSION failed."
        exit 1
    fi

    # pack jdk to debian package
    JDK_DEB_FILE="${JDK_TAR_FILE/tar.gz/deb}"

    if [ ! -f "$JDK_DEB_FILE" ]; then
        echo "New version of JDK$VERSION found, will make debian package ${JDK_DEB_FILE} ..."
        (mkdir .work && 
            chown www-data:root .work && 
            cd .work && 
            sudo -u www-data fakeroot make-jpkg ../"$JDK_TAR_FILE" && 
            chown root:root *.deb &&
            mv *.deb ../"$JDK_DEB_FILE"
        )
        rm -rf .work
    fi

    # create a generic link to the package
    ln -f -s "$JDK_DEB_FILE" "jdk$VERSION-linux-x64.deb"
}

package "8"

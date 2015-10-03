#!/bin/bash

rm -f /srv/tftp/pxelinux.cfg
rsync -avP pxelinux.cfg/ /srv/tftp/pxelinux.cfg
rsync -avP installers/ /srv/tftp/installers

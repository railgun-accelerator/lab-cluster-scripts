#!/bin/bash

rm -f /srv/tftp/pxelinux.cfg
rsync -avP pxelinux.cfg/ /srv/tftp/bios/pxelinux.cfg
rsync -avP pxelinux.cfg/ /srv/tftp/efi32/pxelinux.cfg
rsync -avP pxelinux.cfg/ /srv/tftp/efi64/pxelinux.cfg

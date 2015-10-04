#!/bin/bash

rm -f /srv/tftp/pxelinux.cfg
rm -f /srv/tftp/pxelinux.0

cd /tmp
wget https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.gz
tar -xvf syslinux-6.03.tar.gz

mkdir -p /srv/tftp/bios
cp syslinux-6.03/bios/core/pxelinux.0 /srv/tftp/bios/
cp syslinux-6.03/bios/com32/elflink/ldlinux/ldlinux.c32 /srv/tftp/bios/
cp syslinux-6.03/bios/com32/lib/libcom32.c32 /srv/tftp/bios/
cp syslinux-6.03/bios/com32/libutil/libutil.c32 /srv/tftp/bios/
cp syslinux-6.03/bios/com32/menu/vesamenu.c32 /srv/tftp/bios/
cp syslinux-6.03/bios/com32/modules/pxechn.c32 /srv/tftp/bios/

mkdir -p /srv/tftp/efi64
cp syslinux-6.03/efi64/efi/syslinux.efi /srv/tftp/efi64/
cp syslinux-6.03/efi64/com32/elflink/ldlinux/ldlinux.e64 /srv/tftp/efi64/
cp syslinux-6.03/efi64/com32/lib/libcom32.c32 /srv/tftp/efi64/
cp syslinux-6.03/efi64/com32/libutil/libutil.c32 /srv/tftp/efi64/
cp syslinux-6.03/efi64/com32/menu/vesamenu.c32 /srv/tftp/efi64/
cp syslinux-6.03/efi64/com32/modules/pxechn.c32 /srv/tftp/efi64/

mkdir -p /srv/tftp/efi32
cp syslinux-6.03/efi32/efi/syslinux.efi /srv/tftp/efi32/
cp syslinux-6.03/efi32/com32/elflink/ldlinux/ldlinux.e32 /srv/tftp/efi32/
cp syslinux-6.03/efi32/com32/lib/libcom32.c32 /srv/tftp/efi32/
cp syslinux-6.03/efi32/com32/libutil/libutil.c32 /srv/tftp/efi32/
cp syslinux-6.03/efi32/com32/menu/vesamenu.c32 /srv/tftp/efi32/
cp syslinux-6.03/efi32/com32/modules/pxechn.c32 /srv/tftp/efi32/

rm -rf syslinux-6.03
rm -f syslinux-6.03.tar.gz

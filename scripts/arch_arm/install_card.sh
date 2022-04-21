#!/bin/bash

#!/bin/sh
set -xe
if [ $# -lt 2 ]
	then
	echo "Check device name for micro sd card and recal script with it's name as argument"
	sudo fdisk -l
fi

if [ $# -eq 2 ]
	then
	DEVICE=$1
  #wget -O "`dirname $0`/../../bucket/archlinuxarm-rpi2.tar.gz" http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
  
  sudo umount /tmp/rbpi/boot /tmp/rbpi/root || true
  
  sudo su root -c "rm -rf /tmp/rbpi/boot /tmp/rbpi/root"
  sudo su root -c "mkdir -p /tmp/rbpi/boot"
  sudo su root -c "mkdir -p /tmp/rbpi/root"
  sudo su root -c "mkfs.vfat  ${DEVICE}1"
  sudo su root -c "mkfs.ext4 -F ${DEVICE}2"

  sudo su root -c "mount ${DEVICE}1 /tmp/rbpi/boot"
  sudo su root -c "mount ${DEVICE}2 /tmp/rbpi/root"

  sudo su root -c "bsdtar -xpf $2 -C /tmp/rbpi/root"
  sudo su root -c "sync"
  sudo su root -c "mv /tmp/rbpi/root/boot/* /tmp/rbpi/boot"

#  sudo umount /tmp/rbpi/boot /tmp/rbpi/root
#  sudo su root -c "rm -rf /tmp/rbpi/boot /tmp/rbpi/root"
fi

#!/bin/sh
set -xe
if [ $# -lt 2 ]
  then
  echo "Check for your USB stick, and call the script with the device name!"
  sudo fdisk -l
#  diskutil list
fi

if [ $# -eq 2 ]
  then
  #umount /dev/$1
  sudo dd if=$2 of=/dev/$1 status=progress 
fi
set +xe

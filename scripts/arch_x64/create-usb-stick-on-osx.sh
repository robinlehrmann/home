#!/bin/sh
set -xe
if [ $# -lt 2 ]
  then
  echo "Check for your USB stick, and call the script with the device name!"
  diskutil list
fi

if [ $# -eq 2 ]
  then
  diskutil unmountDisk /dev/$1
  sudo dd if=$2 of=/dev/r$1 bs=1m
fi
set +xe

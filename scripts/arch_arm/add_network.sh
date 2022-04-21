#!/bin/sh

set -ex

if [[ $# -ne 3 ]] ; then
   echo "Usage: $0 </dev/disk> <ssid> <passphase>"
   exit 1
fi

DISK="$1"
SSID="$2"
PASS="$3"

if [[ "${USER}" != "root" ]] ; then
   echo "Must run as root."
   exit 1
fi

echo Mounting
mkdir root
mount "${DISK}" root

cat << EOF >> root/etc/systemd/network/wlan0.network
[Match]
Name=wlan0

[Network]
DHCP=yes
EOF

wpa_passphrase "${SSID}" "${PASS}" > root/etc/wpa_supplicant/wpa_supplicant-wlan0.conf

ln -s \
   /usr/lib/systemd/system/wpa_supplicant@.service \
   root/etc/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service

echo Unmounting
umount root

echo Cleaning up
rmdir root

set +ex

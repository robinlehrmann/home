#!/usr/bin/env bash
set -e

DISK=/dev/sda

timedatectl set-ntp true
timedatectl set-local-rtc 0

echo "==> clear put partitions"
/usr/bin/umount /mnt/boot || /bin/true
/usr/bin/umount /mnt || /bin/true
/usr/bin/sgdisk --zap ${DISK}

echo "==> set partition positions"
/usr/bin/sgdisk --new=1:0:300M ${DISK}
/usr/bin/sgdisk --new=2:0:512M ${DISK}
/usr/bin/sgdisk --new=3:0:0 ${DISK}

echo "==> set partition names"
/usr/bin/sgdisk --change-name 1:boot ${DISK}
/usr/bin/sgdisk --change-name 2:swap ${DISK}
/usr/bin/sgdisk --change-name 3:root ${DISK}

echo "==> set partition types"
/usr/bin/sgdisk --typecode=1:ef00 ${DISK}
/usr/bin/sgdisk --typecode=2:8200 ${DISK}
/usr/bin/sgdisk --typecode=3:8304 ${DISK}

echo "==> format partitions"
/usr/bin/mkfs.fat -F32 ${DISK}1
/usr/bin/mkswap ${DISK}2
/usr/bin/mkfs.ext4 ${DISK}3
/usr/bin/mount ${DISK}3 /mnt
/usr/bin/mount --mkdir ${DISK}1 /mnt/boot

echo '==> bootstrapping the base installation'
/usr/bin/pacstrap /mnt base base-devel linux linux-firmware intel-ucode wpa_supplicant dhcpcd mkinitcpio nano dialog python openssh

echo '==> generating the filesystem table'
/usr/bin/genfstab -U /mnt >> "/mnt/etc/fstab"

arch-chroot /mnt hwclock --systohc
arch-chroot /mnt echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen    # Für Deutschland
arch-chroot /mnt locale-gen
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
arch-chroot /mnt mkinitcpio -p linux
arch-chroot /mnt /usr/bin/usermod --password `/usr/bin/openssl passwd -crypt 'root'` root
arch-chroot /mnt systemctl enable systemd-network
arch-chroot /mnt systemctl enable dhcpcd
arch-chroot /mnt echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
arch-chroot /mnt systemctl enable sshd
arch-chroot /mnt /usr/bin/bootctl --path=/boot install
arch-chroot /mnt /bin/bash -c "cat >/boot/loader/loader.conf <<EOL
default  arch
timeout  5
console-mode max
editor   no
EOL"
arch-chroot /mnt /bin/bash  -c "cat >/boot/loader/entries/arch.conf <<EOL
title          Arch Linux
linux          /vmlinuz-linux
initrd         /intel-ucode.img
initrd         /initramfs-linux.img
options        root=\"PARTUUID=`blkid -s PARTUUID -o value ${DISK}3`\" rw
EOL"
arch-chroot /mnt /bin/bash  -c "cat >/boot/loader/entries/arch-fallback.conf <<EOL
title          Arch Linux Fallback
linux          /vmlinuz-linux
initrd         /intel-ucode.img
initrd         /initramfs-linux.img
options        root=\"PARTUUID=`blkid -s PARTUUID -o value ${DISK}3`\" rw
EOL"

/usr/bin/sleep 3
/usr/bin/umount -R /mnt
/usr/bin/systemctl reboot

set +e

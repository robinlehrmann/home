#!/bin/bash
if [ $# -lt 1 ]
then
    echo "You must provide a target ip"
    exit
fi
STEP=${2:-iso}
TIP=$1
echo "install $TIP"
echo $STEP
echo "You must now log in into your target machine and do the following:"

echo "- loadkeys de-latin1 (- is on ß)"
echo "- passwd (for root password)"
echo "- systmctl start sshd.service"
echo "- (check etc/ssh/sshd_config for PermitRootLogin yes)"
echo "- ensure network connection (wifi-menu)"

echo "Did you all these steps?"
if [ "$STEP" == "iso" ]; then

    read confirm_iso
    if [ "$confirm_iso" != "y" ] ;then
        echo "Canceling"
        exit 1
    fi
    echo "remote install from iso"
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$TIP 'bash -s' < scripts/arch_x64/install.sh
    STEP=init

    read confirm_provision
    if [ "$confirm_provision" != "y" ] ;then
        echo "Canceling"
        exit 1
    fi

fi
echo "Now reboot your machine and confirm"

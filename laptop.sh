#!/bin/sh
set -ex
# This assumes you have setup `adduser clux sudo` as root user first

# bunch of system stuff that needs sudo
sed -i.bak 's/jessie main/jessie main contrib non-free/g' /etc/apt/sources.list
apt-get update
apt-get install -y firmware-iwlwifi
# GRUB is really slow to render on a high DPI screen - just keep it ugly
sed -i.bak 's/#GRUB_TERMINAL=console/GRUB_TERMINAL=console/' /etc/default/grub
update-grub

# https://wiki.debian.org/NvidiaGraphicsDrivers#Debian_8_.22Jessie.22
aptitude -r install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') nvidia-kernel-dkms
# NB: this worked by itself last time - screw optimus on laptop (too much of a hassle)

echo "laptop pre-setup script complete"
echo "reboot and continue as if desktop"

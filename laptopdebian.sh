#!/bin/sh
set -ex

# Modification scripts for nvidia optimus based laptop with wifi drivers
# Run this with sudo before any debian8 tasks. After having run `adduser clux sudo` in root acc.

# package configuration and drivers
sed -i.bak 's/jessie main/jessie main contrib non-free/g' /etc/apt/sources.list
apt-get update
apt-get install -y firmware-iwlwifi

# https://wiki.debian.org/NvidiaGraphicsDrivers#Debian_8_.22Jessie.22
aptitude -r install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') nvidia-kernel-dkms
# NB: this worked by itself last time - screw optimus on laptop (too much of a hassle)

# GRUB is really slow to render on a high DPI screen - just keep it ugly
sed -i.bak 's/#GRUB_TERMINAL=console/GRUB_TERMINAL=console/' /etc/default/grub
update-grub

echo "Boot and continue with tasks"

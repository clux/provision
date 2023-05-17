#!/bin/bash
set -exuo pipefail
# For the first real boot after setting up the chroot
# login as root (with password from arch-chroot)

# NEED NETWORK PRE START
# 1. if wired:
# dhcpcd
# 2. if wifi:
#systemctl start NetworkManager
#nmcli device wifi connect MyWifi-SSID password PASSWORD

# Fetch bootstrap role
curl -sSL https://github.com/clux/provision/archive/ansible.tar.gz | tar xz
cd provision*

# Ensure we have are listed in hosts and there's a corresponding user
myuser=$(grep "$HOSTNAME" -r hosts | awk 'BEGIN {RS=" "}; /user/' | cut -d'=' -f2)
just bootstrap

# Finalise user account
loadkeys colemak # localectl screws up locales temporarily
passwd "$myuser"

cd
echo "Run ./.wayinit if you are ready."

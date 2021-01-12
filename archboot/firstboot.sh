#!/bin/bash
set -exuo pipefail
# For the first real boot after setting up the chroot
# login as root (with password from arch-chroot)

# dhcpcd one last time (bootstrap enables NetworkManager)
dhcpcd # needs to be installed in bootstrap, can be uninstalled later

# give dhcpcd some time
sleep 5

# Fetch bootstrap role
curl -sSL https://github.com/clux/provision/archive/ansible.tar.gz | tar xz
cd provision*

# Ensure we have are listed in hosts and there's a corresponding user
myuser=$(grep "$HOSTNAME" -r hosts | awk 'BEGIN {RS=" "}; /user/' | cut -d'=' -f2)
./DEPLOY bootstrap

# Finalise user account
loadkeys colemak # localectl screws up locales temporarily
passwd "$myuser"

if pacman -Ss nvidia | grep -q installed; then
  echo "bootstrap completed - boot to blacklist nouveau"
else
  systemctl start lightdm
fi

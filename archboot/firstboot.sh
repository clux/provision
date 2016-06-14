#!/bin/bash
set -ex
# for the first real boot after setting up the chroot
# login as root (which has no passwd at this stage)

loadkeys colemak
dhcpcd

# set root pass
passwd

# configure clux user
curl -sSL https://github.com/clux/dotclux/archive/ansible.tar.gz | tar xz
cd dotclux*
./DEPLOY bootstrap
passwd clux

if pacman -Ss nvidia-libgl | grep -q installed; then
  echo "bootstrap completed - boot to blacklist nouveau"
else
  systemctl start sddm
fi

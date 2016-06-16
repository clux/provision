#!/bin/bash
set -ex
# for the first real boot after setting up the chroot
# login as root (which has no passwd at this stage)

# set root pass
passwd

# configure user account
curl -sSL https://github.com/clux/dotclux/archive/ansible.tar.gz | tar xz
cd dotclux*
./DEPLOY bootstrap

loadkeys colemak # adding a user seems to screw it up
myuser=$(grep "$HOSTNAME" -r hosts | awk 'BEGIN {RS=" "}; /desktop_user/' | cut -d'=' -f2)
passwd "$myuser"

if pacman -Ss nvidia-libgl | grep -q installed; then
  echo "bootstrap completed - boot to blacklist nouveau"
else
  systemctl start sddm
fi

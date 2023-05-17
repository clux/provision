#!/bin/bash
set -euo pipefail

disk="$1"

if [ ! -f ~/.ssh/main_id ]; then
  echo "You need to have an authorized SSH key to export"
  exit 1
fi

disksize=$(lsblk "${disk}" -ldn | awk '{print $4}')

echo "WARNING: This will overwrite the ${disk}"
echo "This is a ${disksize} disk"
read -rp "Press any key to continue"

sudo umount "${disk}1" || true
sudo sgdisk -Z \
  -n 1:0:0 -t 1:8300 -c 1:provision \
  -p "$disk"
sudo mkfs.ext4 "${disk}1"

mkdir -p stick
sudo mount "${disk}1" stick
sudo chown "$USER:$USER" stick
if [ ! -f ~/.ssh/main_id.gpg ]; then
  echo "Encrypting ssh key"
  gpg -c ~/.ssh/main_id
fi
cp archboot/* stick/
cp ~/.ssh/main_id.{pub,gpg} stick/
sudo umount "${disk}1" || true
rm -r stick/

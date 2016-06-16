#!/bin/bash
set -ex

disk=${1-/dev/sdd}

echo "WARNING: This will completely overwrite ${disk}"
read -rp "Press any key to continue"

sudo umount "${disk}1" || true
sudo sgdisk -Z \
  -n 1:0:0 -t 1:8300 -c 1:provision \
  -p "$disk"
sudo mkfs.ext4 "${disk}1"

mkdir -p stick
sudo mount "${disk}1" stick
sudo chown "$USER:$USER" stick
echo "Encrypting ssh key"
gpg -c ~/.ssh/main_id
cp archboot/* stick/
cp ~/.ssh/main_id.{pub,gpg} stick/

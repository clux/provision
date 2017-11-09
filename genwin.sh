#!/bin/bash
set -euxo pipefail

if [ ! -f /usr/lib/syslinux/bios/mbr.bin ]; then
  sudo pacman -S syslinux
fi

disk="$1"
iso="${2-"Win10_1607_EnglishInternational_x64.iso"}"

if [ ! -f "${iso}" ]; then
  echo "No Windows iso found"
  exit 2
fi

disksize=$(lsblk "${disk}" -ldn | awk '{print $4}')

echo "WARNING: This will overwrite the ${disk}"
echo "This is a ${disksize} disk"
echo "(When entering cfdisk, make a bootable full size primary disk of type 7)"
read -rp "Press any key to continue"

sudo umount "${disk}1" || true
sudo sgdisk -Z "${disk}"
sudo cfdisk "${disk}" # dos, bootable full primary, type 7
sudo mkfs.ntfs -f "${disk}1"

sudo dd if=/usr/lib/syslinux/bios/mbr.bin of="${disk}"

sudo mkdir /mnt/{iso,usb} -p
sudo mount -o loop "${iso}" /mnt/iso
sudo mount "${disk}1" /mnt/usb

cp -r /mnt/iso/* /mnt/usb/
sync

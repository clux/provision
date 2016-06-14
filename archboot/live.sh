#!/bin/bash
set -ex
cd "$(dirname "$0")"

# 0. Boot into live environment through UEFI boot
efivars -l # proves you have uefi booted
loadkeys colemak
dhcpcd # this needs to work, so may as well ensure it works early

# 1. Partitioning: GPT + EFI
#  - 1: 512 MB EFI boot partition
#  - 2: Linux LVM, remaining space
sgdisk -Z \
  -n 1:0:+512M -t 1:ef00 -c 1:bootefi \
  -n 2:0:0 -t 2:8300 -c 2:cryptlvm \
  -p /dev/sda

# 2. LVM on LUKS (password set here)
cryptsetup luksFormat /dev/sda2
cryptsetup luksOpen /dev/sda2 lvm

# Create physical volume on top of LUKS container:
pvcreate /dev/mapper/lvm
pvdisplay
# Create volume group from physical volume, and add logical volumes on that group:
vgcreate cluxv /dev/mapper/lvm
vgdisplay
lvcreate -L 8G cluxv -n swap
lvcreate -l 100%free cluxv -n root

# 3. Filesystems
# 3.a) Create filesystems
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/mapper/cluxv-root
mkswap /dev/mapper/cluxv-swap
lsblk

# 3. b) Mount filesystems
mount /dev/mapper/cluxv-root /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
swapon /dev/mapper/cluxv-swap

# 4. Chroot
pacstrap /mnt base base-devel vim
genfstab -U -p /mnt >> /mnt/etc/fstab
arch-chroot /mnt ./chroot.sh
umount -R /mnt

echo "chroot created successfully - reboot to root user without password"

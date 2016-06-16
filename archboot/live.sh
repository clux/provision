#!/bin/bash
set -exuo pipefail

# Main entry point for the live environment.
# Assumes this script lives together with:
# - chroot.sh (called by this script)
# - firstboot.sh (called by you on first boot)
# - main_id.{pub,gpg} (used way later)

cd "$(dirname "$0")"
stick_root="$PWD"

abort() {
  >&2 echo "$@"
  exit 1
}
[[ $EUID -ne 0 ]] || abort You must be root inside a live environment
[[ $DCDISK ]] || abort You must specify the disk to partition
[[ $DCPASSWORD ]] || abort You must provide an encryption password
[[ $DCHOSTNAME ]] || abort You must provide a host name

# 0. Boot into live environment through UEFI boot
efivar -L # proves you EFI booted
dhcpcd # this needs to work, so may as well ensure it works early

# 1. Partitioning: GPT + EFI
#  - 1: 512 MB : EFI System
#  - 2: Remaining space: "Linux filesystem"
sgdisk -Z \
  -n 1:0:+512M -t 1:ef00 -c 1:bootefi \
  -n 2:0:0 -t 2:8300 -c 2:cryptlvm \
  -p "$DCDISK"

# 2. LVM on LUKS (password set here)
echo "$DCPASSWORD" | cryptsetup luksFormat "${DCDISK}2" -
echo "$DCPASSWORD" | cryptsetup luksOpen "${DCDISK}2" lvm

# Create physical volume on top of LUKS container:
pvcreate /dev/mapper/lvm
pvdisplay
# Create volume group from physical volume, and add logical volumes on that group:
vgcreate vgroup /dev/mapper/lvm
vgdisplay
lvcreate -L 8G vgroup -n swap
lvcreate -l 100%free vgroup -n root

# 3. Filesystems
# 3.a) Create filesystems
mkfs.fat -F32 "${DCDISK}1"
mkfs.ext4 /dev/mapper/vgroup-root
mkswap /dev/mapper/vgroup-swap
lsblk

# 3. b) Mount filesystems
mount /dev/mapper/vgroup-root /mnt
mkdir -p /mnt/boot
mount "${DCDISK}1" /mnt/boot
swapon /dev/mapper/vgroup-swap

# 4. Create chroot
pacstrap /mnt base base-devel vim
genfstab -U -p /mnt >> /mnt/etc/fstab
cp chroot.sh /mnt/
cp firstboot.sh main_id.* /mnt/root/
arch-chroot /mnt ./chroot.sh "$DCHOSTNAME" "$DCDISK"

# 5. Cleanup
umount -R /mnt
cd /
umount "$stick_root"
echo "chroot created successfully - reboot to root user (no pass)"

#!/bin/bash
set -exuo pipefail

# Main entry point for the live environment.
# Assumes this script lives together with:
# - chroot.sh (called by this script)
# - firstboot.sh (called by you on first boot)
# - main_id.{pub,gpg} (used way later)

cd "$(dirname "$0")"

abort() {
  >&2 echo "$@"
  exit 1
}
[[ $EUID -eq 0 ]] || abort You must be root inside a live environment
[[ $DCDISK ]] || abort You must specify the disk to partition
[[ $DCHOSTNAME ]] || abort You must provide a host name
DCDISKSIZE=$(lsblk "${DCDISK}" -ldn | awk '{print $4}')

echo "WARNING: This will overwrite the disk ${DCDISK}"
echo "This is a ${DCDISKSIZE} disk"
read -rp "Press any key to continue"

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
loadkeys colemak
cryptsetup luksFormat "${DCDISK}2"
cryptsetup luksOpen "${DCDISK}2" lvm

# Create physical volume on top of LUKS container:
pvcreate /dev/mapper/lvm
pvdisplay
# Create volume group from physical volume, and add logical volumes on that group:
vgcreate kjttks /dev/mapper/lvm
vgdisplay
lvcreate -L 8G kjttks -n swap
lvcreate -l 100%free kjttks -n root

# 3. Filesystems
# 3.a) Create filesystems
mkfs.fat -F32 "${DCDISK}1"
mkfs.ext4 /dev/mapper/kjttks-root
mkswap /dev/mapper/kjttks-swap
lsblk

# 3. b) Mount filesystems
mount /dev/mapper/kjttks-root /mnt
mkdir -p /mnt/boot
mount "${DCDISK}1" /mnt/boot
swapon /dev/mapper/kjttks-swap

# 4. Create chroot
pacstrap /mnt base base-devel vim
genfstab -U -p /mnt >> /mnt/etc/fstab
cp chroot.sh /mnt/
cp firstboot.sh main_id.* /mnt/root/
arch-chroot /mnt ./chroot.sh "$DCHOSTNAME" "$DCDISK"

# 5. Cleanup
umount -R /mnt
echo "chroot created successfully - reboot to root user (no pass)"

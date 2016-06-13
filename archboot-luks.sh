#!/bin/bash
set -ex
echo "This is a pseudo-script"
exit 1
# 0. Boot into live environment through UEFI boot
efivars -l # proves you have uefi booted
loadkeys colemak

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
# Create filesystems
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/mapper/cluxv-root
mkswap /dev/mapper/cluxv-swap
lsblk

# Mount filesystems
mount /dev/mapper/cluxv-root /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
swapon /dev/mapper/cluxv-swap

# create chroot and do the first configuration
dhcpcd # corded install
pacstrap /mnt base base-devel vim
genfstab -U -p /mnt >> /mnt/etc/fstab
arch-chroot /mnt /bin/bash

cat <<EOF > /etc/locale.gen
en_GB.UTF-8 UTF-8
en_US.UTF-8 UTF-8
EOF
locale-gen

systemd-firstboot \
  --timezone=Europe/London \
  --locale=en_GB.UTF-8 \
  --locale-messages=en_GB.UTF-8 \
  --hostname=kjttks

hwclock --systohc --utc

vim /etc/mkinitcpio.conf
# add `keymap encrypt lvm2` before `filesystems`

export KEYMAP=colemak # mkinitcpio runs on linux install
pacman -S --noconfirm linux

bootctl --path=/boot install
cat <<EOF > /boot/loader/loader.conf
timeout 3
default arch
EOF

cat <<EOF > /boot/loader/entries/arch.conf
title Arch Linux Encrypted LVM
linux /vmlinuz-linux
initrd /initramfs-linux.img
options cryptdevice=/dev/sda2:cluxv root=/dev/mapper/cluxv-root quiet rw
EOF

exit
umount /mnt/{boot,}
reboot

# login as root (no passwd yet)
loadkeys colemak
dhcpcd

# set root pass
passwd

# configure clux user
curl -sSL https://github.com/clux/dotclux/archive/ansible.tar.gz | tar xz
cd dotclux*
./DEPLOY bootstrap
passwd clux
reboot

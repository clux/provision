
loadkeys colemak
timedatectl set-ntp true

512MB EFI partition
2GB SWAP partition
rest linux

lsblk # verify /dev/sda
sgdisk -Z \
  -n 1:0:+512M -t 1:ef00 -c 1:bootefi \
  -n 2:0:+2G -t 2:8200 -c 2:swap \
  -n 3:0:0 -t 3:8300 -c 3:root \
  -p /dev/sda

mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3


mount /dev/sda3 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
swapon /dev/sda2


pacstrap /mnt base base-devel linux-lts vim intel-ucode
genfstab -U -p /mnt >> /mnt/etc/fstab
arch-chroot /mnt bash

locale-gen after locale.gen
systemd-firstboot with --setup-machine-id

# or systemd-machine-id-setup

add "keymap resume" to mkinitcpio

loader.conf:
timeout 4
default clux
editor 0

clux.conf in entries:
title Arch
linux /vmlinuz-linux
initrd /initramfs-linux.img
initrd /intel-ucode.img
options resume=/dev/sda2 root=/dev/sda3 rw intel_iommu=on

# multilib
nvidia: libglvnd via nvidia-utils and evdev implicitly

intel-ucode later?

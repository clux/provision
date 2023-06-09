#!/bin/bash
set -exuo pipefail

iwctl
station wlan0 show
station wlan0 scan
station wlan0 connect TACOCAT
exit
# boot with an arch img and fiddle with the chroot if you have broken things:

loadkeys colemak
cryptsetup luksOpen /dev/nvme0n1p2 cryptlvm

mount /dev/mapper/vg0-root /mnt
swapon /dev/mapper/vg0-swap
mount /dev/nvme0n1p1 /mnt/boot
arch-chroot /mnt /bin/bash

# fiddle, then (probably mkinitcpio if something was broken)
exit

# Cleanup
umount -R /mnt
swapoff -a

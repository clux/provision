#!/bin/bash
set -exuo pipefail

# boot with an arch img and fiddle with the chroot if you have broken things:

loadkeys colemak
cryptsetup luksOpen /dev/nvme0n1p2 luks

mount /dev/mapper/vg0-root /mnt
swapon /dev/mapper/vg0-swap
mount /dev/nvme0n1p1 /mnt/boot
arch-chroot /mnt /bin/bash

# fiddle, then
exit

# Cleanup
umount -R /mnt
swapoff -a

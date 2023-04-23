#!/bin/bash
set -exuo pipefail

# Installs an arch linux on an lvm volume on a luks encrypted partition sitting on nvme
# This assumes UEFI, but disables secureboot for reasons forgotten.
#
# Goal:
# nvme0n1        259:0    0   1.8T  0 disk
# ├─nvme0n1p1    259:4    0   512M  0 part  /boot
# └─nvme0n1p2    259:5    0   300G  0 part
# │ └─cryptlvm   254:0    0   300G  0 crypt
# │   ├─vg0-swap 254:1    0    16G  0 lvm   [SWAP]
# │   └─vg0-root 254:2    0   284G  0 lvm   /
# └─nvme0n1p3    259:6    0   1.5T  0 part
#
# Your starting point should be having only nvme0n1 available in `lsblk`
# If you can't see this, tweak the BIOS settings to use nvme.

# Follow https://wiki.archlinux.org/index.php/Installation_Guide for more details
# Download the archiso image from https://www.archlinux.org/ and dd it onto a usb drive:
# dd if=archlinux.img of=/dev/sdX bs=16M && sync # on linux

# 0. Boot into live environment through UEFI boot
efivar -L # proves you EFI booted
dhcpcd # this needs to work, so may as well ensure it works early

# Set colemak keymap
loadkeys colemak

# Assumes you are wired
# Partitioning; GPT + EFI
#  - 1: 512 MB : EFI System
#  - 2: 300G: Encrypted "Linux filesystem"
#  - 3: Remaining: Unencrypted "Linux filesystem"
sgdisk -Z \
  -n 1:0:+512M -t 1:ef00 -c 1:bootefi \
  -n 2:0:+300G -t 2:8300 -c 2:cryptlvm \
  -n 3:0:0 -t 3:8300 -c 3:store \
  -p /dev/nvme0n1

# Create EFI partition
mkfs.vfat -F32 /dev/nvme0n1p1

# 2. LUKS base - password set here
cryptsetup luksFormat -y /dev/nvme0n1p2
cryptsetup luksOpen /dev/nvme0n1p2 cryptlvm
cryptsetup --perf-no_write_workqueue --perf-no_read-workqueue --persistent cryptlvm
# can verify later that 'cryptsetup luksDump /dev/nvme0n1p2 | grep Flags' contains the flags


# Physical volume on top of LUKS container
pvcreate /dev/mapper/cryptlvm
pvdisplay

# Create volume group from physical volume, and add logical volumes on that group:
vgcreate vg0 /dev/mapper/cryptlvm
vgdisplay
lvcreate -L 16G vg0 -n swap
lvcreate -l 100%FREE vg0 -n root

# Create filesystems on encrypted partitions
mkfs.ext4 /dev/mapper/vg0-root
mkswap /dev/mapper/vg0-swap
mkfs.ext4 /dev/nvme0n1p3
lsblk

# Mount the new system
mount /dev/mapper/vg0-root /mnt
swapon /dev/mapper/vg0-swap
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

# Bootstrat the chroot
# vim /etc/pacman.d/mirrorlist - put an in-country mirror on top
pacstrap /mnt base base-devel helix linux linux-firmware networkmanager bash git sudo efibootmgr mkinitcpio lvm2 dhcpcd

# Generate fstab
genfstab -pU /mnt >> /mnt/etc/fstab
# Make /tmp a ramdisk (add the following line to /mnt/etc/fstab)
tmpfs /tmp  tmpfs defaults,noatime,mode=1777  0 0
# Change relatime on all non-boot partitions to noatime (reduces wear if using an SSD)

# Enter the new system
arch-chroot /mnt /bin/bash
# The rest follows chroot.sh
# but a few things that may need to change:

passwd # set root password before booting (illegal to have empty)

# vim /etc/mkinitcpio.conf
## Add 'ext4' to MODULES
## Add 'keymap' and 'encrypt' and 'lvm2' to HOOKS before filesystems
## Add 'resume' after 'lvm2' (also has to be after 'udev')

pacman -S linux linux-firmware # calls mkinitcpio via normal hooks

## Nvme boot loader settings need to grab a uuid in a weird way:
#bootctl --path=/boot install
#cat <<EOF > /boot/loader/loader.conf
#timeout 3
#default lvmluks
#EOF
#cryptuid="$(blkid -s UUID -o value /dev/nvme0n1p2)"
#cat <<EOF > /boot/loader/entries/lvmluks.conf
#title Arch Linux
#linux /vmlinuz-linux
#initrd /initramfs-linux.img
#options cryptdevice=UUID=${cryptuid}:vg0 root=/dev/mapper/vg0-root resume=/dev/mapper/vg0-swap rw mem_sleep_default=deep
#EOF
## Exit new system and go into the cd shell
exit

# Cleanup
umount -R /mnt
swapoff -a

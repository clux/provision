#!/bin/bash

echo "This is a pseudo-script"
exit 1


loadkeys colemak
dhcpcd # easy on corded - verify you have inet

# partitioning
fdisk -l # check the output
cfdisk /dev/sda
mkfs.ext4 -E discard /dev/sda1 # disable journaling on SSDs
mount /dev/sda1 /mnt

mkswap /dev/sda5 # the sub partition of the extended one
swapon /dev/sda5

pacstrap /mnt base base-devel
arch-chroot /mnt /bin/bash

edit /etc/locale.gen # uncomment en_GB.* + en_US.* (2x2 elements)
locale-gen

tzselect
# can add export TZ="Europe/London" in `~/.profile`
ln -s /usr/share/zoneinfo/Europo/London /etc/localtime

hwclock --systohc --utc

mkinitcpio -p linux

# bootloader to SSD
pacman -S grub-bios
grub-mkconfig -o /boot/grub/grub.cfg
grub-install /dev/sda

echo "kjttks" > /etc/hostname

# find interface in /sys/class/net (looks like et-- something)
systemctl enable dhcpcd@interface.service

passwd # set root pass
exit # chroot
umount /mnt
swapoff -a

reboot now

login
nano /etc/pacman.conf # uncomment multilib part (not testing)
pacman -Syy
pacman -Syu


pacman -S sudo
groupadd networkmanager
adduser -m -g users -G audio,disk,games,lp,network,networkmanager,optical,power,scanner,storage,sys,uucp,video,wheel -s /bin/bash clux
passwd clux

nano /etc/sudoers # uncomment %wheel ALL(ALL) ALL --- NOT NOPASSWD

pacman -S alsa-utils xorg-server ttf-dejavu cinnamon nvidia
# get nvidia-libgl version only with evdeb (libinput is for wayland)
reboot

# log in to main user now
pacman -S slim slim-themes
echo "exec cinnamon-session" > .xinitrc
nano /etc/slim.conf # set theme to archlinux, default user if care
systemctl enable slim.service
systemctl start slim
pacman -S guake

# ctlr-alt-F7 and log in to cinnamon session
# change keyboard layout
# alt-f2 start guake - not shortcutted

# bootstrap some visuals
sudo pacman -S firefox wget

#!/bin/bash

echo "This is a pseudo-script"
exit 1

# temporaries
loadkeys colemak
dhcpcd # corded

# partitioning
fdisk -l # check the output
cfdisk /dev/sda # clear
# /dev/sda1 :: primary bootable (disk size - 3G)
# /dev/sda2 :: extended 3G
# └─/dev/sda5 :: logical 3G

# filesystems
mkfs.ext4 -E discard /dev/sda1 # disable journaling on SSDs
mount /dev/sda1 /mnt
# mkfs above seem stho shift sda3 -> sda5 (the logical partition we created)
mkswap /dev/sda5
swapon /dev/sda5

# create chroot and do the first configuration
pacstrap /mnt base base-devel
systemd-firstboot --root=/mnt \
  --timezone=Europe/London \
  --hostname=kjttks

arch-chroot /mnt /bin/bash
hwclock --systohc --utc
echo "en_GB.UTF-8 UTF-8" > /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
mkinitcpio -p linux

# bootloader to SSD
pacman -S grub
grub-mkconfig -o /boot/grub/grub.cfg
grub-install /dev/sda # will use i386 by default

# enable dhcpcd on right interface (see ip link show)
systemctl enable dhcpcd@enp5s0

# set root pass, exit chroot and reboot into roots account
passwd
exit # chroot
reboot

# as root
localectl set-locale LANG=en_GB.UTF-8
localectl set-keymap colemak
timedatectl set-ntp true

nano /etc/pacman.conf # uncomment multilib part (not testing)
pacman -Syy
pacman -Syu
pacman -S sudo
useradd -m -G audio,video,games,rfkill,uucp,wheel -s /bin/bash clux
passwd clux
visudo # uncomment %wheel ALL(ALL) ALL --- NOT NOPASSWD

pacman -S nvidia # choose nvidia-libgl and evdev (which will pull xorg-server)
reboot # blacklists noveu

# as root
X # verify we can startx
pacman -S alsa-utils cinnamon lightdm lightdm-gtk-greeter
pacman -S ttf-dejavu ttf-liberation guake chromium wget

nano /etc/lightdm/lightdm.conf # greeter-session=lightdm-gtk-greeter

reboot

# as clux
localectl set-x11-keymap us pc104 colemak # greeter keyb
sudo systemctl enable lightdm --now

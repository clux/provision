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
mkinitcpio -p linux

# bootloader to SSD
pacman -Syy
pacman -Syu --noconfirm
pacman -S --noconfirm grub intel-ucode # microcode
grub-mkconfig -o /boot/grub/grub.cfg
grub-install /dev/sda

exit
swapoff
reboot

# login as root (no passwd yet)
loadkeys colemak

# enable dhcpcd on right interface (see ip link show or /sys/class/net/enp*)
systemctl enable dhcpcd@enp5s0

# set root pass
passwd

# configure clux user
curl -sSL https://github.com/clux/dotclux/archive/ansible.tar.gz | tar xz
cd clux*
./DEPLOY bootstrap kjttks.yml
passwd clux
reboot

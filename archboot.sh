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

pacman -S --noconfirm grub intel-ucode vim linux-lts
mkinitcpio -p linux-lts

# bootloader to SSD
grub-mkconfig -o /boot/grub/grub.cfg
grub-install /dev/sda

exit
reboot

# login as root (no passwd yet)
loadkeys colemak

# enable dhcpcd on right interface (see ip link show or /sys/class/net/enp*)
iface=$(ip link show | grep enp | awk '{print $2}' | cut -d':' -f1)
systemctl enable dhcpcd@$iface --now

# set root pass
passwd

# configure clux user
curl -sSL https://github.com/clux/dotclux/archive/ansible.tar.gz | tar xz
cd dotclux*
./DEPLOY bootstrap kjttks.yml
passwd clux
reboot

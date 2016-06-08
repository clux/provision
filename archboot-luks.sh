#!/bin/bash

echo "This is a pseudo-script"
exit 1

# temporaries
loadkeys colemak
dhcpcd # corded install

# 1. Partitioning (assuming for /dev/sda)
# Zap MBR/GPT data structures on disk
sgdisk -Z /dev/sda
# Create a 200 MB boot partition
sgdisk -n 1:0:+200M -t 1:ef02 -c 1:boot /dev/sda
# Remaining space in a second partition
sgdisk -n 2:0:0 -t 2:8e00 -c 2:cryptlvm /dev/sda

# 2. LVM on LUKS (password set here)
cryptsetup luksFormat /dev/sda2
cryptsetup luksOpen luks /dev/sda2 lvm

# Create physical volume on top of LUKS container:
pvcreate /dev/mapper/lvm
# Create volume group from physical volume, and add logical volumes on that group:
vgcreate cluxv /dev/mapper/lvm
lvcreate -L 8G cluxv -n swap
lvcreate -l 100%free cluxv -n root

# 3. Filesystems
# Create filesystems
mkfs.ext4 /dev/mapper/cluxv-root
mkswap /dev/mapper/cluxv-swap
mkfs.ext2 /dev/sda1

# Mount filesystems
mount /dev/mapper/cluxv-root /mnt
swapon /dev/mapper/cluxv-swap
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# create chroot and do the first configuration
pacstrap /mnt base base-devel
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
pacman -S --noconfirm grub intel-ucode vim linux

# bootloader
vim /etc/default/grub
  #GRUB_ENABLE_CRYPTODISK=1
  GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda2:cluxv"

grub-mkconfig -o /boot/grub/grub.cfg
grub-install /dev/sda

exit
umount /mnt/{boot,}
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
./DEPLOY bootstrap
passwd clux
reboot

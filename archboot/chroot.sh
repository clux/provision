#!/bin/bash
set -ex

# Generate locales (not sufficient to do firstboot)
cat <<EOF > /etc/locale.gen
en_GB.UTF-8 UTF-8
en_US.UTF-8 UTF-8
EOF
locale-gen

# timedatectl + localectl + hostnamectl without dbus:
systemd-firstboot \
  --timezone=Europe/London \
  --locale=en_GB.UTF-8 \
  --locale-messages=en_GB.UTF-8 \
  --hostname=kjttks

hwclock --systohc --utc

# This is read by mkinitcpio when you use the keymap hook
echo "KEYMAP=colemak" > /etc/vconsole.conf

# Tweak mkinitcpio.conf and trigger it via a kernel install
_mkinitcpio_conf='/etc/mkinitcpio.conf'
if ! grep '^HOOKS=.*encrypt' "${_mkinitcpio_conf}"; then
    sed -i '/^HOOKS=/ s/filesystem/keymap\ encrypt\ lvm2\ resume\ filesystem/' "${_mkinitcpio_conf}"
fi
pacman -S --noconfirm linux

# Configure systemd boot
bootctl --path=/boot install

# LVM on LUKS config, allows resume to swap partition via systemctl hibernate
cat <<EOF > /boot/loader/entries/lvmluks.conf
title Arch Linux Encrypted LVM
linux /vmlinuz-linux
initrd /initramfs-linux.img
options cryptdevice=/dev/sda2:cluxv resume=/dev/mapper/cluxv-swap root=/dev/mapper/cluxv-root quiet rw
EOF

# Bootloader menu - one entry
cat <<EOF > /boot/loader/loader.conf
timeout 3
default lvmluks
EOF

echo "chroot configured successfully"

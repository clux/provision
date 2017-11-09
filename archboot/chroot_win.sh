# Windows instructions


# 1. Install Windows 10
# - auto get /dev/sda1 as 500MB boot
# - auto get /dev/sda2 as configured size windows root
# Use remaining space on /dev/sda3 to make a partition
# NB: disable fast boot before installing arch!
cfdisk /dev/sda
# ...
# /dev/sda3 :: extended rest
# └─/dev/sda5 :: logical rest
mkfs.ext4 -E discard /dev/sda5
mount /dev/sda5 /mnt
# ignored swap this time aorund...

# pacstrap, chroot in, and configure kernel, then when we get to bios:


mkdir -p /media/SYSTEM_RESERVED
mount /dev/sda1 /media/SYSTEM_RESERVED

win_uuid=$(grub-probe --target=fs_uuid /media/SYSTEM_RESERVED/bootmgr)
hint_str=$(grub-probe --target=hints_string /media/SYSTEM_RESERVED/bootmgr)

cat <<EOF >> /etc/grub.d/40_custom
menuentry "Windows 10" --class windows --class os {
  insmod part_msdos
  insmod ntfs
  insmod search_fs_uuid
  insmod ntldr
  search --fs-uuid --set=root ${hint_str} ${win_uuid}
  ntldr /bootmgr
}
EOF

grub-mkconfig -o /boot/grub/grub.cfg
grub-install /dev/sda

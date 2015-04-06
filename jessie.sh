# from root acc
adduser clux sudo

# add contrib + non-free variants to /etc/apt/sources.list
# TODO: probably only need this on the main ones..

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install firmware-iwlwifi
# reboot for wifi

# bumblebee with i386 support
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install bumblebee-nvidia primus primus-libs:i386
adduser $USER bumblebee

# update grub
#GRUB_CMDLINE_LINUX_DEFAULT="quiet acpi_osi=\"!Windows 2013\""
sudo gedic /etc/default/grub
update-grub # as root

# don't start any nvidia-xconf
# REBOOT

# CHECK GPU switching works
cat /proc/acpi/bbswitch
# 0000:01:00.0 OFF
echo ON > /proc/acpi/bbswitch && cat /proc/acpi/bbswitch
# 0000:01:00.0 ON
echo OFF > /proc/acpi/bbswitch


# update bumblebee conf
echo "Driver = nvidia" # first line
echo "KernelDriver = nvidia-current" # should already be there
sudo gedit /etc/bumblebee/bumblebee.conf

# verify optirun glxgears works without errors in console
export vblank_mode=0 # set in bashrc (and use it for steam)

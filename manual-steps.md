# manual steps
Miscellaneous list of things not yet handled in an automated way.

## automatic deploy

- verify main disk is `/dev/sda` before proceeding

## Procedure

```sh
./genprov.sh # enter encryption key for stick
# NB: genprov assumes you have main_id's available! fix this..
#boot machine
loadkeys colemak
lsblk
mkdir stick
mount /dev/sdc1 stick # say..
./stick/live.sh
umount stick
reboot # remove both sticks
# login as root (no pass)
dhcpcd # need to wait for this anyway
passwd # set root pass
./firstboot.sh # wait for promt to set user pass
# login through sddm
# start guake
cd dotclux
./DEPLOY secrets
source ~/.bashrc
FPROV=1 ./DEPLOY core
```

Note that things can go screwy if ssh somehow fails or you time out mid github password generation..

## key generation
todo in genprov^^

### cinnamon highdpi switch
needs to not be in main conf:

```aconf
[cinnamon]
active-display-scale=2

[cinnamon/desktop/interface]
scaling-factor=uint32 2

[gnome/desktop/interface]
scaling-factor=uint32 2
```

### cinnamon annoying file open search not using names
- cinnamon searching history when browsing files with open... change in behaviour... doesn't appear to be a thing anymore.. what changed?
maybe this:

```aconf
[gtk/settings/file-chooser]
sort-column='name'
show-hidden=true
sort-directories-first=false
location-mode='path-bar'
```

### dark theme
now an option somewhere in system settings. no dconf entry for it...


## gitconfig
update `diff-highlight` when we got 2.9

## Sublime
Some manual steps required.

- [license](https://mail.google.com/mail/u/0/#search/sublime+license/13a942d72a211e81)
- [package control](https://packagecontrol.io/installation)

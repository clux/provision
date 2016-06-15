# manual steps
Miscellaneous list of things not yet handled in an automated way.

## automatic deploy
Want bootstrap scripts to run on the new machine, so they need to be transported to the live environment somehow. See the USB stick issue.

`efivars -l` did not exist on w5..
### scripts
scripts need to copy things correctly:

- live.sh must copy chroot.sh to /mnt/ before arch-chroot
- firstboot.sh must be copied to /mnt/root/
- probably copy ssh key to /mnt/root as well

then:

```sh
sudo cp /root/main_id* .
mkdir ~/.ssh
gpg -d main_id.gpg > main_id
chmod 0600 main_id
chmod 0644 main_id.pub
rm main_id.gpg
mv main_id* ~/.ssh
```

## key generation
Currently needs to be done on the machine via `ssh-keygen`, then have the public key copied into gmail, then from a machine that has access, authorize it elsewhere...

This should be done before generating the usb stick with scripts.

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

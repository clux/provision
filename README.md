# dotclux
[![build status](https://secure.travis-ci.org/clux/dotclux.svg)](http://travis-ci.org/clux/dotclux)

Personal Arch Linux provisioning scripts.

## Bootstrap
Copy the scripts in [archboot](./archboot/) to a usb stick along with an authorized `ssh` key.

Then UEFI boot to an arch live environment and run `live.sh`.
Once this is done, reboot into passwordless `root` user and run `firstboot.sh`

## Provisioning
After firstboot, login to `sddm` (maybe boot first), and continue:

```sh
# first thing that requires authorized ssh key
./DEPLOY secrets # answer all password prompts

# install remaining list of dependencies unattended (full provisioning mode)
FPROV=1 ./DEPLOY core
```

## Extras
To re-provision specific roles/tags later:

```sh
./DEPLOY gem,npm
```

Note that the only roles not provisioned by `core` are `ssh,xdg,dev`, which may be restructured quite a bit.

# dotclux
[![build status](https://secure.travis-ci.org/clux/dotclux.svg)](http://travis-ci.org/clux/dotclux)

Arch Linux provisioning scripts.

## Prerequisites
You need two USB sticks for this deployment.

1. [live environment](https://www.archlinux.org/download/)
2. generate with [genprov](./genprov.sh)

## Bootstrap
Boot into the live environment using EFI boot and mount the provisioning stick on `/prov`.

```sh
export DCPASSWORD=encrypteddiskpw
export DCHOSTNAME=cluxx1
export DCDISK=/dev/sda
/prov/live.sh # 3 minutes unattended
```

Boot to a passwordless `root` user and configure `X` with:

```sh
./firstboot.sh
```

This will ask for a new `root` passwd, then a new `$USER` password.

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

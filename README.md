# provision
[![build status](https://secure.travis-ci.org/clux/provision.svg)](http://travis-ci.org/clux/provision)

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
Once you have gotten a desktop, set up secrets and deploy core roles later.

```sh
./DEPLOY secrets # answer all password prompts
./DEPLOY core -f # make lunch
```

## Tags & Extras
To re-provision specific roles/tags later:

```sh
./DEPLOY gem,npm
```

Note that the only roles not provisioned by `core` are `ssh,xdg,dev`, which may be restructured quite a bit.

# provision
[![build status](https://secure.travis-ci.org/clux/provision.svg)](http://travis-ci.org/clux/provision)

Arch Linux provisioning scripts.

## Usage
Once you have gotten a desktop, set up secrets and deploy core roles later.

```sh
./DEPLOY secrets # answer all password prompts
./DEPLOY core -fs # make lunch
```

## Tags
First argument is tags. Most stuff is tagged by `core`, but you can pass comma-separated sets of tags for specifics.

```sh
sudo pacman -Syu # kept out of ansible specificially
./DEPLOY arch -fs # needs sudo
./DEPLOY pip
./DEPLOY cargo -fc # recompile modules
```

Note that the only roles not provisioned by `core` are `ssh,xdg,dev`, which may be restructured quite a bit.

## Flags
The `DEPLOY` script has a few optional flags for the normal deploy:

- `-f` run full provisioning (enables upgrade tasks)
- `-s` instructs ansible to ask for sudo password
- `-c` enable recompile tasks (extra heavy upgrade tasks - mostly for lpms)
- `-v` increases ansible verbosity

## Initial Setup
This repository also contains a bunch of experimental scripts to set up a machine from scratch. Use at own caution, your mileage may vary.

## Prerequisites
You need two USB sticks for this deployment.

1. [live environment](https://www.archlinux.org/download/)
2. [genprov](./genprov.sh) generated volume

## Bootstrap
Boot into the live environment using EFI boot, mount the provisioning stick on `/prov`, and start the show:

```sh
export DCHOSTNAME=cluxx1
export DCDISK=/dev/sda
/prov/live.sh # 3 minutes unattended after setting of crypt pass
```

Note that `$DCHOSTNAME` must exist in [hosts](./hosts).

Then boot to a passwordless `root` user and configure `X` with:

```sh
./firstboot.sh # 5 min unattended middle
```

This will ask for a new `root` passwd at start, then your `$USER` password at the end.

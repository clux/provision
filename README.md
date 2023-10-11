# provision
[![ci status](https://github.com/clux/provision/actions/workflows/lint.yml/badge.svg)](https://github.com/clux/provision/actions/workflows/lint.yml)

Arch Linux provisioning scripts with some Mac bolt-ons.

## Usage
If you already have a desktop, then you can just run tag specific runners:

```sh
just core # generally everything, ask for sudo
just arch # arch specific only, ask for sudo
just cargo # install cargo clis not in package mangers
```

Note that apart from language specific package managers (lpms) we install OS packages out-of-band via either [pacstrap](./arch/pacstrap.sh) or [macstrap](./arch/macstrap.sh).

## Initial Arch Setup
This repository also contains a [bunch of experimental scripts](./arch) to set up an arch machine from scratch. Use at own caution.

## Prerequisites
You need two USB sticks for the arch deployment.

1. [live environment](https://www.archlinux.org/download/)
2. [genprov](./arch/genprov.sh) generated volume

## Bootstrap
Boot into the live environment using EFI boot, mount the provisioning stick on `/prov`, and start the show:

```sh
export DCHOSTNAME="hprks" # host we are installing to
export DCDISK=/dev/sda # disk we are re-partitioning (and wiping) for installation
/prov/live.sh # 3 minutes unattended after setting of crypt pass
```

Note that `$DCHOSTNAME` must exist in [hosts](./hosts).

Then boot to a `root` user (with pass set in prompt) then run bootstap:

```sh
./firstboot.sh # 5 min unattended middle
```

This will ask for a new `$USER` password at the end, and ask you to run the first ansible role.

## Unsafe Packaging

The goal is to remove all of these:

- [x] `vim` plug install [replaced by helix](https://github.com/clux/provision/commit/fad5f0f4f5797dc1c013f5926711a4e2e0d98b0b)
- [ ] `vscode` [extensions snapshot](https://github.com/clux/provision/blob/ansible/vscode/extensions) legacy [installation](./justfile) (bottom)
- [ ] `aur` packages through [pacstrap](./arch/pacstrap.sh)

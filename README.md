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
- [x] `vscode` and its extensions [removed](https://github.com/clux/provision/commit/71c72ba2a7c07352c95f4d5e7e869a64db550bc6)
- [x] `zinit` for [two modules](https://github.com/clux/provision/commit/a164c46c112c69f28fce96b241eef10a343ee41d) now working on both [linux](https://github.com/clux/dotfiles/commit/b7ddab12ddc0011e97f3dd16c390d1e779acc4cf) / [mac](https://github.com/clux/dotfiles/commit/ab7e2fa62772636b15bea884b6784a54d280baac) without aur
- [ ] `aur` packages through [pacstrap](./arch/pacstrap.sh)

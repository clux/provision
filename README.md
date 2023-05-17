# provision
[![ci status](https://github.com/clux/provision/actions/workflows/lint.yml/badge.svg)](https://github.com/clux/provision/actions/workflows/lint.yml)

Arch Linux provisioning scripts with some Mac bolt-ons.

## Usage
If you already have a desktop, then you can just run tag specific runners:

```sh
just core # generally everything, ask for sudo
just arch # arch specific only, ask for sudo
just pip # python only
just cargo # cargo only
```

Note that apart from language specific package managers (lpms) we install OS packages out-of-band via either [pacstrap](./scripts/pacstrap.sh) or [macstrap](./scripts/macstrap.sh).

## Initial Arch Setup
This repository also contains a bunch of experimental scripts to set up a machine from scratch. Use at own caution, your mileage may vary.

## Prerequisites
You need two USB sticks for the arch deployment.

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

## Editors
### VS Code

The `vscode` justfile recipe installs a [snapshot of extensions](https://github.com/clux/provision/blob/ansible/vscode/extensions) and themes via `code --list-extensions`.

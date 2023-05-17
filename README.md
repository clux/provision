# provision
[![ci status](https://github.com/clux/provision/actions/workflows/lint.yml/badge.svg)](https://github.com/clux/provision/actions/workflows/lint.yml)

Arch Linux provisioning scripts with some Mac bolt-ons.

## Usage
If you already have a desktop, then you can just run tag specific runners:

```sh
./DEPLOY core -su # generally everything, ask for sudo
./DEPLOY arch -su # arch specific only, ask for sudo
./DEPLOY pip # first time pip installs (no upgrade)
./DEPLOY cargo -u # idempotent cargo install (upgrades if out-of-date)
```
Note that the only roles not provisioned by `core` are `ssh,xdg`, which may be restructured quite a bit.

## Flags
The `DEPLOY` script has a few optional flags for the normal deploy:

- `-u` run upgrade tasks
- `-s` instructs ansible to ask for sudo password
- `-v` increases ansible verbosity

## Initial Setup
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

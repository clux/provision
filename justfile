# See https://just.systems/man/
SHELLCHECK_OPTS := "-e SC1091 -e SC1090 -e SC1117 -e SC2317 -s bash"
SHELLCHECKED_FILES := "archboot/*.sh genprov.sh pacstrap.sh DEPLOY"

[private]
default:
  @just --list --unsorted


# full provision
core:
  @./DEPLOY core -fsc

# upgrade python packages
pip:
  @./DEPLOY pip -f

# upgrade npm packages
npm:
  @./DEPLOY npm -f

# upgrade rust packages
cargo:
  @./DEPLOY cargo -f

# install vs code plugins
vscode:
  cat vscode/extensions | xargs -n 1 code --install-extension
  cat vscode/themes | xargs -n 1 code --install-extension

# run local shellcheck + yamllint + sanity lints
lint:
  yamllint *.yml roles/ vars/
  test -z "$(find roles/ -type f -iname '*.yaml')" && echo "Extensions OK"
  SHELLCHECK_OPTS="{{SHELLCHECK_OPTS}}" shellcheck {{SHELLCHECKED_FILES}}

# run full lint plus bats test
test: lint
  bats test

# bootstrap (root only)
bootstrap:
  #!/bin/bash
  if [[ $EUID -ne 0 ]]; then
    echo "Must run bootstrap role as root"
    exit 1
  fi
  pacman -Syu
  ./pacstrap.sh
  pacman -S --noconfirm ansible
  ansible-playbook -i hosts -l "${HOSTNAME}" bootstrap.yml -vv


# mode: makefile
# End:
# vim: set ft=make :

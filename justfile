# See https://just.systems/man/
SHELLCHECK_OPTS := "-e SC1091 -e SC1090 -e SC1117 -e SC2317 -s bash"
SHELLCHECKED_FILES := "scripts/archboot/*.sh scripts/*.sh DEPLOY"

[private]
default:
  @just --list --unsorted

apply tags *FLAGS:
  #/bin/bash
  ansible-playbook -i hosts -l "${HOSTNAME}" site.yml --tags="{{tags}}" {{FLAGS}}

# core provision (everything except ssh/xgd)
core:
  just apply core "-e upgrade_tasks=1 --become"

# arch-specific provision
arch:
  just apply arch "-e upgrade_tasks=1 --become"

# upgrade python packages
pip:
  just apply pip "-e upgrade_tasks=1"

# upgrade npm packages
npm:
  just apply npm "-e upgrade_tasks=1"

# upgrade rust packages
cargo:
  just apply cargo "-e upgrade_tasks=1"

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

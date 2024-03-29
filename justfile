# See https://just.systems/man/
SHELLCHECK_OPTS := "-e SC1091 -e SC1090 -e SC1117 -e SC2317 -s bash"
SHELLCHECKED_FILES := "arch/*.sh mac/*.sh scripts/*.sh"
HOST := if os() == "macos" { `scutil --get LocalHostName` } else { "$HOSTNAME" }

[private]
default:
  @just --list --unsorted

# Ansible provision with arbitrary tags and flags.
apply tags *FLAGS:
  @# Available flags: -v -e upgrade_tasks=1 --become
  @# Available tags: see 'rg tags roles/'
  ansible-playbook -i hosts -l "{{HOST}}" site.yml --tags="{{tags}}" {{FLAGS}}

# arch specific provision
[linux]
arch:
  #!/bin/bash
  sudo pacman -Syu
  ./arch/pacstrap.sh
  just apply arch --become
# macos specific provision
[macos]
mac:
  #!/bin/bash
  brew upgrade
  brew bundle --no-lock --file mac/Brewfile
  just apply mac -v
  ./mac/defaults.sh

# Ansible core provision (everything except ssh/xgd)
core:
  just apply core -e upgrade_tasks=1 --become

# Ansible upgrade rust packages
cargo:
  just apply cargo -e upgrade_tasks=1

# run local shellcheck + yamllint + sanity lints
lint:
  yamllint *.yml roles/ vars/
  test -z "$(find roles/ -type f -iname '*.yaml')" && echo "Extensions OK"
  SHELLCHECK_OPTS="{{SHELLCHECK_OPTS}}" shellcheck {{SHELLCHECKED_FILES}}

# run full lint plus bats test
test: lint
  ansible-lint site.yml bootstrap.yml secrets.yml
  bats test

# See https://just.systems/man/
SHELLCHECK_OPTS := "-e SC1091 -e SC1090 -e SC1117 -e SC2317 -s bash"
SHELLCHECKED_FILES := "scripts/archboot/*.sh scripts/*.sh"

[private]
default:
  @just --list --unsorted

# Ansible provision with arbitrary tags and flags.
apply tags *FLAGS:
  #/bin/bash
  # Available flags are "-v", "-e upgrade_tasks=1" and "--become"
  # Available tags can be found via 'rg tags roles/'
  ansible-playbook -i hosts -l "${HOSTNAME}" site.yml --tags="{{tags}}" {{FLAGS}}

# arch specific provision
[linux]
arch:
  #!/bin/bash
  sudo pacman -Syu
  ./scripts/pacstrap.sh
  just apply arch "-e upgrade_tasks=1 --become"
# macos specific provision
[macos]
mac:
  #!/bin/bash
  brew upgrade
  brew bundle --no-lock --file scripts/Brewfile
  just apply mac "-e upgrade_tasks=1 -v"

# Ansible core provision (everything except ssh/xgd)
core:
  just apply core "-e upgrade_tasks=1 --become"

# Ansible upgrade python packages
pip:
  just apply pip "-e upgrade_tasks=1"

# Ansible upgrade npm packages
npm:
  just apply npm "-e upgrade_tasks=1"

# Ansible upgrade rust packages
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

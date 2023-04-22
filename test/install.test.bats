#!/usr/bin/env bats

exists() {
  hash "$1" 2> /dev/null
}
exists_any() {
  which "$1" > /dev/null
  # doesn't work because this runs in bash not zsh
}

@test "localisation" {
  if [[ "${OSTYPE}" =~ "darwin" ]]; then
    skip
  fi
  locale -a | grep -q "en_GB.utf8"
  locale -a | grep -q "en_US.utf8"
  localectl status | grep -q "LANG=en_GB.UTF-8"
  localectl status | grep -q "X11 Layout: us"
  localectl status | grep -qE "X11 Model: pc10."
  localectl status | grep -q "X11 Variant: colemak"
  timedatectl status | grep -q "Time zone: Europe/London"
  systemctl is-active systemd-timesyncd.service | grep -q "active"
  timedatectl status | grep -q "System clock synchronized: yes"
}

@test "services" {
  if [[ "${OSTYPE}" =~ "darwin" ]]; then
    skip
  fi
  systemctl is-enabled redshift-gtk --user -q
  systemctl is-active docker -q
}

@test "linux-guis" {
  if [[ "${OSTYPE}" =~ "darwin" ]]; then
    skip
  fi
  exists google-chrome-stable
  exists firefox
  exists vlc
}

@test "aur" {
  if [[ "${OSTYPE}" =~ "darwin" ]]; then
    skip
  fi
  # see pacman -Qm
  exists code
  exists sysz
  exists dyff
  run man -w zinit
  [ "$status" -eq 0 ]
}

# Tests that core tools have been installed and are on PATH
@test "clis" {
  exists zoxide
  exists hx
  exists fd
  exists exa
  exists rg
  exists choose
  exists vivid
  exists kubectl
  exists helm
  exists alacritty
  exists jq
  exists starship
  exists pwgen
  exists bat
  exists procs
  exists delta
  exists fastmod
  exists keychain
  exists just
  exists gpg
}

@test "gnu" {
  exists grep
  exists patch
  exists diff
  exists rsync
  exists make
  exists bash
  if [[ "${OSTYPE}" =~ "darwin" ]]; then
    # TODO: tests these point to that mac brew gnu folders...
    # --version and check for BSD?
    echo notdone
  fi
}

@test "purge-haskell" {
  # no ghc
  run which ghc
  [ "$status" -eq 1 ]
  exists shellcheck

  if [[ "${OSTYPE}" =~ "linux" ]]; then
    # no haskell package spam:
    pacman -Qsq | grep -v haskell
    # static shellcheck
    run ldd $(which shellcheck)
    [ "$status" -eq 1 ]
  fi
}

@test "node" {
  skip # not doing node dev atm
  exists node
  exists npm
  # old npm/node pin logic
  #[[ $(node -pe process.release.lts) != undefined ]]
  #npm --version | grep -E "^2\.*"
  # just make sure we have a reasonably new node
  nodemajor=$(node --version | grep -o "[[:digit:]]*" | head -n 1)
  [[ $nodemajor -gt 8 ]]
}
@test "npm-modules" {
  skip # not doing node dev atm
  exists yarn
  exists badgify
  exists faucet
}

@test "rust" {
  exists rustup
  exists rustc
  rustup which cargo | grep stable
  exists cargo-clippy
  exists cargo-add
  exists cargo-fmt
  exists rls
  # TODO: get rust-analyzer rustup on linux: https://rust-analyzer.github.io/manual.html#arch-linux
  exists rust-analyzer
  hx --health rust | grep Binary | grep "rust-analyzer"

  # New stable every 6th Thursday, ensure we're not more than 7 weeks behind
  if [[ "${OSTYPE}" =~ "darwin" ]]; then
    date="$(which gdate)" # for some reason not being picked up in tests
  else
    date="$(which date)"
  fi
  local -r stable=$(rustup run stable rustc --version | grep -oE "[0-9]{4}\-[0-9]{2}\-[0-9]{2}")
  local -r olddate=$($date +"%Y-%m-%d" -d"-7 weeks")
  [ "$($date -d $stable +%s)" -ge "$($date -d $olddate +%s)" ]
}

@test "python" {
  # Python3 is default interpreter
  if [[ "${OSTYPE}" =~ "darwin" ]]; then
    exists python3
  else
    ls -l $(which python) | grep python3
  fi
  #exists pylint
  exists youtube-dl
  exists ansible
  # yq, and not the go version
  exists yq
  yq --help |grep kislyuk/yq -
}

@test "cli-logins" {
  if [[ "${HOSTNAME}" == kjttks ]]; then
    npm whoami
  fi
  [ -f "$HOME/.cargo/credentials" ]
  # only checking docker if daemon is running...
  if command -v docker &> /dev/null; then
    docker info | grep Username
  fi
}

@test "dotfiles" {
  # Verify that directories are created and dotfiles are linked
  [ -d "$HOME/repos/dotfiles" ]
  [ -L "$HOME/.aliases" ]
  [ -L "$HOME/.zshrc" ]
  [ -L "$HOME/.zshenv" ]
  [ -L "$HOME/.functions" ]
  [ -L "$HOME/.gitconfig" ]
  [ -L "$HOME/.git-helpers" ]
  [ -L "$HOME/.iface" ]
  [ -d "$HOME/.templates/git/hooks" ]
  if [[ "${OSTYPE}" =~ "linux" ]]; then
    [ -L "$HOME/.xprofile" ]
    [ -L "$HOME/.Xresources" ]
  fi
  [ -L "$HOME/.k8s-helpers" ]
}

@test "evars" {
  [ -n "$KUBECONFIG" ]
  [ -n "$EDITOR" ]
  [ -n "$TERM" ]
}

@test "dev" {
  [ -d "$HOME/repos" ]
  [ -d "$HOME/kube" ]
}

@test "secrets" {
  [ -d "$HOME/.ssh" ]
  [ -r "$HOME/.ssh/config" ]
  [ -d "$HOME/.ssh/.git" ]
  [ -r "$HOME/.ssh/.gitignore" ]
  [ -d "$HOME/.gnupg" ]
  [ -d "$HOME/.gnupg/.git" ]
  run gpg --list-keys
  echo "$output" && echo "$output" | grep -iq "\[ultimate\] Eirik"
}

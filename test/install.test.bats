#!/usr/bin/env bats

exists() {
  hash "$1" 2> /dev/null
  # NB: would be nice to check if aliases existsed as well
  # but afaict not possible on bash, and this runs through bash
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
  systemctl is-enabled xdg-desktop-portal-hyprland --user -q
  systemctl is-enabled xdg-desktop-portal --user -q
  systemctl is-enabled wireplumber --user -q
  systemctl is-enabled pipewire --user -q
  systemctl is-active docker -q
}

@test "guis" {
  if [[ "${OSTYPE}" =~ "darwin" ]]; then
    mdfind "kMDItemKind == 'Application'" | grep Firefox
    mdfind "kMDItemKind == 'Application'" | grep Chrome
    mdfind "kMDItemKind == 'Application'" | grep Discord
    exists alacritty
  else
    exists google-chrome-stable
    exists firefox
    exists alacritty
    exists waybar
    exists webcord
  fi
}

@test "aur/brew" {
  # common pks first
  exists code
  exists dyff
  exists shellcheck
  exists k3d
  run man -w zinit
  if [[ "${OSTYPE}" =~ "linux" ]]; then
    # aur only: pacman -Qemt
    exists sysz
    exists wleave
    [ "$status" -eq 0 ]
  fi
}

# Tests that core tools have been installed and are on PATH
@test "clis" {
  exists zoxide
  exists hx
  exists fd
  exists eza
  exists rg
  exists choose
  exists vivid
  exists kubectl
  exists helm
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

@test "haskell" {
  exists shellcheck
  # no ghc
  run which ghc
  [ "$status" -eq 1 ]
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
  exists cargo-expand
  exists cargo-fmt
  exists yq # yq is not go, and polyfills the old python one
  yq --help | rg "Rust implementation"

  exists rust-analyzer
  hx --health rust | rg "Binary" | rg -v "not found"
  hx --health markdown | rg "Binary" | rg -v "not found"
  hx --health bash | rg "Binary" | rg -v "not found"
  hx --health hcl | rg "Binary" | rg -v "not found"
  hx --health yaml | rg "Binary" | rg -v "not found"

  # New stable every 6th Thursday, ensure we're not more than 7 weeks behind
  if [[ "${OSTYPE}" =~ "darwin" ]]; then
    DATE="$(which gdate)" # for some reason not being picked up in tests
  else
    DATE="$(which date)"
  fi
  local -r stable=$(rustup run stable rustc --version | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}")
  local -r olddate=$(${DATE} +"%Y-%m-%d" -d"-7 weeks")
  [ "$(${DATE} -d $stable +%s)" -ge "$(${DATE} -d $olddate +%s)" ]
}

@test "python" {
  # Python3 is default interpreter
  if [[ "${OSTYPE}" =~ "darwin" ]]; then
    exists python3
  else
    ls -l $(which python) | grep python3
  fi
  exists ruff
  exists yamllint
  exists yt-dlp
  exists ansible
}

@test "cli-logins" {
  if [[ "${HOSTNAME}" == hprks ]]; then
    npm whoami
  fi
  [ -f "$HOME/.cargo/credentials.toml" ]
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
  [ -d "$HOME/repos/dotfiles/git/hooks" ] # gitconfig just points it straight in here
  [ -L "$HOME/.wayinit" ]
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

@test "ssh" {
  # verify sshd works against a keychain loaded private key
  run ssh -q localhost -i ~/.ssh/main_id -p 8702 -o StrictHostKeyChecking=no echo ok
  echo "$output" | grep "ok"
}

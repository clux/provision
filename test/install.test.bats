#!/usr/bin/env bats

exists() {
  hash "$1" 2> /dev/null
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
  systemctl is-enabled mpd --user -q
}

@test "linux-guis" {
  if [[ "${OSTYPE}" =~ "darwin" ]]; then
    skip
  fi
  exists guake
  exists chrome
  exists firefox
  exists vlc
}

@test "aur" {
  if [[ "${OSTYPE}" =~ "darwin" ]]; then
    skip
  fi
  exists blackbox_cat
  run man -w z
  [ "$status" -eq 0 ]
  exists alacritty
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

@test "compilers" {
  exists clang++
  exists clang-tidy
  exists clang-format
  find /usr/lib/clang/ -iname libclang_rt* | grep -q asan
  exists gcc
}

@test "node" {
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
  exists yarn
  exists badgify
  exists faucet
}

@test "rust" {
  exists rustup
  rustup which cargo | grep stable
  exists cargo-clippy
  exists cargo-add
  exists cargo-fmt
  exists rls
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
  exists pylint
  exists ipython
  exists ghp-import
  exists youtube-dl
  exists ansible
  exists yq # TODO: ensure it's not the go one
}

@test "nvidia" {
  if [[ "${HOSTNAME}" == kjttks ]]; then
    exists nvidia-settings
    #run nvidia-settings -q CurrentMetaMode
    #echo "$output"
    #echo "$output" | grep "ForceFullCompositionPipeline=On"
  fi
}

@test "cli-logins" {
  if [[ "${HOSTNAME}" == kjttks ]]; then
    npm whoami
  fi
  [ -f "$HOME/.cargo/credentials" ]
  # TODO: only if daemon is running...
  docker info | grep Username
}

@test "dotfiles" {
  # Verify that directories are created and dotfiles are linked
  [ -d "$HOME/repos/dotfiles" ]
  [ -L "$HOME/.aliases" ]
  [ -L "$HOME/.bash_profile" ]
  [ -L "$HOME/.prompt" ]
  [ -L "$HOME/.bashrc" ]
  #[ -d "$HOME/.config/sublime-text-3/Packages/User" ]
  #[ -L "$HOME/.config/sublime-text-3/Packages/User" ]
  #[ -r "$HOME/.config/sublime-text-3/Packages/User/SublimeLinter.sublime-settings" ]
  [ -L "$HOME/.clang-format" ]
  [ -L "$HOME/.eslintrc" ]
  [ -L "$HOME/.exports" ]
  [ -L "$HOME/.functions" ]
  [ -L "$HOME/.gitconfig" ]
  [ -L "$HOME/.iface" ]
  [ -L "$HOME/.inputrc" ]
  [ -L "$HOME/.jshintrc" ]
  [ -L "$HOME/.path" ]
  [ -d "$HOME/.templates" ]
  if [[ "${OSTYPE}" =~ "linux" ]]; then
    [ -L "$HOME/.xprofile" ]
    [ -L "$HOME/.Xresources" ]
  fi
  [ -L "$HOME/.yrcli.json" ]
}

@test "evars" {
  [ "$ANSIBLE_NOCOWS" = "1" ]
}

@test "dev" {
  [ -d "$HOME/repos" ]
  if [[ "${HOSTNAME}" == kjttks ]]; then
    exists bndg
    [ -L $(which bndg) ]
  fi
}

@test "secrets" {
  [ -d "$HOME/.ssh" ]
  [ -r "$HOME/.ssh/config" ]
  [ -d "$HOME/.ssh/.git" ]
  [ -r "$HOME/.ssh/.gitignore" ]
  [ -d "$HOME/.gnupg" ]
  [ -d "$HOME/.gnupg/.git" ]
  run gpg --list-keys
  echo "$output" && echo "$output" | grep -q "\[ultimate\] Eirik"
  [ -d "$HOME/repos/provision" ]
}

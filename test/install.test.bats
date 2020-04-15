#!/usr/bin/env bats

exists() {
  hash "$1" 2> /dev/null
}

@test "localisation" {
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
  systemctl is-enabled redshift-gtk --user -q
  systemctl is-enabled mpd --user -q
}

# Tests that expected stuff has been installed and are on PATH
@test "pacman" {
  exists chromium
  exists firefox
  exists guake
  exists vlc
}

@test "aur" {
  exists subl3
  [ -d ~/.vim ]
  [ -f ~/.vim/autoload/plug.vim ]
  exists blackbox_cat
  run man -w z
  [ "$status" -eq 0 ]
  exists alacritty
}

@test "purge-haskell" {
  # no haskell package spam:
  pacman -Qsq | grep -v haskell

  # no ghc
  run which ghc
  [ "$status" -eq 1 ]

  # static shellcheck
  exists shellcheck
  run ldd $(which shellcheck)
  [ "$status" -eq 1 ]
}


@test "compilers" {
  exists clang++
  exists clang-tidy
  exists clang-format
  find /usr/lib/clang/ -iname libclang_rt* | grep -q asan
  exists gcc
}

@test "profanity" {
  exists profanity
  run profanity --version
  [ "$status" -eq 0 ]
  echo "$output"
  echo "$output" | grep "OTR support\: Enabled"
  echo "$output" | grep "Desktop notification support\: Enabled"
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
  rustup which cargo | grep stable-x86_64
  exists cargo-clippy
  exists cargo-add
  exists cargo-fmt
  exists rls
  # New stable every 6th Thursday, ensure we're not more than 7 weeks behind
  local -r stable=$(rustup run stable rustc --version | grep -oE "[0-9]{4}\-[0-9]{2}\-[0-9]{2}")
  local -r olddate=$(date +"%Y-%m-%d" -d"-7 weeks")
  [ "$(date -d $stable +%s)" -ge "$(date -d $olddate +%s)" ]
}

@test "python" {
  # Python3 is default interpreter
  ls -l $(which python) | grep python3
  exists pylint
  exists ipython
  exists ghp-import
  exists youtube-dl
  exists ansible
}

@test "nvidia" {
  if [[ $(hostname) == kjttks ]]; then
    exists nvidia-settings
    #run nvidia-settings -q CurrentMetaMode
    #echo "$output"
    #echo "$output" | grep "ForceFullCompositionPipeline=On"
  fi
}

@test "cli-logins" {
  if [[ $(hostname) == kjttks ]]; then
    npm whoami
  fi
  docker info | grep Username
}

@test "dotfiles" {
  # Verify that directories are created and dotfiles are linked
  [ -d "$HOME/repos/dotfiles" ]
  [ -L "$HOME/.aliases" ]
  [ -L "$HOME/.bash_profile" ]
  [ -L "$HOME/.prompt" ]
  [ -L "$HOME/.bashrc" ]
  [ -d "$HOME/.config/sublime-text-3/Packages/User" ]
  [ -L "$HOME/.config/sublime-text-3/Packages/User" ]
  [ -r "$HOME/.config/sublime-text-3/Packages/User/SublimeLinter.sublime-settings" ]
  [ -L "$HOME/.clang-format" ]
  [ -L "$HOME/.dircolors" ]
  [ -L "$HOME/.eslintrc" ]
  [ -L "$HOME/.exports" ]
  [ -L "$HOME/.functions" ]
  [ -L "$HOME/.gitconfig" ]
  [ -L "$HOME/.iface" ]
  [ -L "$HOME/.inputrc" ]
  [ -L "$HOME/.jshintrc" ]
  [ -L "$HOME/.mpdconf" ]
  [ -d "$HOME/.ncmpcpp" ]
  [ -L "$HOME/.path" ]
  [ -d "$HOME/.templates" ]
  [ -L "$HOME/.tmux.conf" ]
  [ -L "$HOME/.xprofile" ]
  [ -L "$HOME/.Xresources" ]
  [ -L "$HOME/.yrcli.json" ]
}

@test "evars" {
  [ "$ANSIBLE_NOCOWS" = "1" ]
}

@test "dev" {
  [ -d "$HOME/repos" ]
  if [[ $(hostname) == kjttks ]]; then
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

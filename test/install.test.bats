#!/usr/bin/env bats

exists() {
  hash "$1" 2> /dev/null
}

@test "locales" {
  locale -a | grep -q "en_GB.utf8"
  locale -a | grep -q "en_US.utf8"
  localectl status | grep -q "LANG=en_GB.UTF-8"
  localectl status | grep -q "X11 Layout: us"
  localectl status | grep -qE "X11 Model: pc10."
  localectl status | grep -q "X11 Variant: colemak"
}

@test "services" {
  systemctl is-enabled redshift-gtk --user -q
  systemctl is-enabled mpd --user -q
}

# Tests that expected stuff has been installed and are on PATH
@test "pacman" {
  exists chromium
  #exists google-chrome-stable
  exists guake
  exists cmake
}

@test "llvm" {
  exists clang++
  clang++ --version | grep -q "clang version 3.9"
  exists clang-tidy
  exists clang-format
  find /usr/lib/clang/ -iname libclang_rt* | grep -q asan
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
  [[ $(node -pe process.release.lts) != undefined ]]
  npm --version | grep -E "^2\.*"
}

@test "npm-modules" {
  exists yarn
  exists badgify
  exists pm2
  exists faucet
}

@test "rust" {
  [ -L "$HOME/.cargo/rustc-stable" ]
  [ -d "$RUST_SRC_PATH" ]
  exists rustup
  rustup which cargo | grep stable-x86_64
  exists cargo-clippy
  exists racer
  exists cargo-add
}

@test "python" {
  # Python3 is default interpreter
  ls -l $(which python3) | grep python3
  exists pylint
  exists ipython
  exists ghp-import
  exists youtube-dl
  run ansible --version
  echo "$output"
  echo "$output" | grep "ansible 2."
}

@test "hacks" {
  exists subl
  ls -l $(which subl) | grep /usr/local/sublime
  [ -d ~/.vim ]
  [ -f ~/.vim/autoload/plug.vim ]
  exists blackbox_cat
  run man -w z
  [ "$status" -eq 0 ]
  run man -w bats
  [ "$status" -eq 0 ]
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
  [ -L "$HOME/.hgrc" ]
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
  [ "$CXX" = "clang++" ]
}

@test "dev" {
  [ -d "$HOME/repos" ]
  exists bndg
  [ -L $(which bndg) ]
}

@test "secrets" {
  [ -r "$HOME/.config/Mumble/Mumble.conf" ]
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

#!/usr/bin/env bats

@test "system" {
  locale -a | grep -q "en_GB.utf8"
  locale -a | grep -q "en_US.utf8"
  [ -n "$TRAVIS" ] && skip "travis/docker does not have systemd"
  localectl status | grep -q "LANG=en_GB.UTF-8"
  localectl status | grep -q "X11 Layout: us"
  localectl status | grep -qE "X11 Model: pc10."
  localectl status | grep -q "X11 Variant: colemak"
}

# Tests that expected stuff has been installed and are on PATH
@test "apt" {
  if [[ $(lsb_release -si) == "Arch" ]]; then
    run which chromium
  else
    run which google-chrome
  fi
  [ "$status" -eq 0 ]
  run which guake
  [ "$status" -eq 0 ]
  run which cmake
  [ "$status" -eq 0 ]
}

@test "llvm" {
  run clang --version
  [ "$status" -eq 0 ]
  echo "$output" && echo "$output" | grep "3.8.0"
  # compiled s.t. we have sanitizers
  if [[ $(lsb_release -si) == "Arch" ]]; then
    run ls /usr/lib/clang/3.8.0/lib/linux/libclang_rt.asan_cxx-x86_64.a
  else
    run ls /usr/local/lib/clang/3.8.0/lib/linux/libclang_rt.asan_cxx-x86_64.a
  fi
  [ "$status" -eq 0 ]
  # with lldb
  run lldb --version
  [ "$status" -eq 0 ]
  echo "$output" && echo "$output" | grep "3.8.0"
  # with analyzer and scan-build (apparently broken now)
  #run c++-analyzer --version
  #[ "$status" -eq 0 ]
  #run which scan-build
  #[ "$status" -eq 0 ]
}

@test "profanity" {
  run which profanity
  [ "$status" -eq 0 ]
  run profanity --version
  [ "$status" -eq 0 ]
  echo "$output"
  echo "$output" | grep "OTR support\: Enabled"
  if [ -z "$TRAVIS" ]; then
    # Won't have desktop support in travis container
    echo "$output" | grep "Desktop notification support\: Enabled"
  fi
}

@test "node" {
  run which node
  [ "$status" -eq 0 ]
  run node --version
  [ "$status" -eq 0 ]
  echo "$output" && echo "$output" | grep "v4."
  run node -pe process.release.lts
  echo "$output" && echo "$output" | grep "Argon"
}

@test "sublime" {
  run which subl
  [ "$status" -eq 0 ]
}

@test "clone" {
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
  [ -L "$HOME/.nanorc" ]
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

@test "npm" {
  run which badgify
  [ "$status" -eq 0 ]
  run which pm2
  [ "$status" -eq 0 ]
}

@test "pip" {
  run which pylint
  [ "$status" -eq 0 ]
}

@test "cluxdev" {
  [ -d "$HOME/repos" ]
  run which bndg # should have been symlinked
  [ "$status" -eq 0 ]
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
  [ -d "$HOME/repos/dotclux" ]
}

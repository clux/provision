#!/usr/bin/env bats

# Tests that expected stuff has been installed and are on PATH
@test "apt" {
  run which google-chrome
  [ "$status" -eq 0 ]
  run which guake
  [ "$status" -eq 0 ]
  run which cmake
  [ "$status" -eq 0 ]
}

@test "node" {
  run which node
  [ "$status" -eq 0 ]
  run node --version
  [ "$status" -eq 0 ]
  echo "$output" && echo "$output" | grep "v5."
}

@test "sublime" {
  run which subl
  [ "$status" -eq 0 ]
}

@test "profanity" {
  [ -n "$TRAVIS" ] && skip "not installing profanity on travis"
  run which profanity
  [ "$status" -eq 0 ]
  run profanity --version
  [ "$status" -eq 0 ]
  echo "$output"
  echo "$output" | grep "OTR support\: Enabled"
  echo "$output" | grep "Desktop notification support\: Enabled"
}

@test "clone" {
  run which arc
  [ "$status" -eq 0 ]
  run man -w z
  [ "$status" -eq 0 ]
  run man -w bats
  [ "$status" -eq 0 ]
}

@test "dotfiles" {
  [ -d "$HOME/repos/dotfiles" ]
  [ -r "$HOME/.bash_prompt" ]
  [ -r "$HOME/.bash_profile" ]
  [ -r "$HOME/.path" ]
  [ -r "$HOME/.aliases" ]
  [ -r "$HOME/.functions" ]
  [ -r "$HOME/.xprofile" ]
  [ -r "$HOME/.eslintrc" ]
  [ -r "$HOME/.jshintrc" ]
  [ -r "$HOME/.clang-format" ]
  [ -r "$HOME/.gitconfig" ]
  [ -r "$HOME/.config/autostart/guake.desktop" ]
  [ -r "$HOME/.config/sublime-text-3/Packages/User/SublimeLinter.sublime-settings" ]
  [ -r "$HOME/.iface" ]
}

@test "evars" {
  [ -n "$TRAVIS" ] && skip "travis/docker shell by design not interactive"
  [ "$CXX" = "clang++" ]
}

@test "npm" {
  [ -n "$TRAVIS" ] && skip "not doing global installs on travis"
  run which badgify
  [ "$status" -eq 0 ]
  run which pm2
  [ "$status" -eq 0 ]
}

@test "pip" {
  [ -n "$TRAVIS" ] && skip "not doing global installs on travis"
  run which pylint
  [ "$status" -eq 0 ]
}

@test "cluxdev" {
  [ -n "$TRAVIS" ] && skip "not building every single module on travis"
  [ -d "$HOME/repos" ]
  [ -d "$HOME/repos/dotclux" ]
  run which bndg # should have been symlinked
  [ "$status" -eq 0 ]
}

@test "secrets" {
  [ -n "$TRAVIS" ] && skip "no priveleges to do secrets test on travis"
  [ -r "$HOME/.config/Mumble/Mumble.conf" ]
  [ -d "$HOME/.ssh" ]
  [ -r "$HOME/.ssh/config" ]
  [ -d "$HOME/.ssh/.git" ]
  [ -r "$HOME/.ssh/.gitignore" ]
  [ -d "$HOME/.gnupg" ]
  [ -r "$HOME/.gnupg/pubring.gpg" ]
  [ -d "$HOME/.gnupg/.git" ]
  [ -r "$HOME/.gnupg/.gitignore" ]
  [ -d "$HOME/repos/dotwork" ]
}

@test "llvm" {
  [ -n "$TRAVIS" ] && skip "not compiling llvm on travis"
  run clang --version
  [ "$status" -eq 0 ]
  echo "$output" && echo "$output" | grep "3.7.0"
}

#!/usr/bin/env bats

# Tests that expected stuff has been installed and are on PATH
@test "apt" {
  run which google-chrome
  [ "$status" -eq 0 ]
  run which guake
  [ "$status" -eq 0 ]
}

@test "node" {
  run which node
  [ "$status" -eq 0 ]
  run node --version
  [ "$status" -eq 0 ]
  echo "$output" && echo "$output" | grep "v4."
}

@test "ssh" {
  [ -n "$TRAVIS" ] && skip "not installing ssh on travis"
  [ -d "$HOME/.ssh" ]
  [ -r "$HOME/.ssh/config" ]
  [ -d "$HOME/.ssh/.git" ]
  [ -r "$HOME/.ssh/.gitignore" ]
}

@test "sublime" {
  run which subl
  [ "$status" -eq 0 ]
}

@test "cpy" {
  [ -r "$HOME/.eslintrc" ]
  [ -r "$HOME/.config/redshift.conf" ]
  [ -r "$HOME/.config/sublime-text-3/Packages/User/SublimeLinter.sublime-settings" ]
  [ -r "$HOME/.iface" ]
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

@test "clone" {
  [ -d "$HOME/repos" ]
  [ -d "$HOME/repos/dotclux" ]
  run which bndg # should have been symlinked
  [ "$status" -eq 0 ]
}

@test "llvm" {
  [ -n "$TRAVIS" ] && skip "not compiling llvm on travis"
  run clang --version
  [ "$status" -eq 0 ]
  echo "$output" && echo "$output" | grep "3.7.0"
}

@test "bashrc" {
  [ "$CXX" = "clang++" ]
}

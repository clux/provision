#!/usr/bin/env bats

# Tests that expected stuff has been installed and are on PATH

@test "npm" {
  run which badgify
  [ "$status" -eq 0 ]
}

@test "pip" {
  run which pylint
  [ "$status" -eq 0 ]
}

@test "sublime" {
  run which subl
  [ "$status" -eq 0 ]
}

@test "chrome" {
  run which google-chrome
  [ "$status" -eq 0 ]
}

@test "configs" {
  [ -r "$HOME/.eslintrc" ]
}

@test "repos" {
  [ -d "$HOME/repos" ]
  [ -d "$HOME/repos/dotclux" ]
  run which bndg # should have been npm link'd
  [ "$status" -eq 0 ]
}

@test "clang 3.7.0" {
  [ -n "$TRAVIS" ] && skip "not compiling on travis"
  run clang --version
  [ "$status" -eq 0 ]
  [ $(expr "$output" : ".*3.7.0") -ne 0 ]
}

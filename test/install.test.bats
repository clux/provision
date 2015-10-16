#!/usr/bin/env bats

# Tests that expected stuff has been installed and are on PATH

@test "bats" {
  run which bats
  [ "$status" -eq 0 ]
}

@test "repos" {
  [ -d "$HOME/repos/dotclux" ]
}

@test "npm" {
  run which badgify
  [ "$status" -eq 0 ]
}

@test "clang" {
  run which clang
  [ "$status" -eq 0 ]
}


@test "configs" {
  [ -r "$HOME/.eslintrc" ]
}

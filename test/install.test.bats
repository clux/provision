#!/usr/bin/env bats

# Tests that expected stuff has been installed and are on PATH
@test "apt" {
  if [[ $(lsb_release -si) == "Arch" ]]; then
    run which google-chrome-stable
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
  echo "$output" && echo "$output" | grep "3.7.0"
  # compiled s.t. we have sanitizers
  if [[ $(lsb_release -si) == "Arch" ]]; then
    run ls /usr/lib/clang/3.7.0/lib/linux/libclang_rt.asan_cxx-x86_64.a
  else
    run ls /usr/local/lib/clang/3.7.0/lib/linux/libclang_rt.asan_cxx-x86_64.a
  fi
  [ "$status" -eq 0 ]
  # with lldb
  run lldb --version
  [ "$status" -eq 0 ]
  echo "$output" && echo "$output" | grep "3.7.0"
  # with analyzer and scan-build
  run c++-analyzer --version
  [ "$status" -eq 0 ]
  run which scan-build
  [ "$status" -eq 0 ]
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
  [ -n "$TRAVIS" ] && skip "not building + linking all dev modules on travis"
  [ -d "$HOME/repos" ]
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
  [ -d "$HOME/repos/dotclux" ]
}

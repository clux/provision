#!/bin/bash

# One time pacman dependency install script
# Meant to run after a fresh arch install
# but after choosing drivers and stuff (see bootstrap.yml)


install_tools() {
  echo "Installing ${1}"
  # shellcheck disable=SC2068
  sudo pacman -S --needed ${@:2}
}

term=(
  alacritty
  git
  bc
  choose
  jq
  bash-bats
  ripgrep
  exa
  tokei
  fd
  bat
  grex
  xsv
  hyperfine
  vivid
  fzf
  #skim
  sd
  zoxide
  protobuf
  man-pages
  man-db
  procs
  dust
  git-delta
  github-cli
  starship
  helix
  asciinema
  terraform
  datamash
  genact
  zellij
  zsh
  #zsh-autosuggestions #zinit
  #zsh-fast-syntax-highlighting #aur atm
)
install_tools "term" "${term[@]}"

social=(
  hugo
  signal-desktop
  #discord (webcord on wayland)
)
install_tools "social" "${social[@]}"

media=(
  #AUDIO/VIDEO RELATED
  #musescore
  ncspot
  #mpd
  #ncmpcpp
  playerctl
  #vlc
  mpv
  #mpv-mpris (maybe.. aur)
  #IMAGE RELATED
  feh
  gimp
  #gthumb (lots of deps..)
  imagemagick
  #gedit
  #gphoto2
)
install_tools "media" "${media[@]}"

browser=(
  chromium
  firefox
  #chrome from aur
  steam
)
install_tools "browser/electron" "${browser[@]}"

fonts=(
  ttf-ubuntu-font-family
  ttf-inconsolata-nerd
  otf-ipafont # japanese
  adobe-source-han-sans-kr-fonts # korean
  #fonts-tlwg # thai AUR
  wqy-microhei # chinese
  noto-fonts-emoji # google's emoji font
)
install_tools "fonts" "${fonts[@]}"

sec=(
  keychain
  pass
  pwgen
  #yubikey-manager
  #yubikey-manager-qt
)
install_tools "sec" "${sec[@]}"

system=(
  openssh
  rsync
  strace
  perf
  lsof
  lm_sensors # temperature/sensor dump from motherboard
)
install_tools "system" "${system[@]}"

network=(
  #networkmanager-openvpn
  #openvpn
  #nmap
  net-tools # netstat
  #bind-tools  # contains dig
  #traceroute
  #bmon
  bandwhich
  #trickle
  nethogs
  #trickle (aur)
  #libmicrodns # vlc cast: https://wiki.archlinux.org/index.php/VLC_media_player#Chromecast_support to enable mdns
  # wifi
  #iwd
  #create_ap (aur)
)
install_tools "network" "${network[@]}"

programming=(
  # RUST
  rustup
  rust-analyzer
  # PYTHON
  python-pip
  #ipython
  pypy3
  ruff
  mypy
  # C/C++
  cmake
  clang
  compiler-rt
  #llvm
  #musl
  # CURSED
  go
  #nodejs
  #npm
  #yarn
)
install_tools "programming" "${programming[@]}"

cloud=(
  docker
  docker-buildx
  #docker-compose (can generally use tilt)
  #ctop
  #conntrack-tools # k8s > 1.18 dependency
  kustomize
  kubectl
  helm
  k9s
)
install_tools "cloud" "${cloud[@]}"

filesystem=(
  #ntfs-3g
  #nemo-fileroller
  #nemo-share
  ranger
  #joshuto (maybe.. ranger replacement on aur)
  #gvfs-smb
  #mtpfs # kindle
  #android-file-transfer
  #gptfdisk
  udisks2 # easy usb mount
  udiskie # auto udisk2
  # ebooks
  #poppler
  #calibre
)
install_tools "filesystem" "${filesystem[@]}"
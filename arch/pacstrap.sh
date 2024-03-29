#!/bin/bash
set -euo pipefail

# One time pacman dependency install script
# Meant to run after a fresh arch install
# but after choosing drivers and stuff (see bootstrap.yml)


install_tools() {
  echo "Installing ${1}"
  # shellcheck disable=SC2068
  sudo pacman -S --needed ${@:2}
}

shell=(
  bats
  keychain
  pass
  pwgen
  man-pages
  man-db
  zsh
  # avoiding zinit in favour of common main plugins
  zsh-autosuggestions
  zsh-syntax-highlighting
)
install_tools "shell" "${shell[@]}"

# collecting tools by language
rust=(
  # tools
  alacritty
  bat
  choose
  ripgrep
  eza
  tokei
  fd
  grex
  git-delta
  xsv
  hyperfine
  vivid
  sd
  procs
  dust
  starship
  zoxide
  yazi
  bandwhich
  lychee
  # skim
  ncspot
  helix
  genact
  zellij
  # development
  rustup
  rust-analyzer
  cargo-release
  cargo-outdated
  cargo-edit
  cargo-audit
  cargo-deny
  cargo-binstall
)
install_tools "rust" "${rust[@]}"


# partial dev deps + python tooling evacuated from pip install --user
# after the --break-system-packages change
python=(
  # tools
  asciinema
  yamllint
  yt-dlp
  ranger
  # development
  python-pip
  #python-pipenv
  python-requests
  #python-pytest
  #ipython
  pypy3
  ruff
  mypy
)
install_tools "python" "${python[@]}"

go=(
  # tools
  fzf
  docker
  docker-buildx
  #docker-compose (can generally use tilt)
  #ctop
  kustomize
  kubectl
  helm
  k9s
  github-cli
  terraform
  # development
  go
)
install_tools "go" "${go[@]}"

ccpp=(
  # tools
  bc
  btop
  datamash
  git
  jq
  powertop
  protobuf
  # audio
  mpv
  playerctl
  #mpv-mpris (maybe.. aur)
  #mpd - using mpris/playerctl in general
  #ncmpcpp - ditto, replaced by ncspot
  wf-recorder
  #vlc
  # development
  cmake
  clang
  compiler-rt
  mold
  #llvm
  #musl
)
install_tools "ccpp" "${ccpp[@]}"

lang=(
  bash-language-server
  marksman # f# language server for markdown
  yaml-language-server
)
install_tools "language servers" "${lang[@]}"
# -----------------------------------------------------------------------------
# misc desktop related that's not classified by language (generally c/cpp)
# -----------------------------------------------------------------------------

biggui=(
  chromium
  firefox
  #chrome from aur
  browserpass
  musescore
  steam
  signal-desktop
  discord
)
install_tools "biggui" "${biggui[@]}"

gfx=(
  feh
  gimp
  #gthumb (lots of deps..)
  #gedit
  imagemagick
  # image optimizers
  pngquant
  oxipng
)
install_tools "gfx" "${gfx[@]}"

fonts=(
  ttf-ubuntu-font-family
  ttf-inconsolata-nerd
  otf-ipafont # japanese
  adobe-source-han-sans-kr-fonts # korean
  #fonts-tlwg # thai AUR
  wqy-microhei # chinese
  noto-fonts-emoji # google's emoji font
  anthy # japanese input method
)
install_tools "fonts" "${fonts[@]}"

system=(
  openssh
  rsync
  strace
  perf
  lsof
  lm_sensors # temperature/sensor dump from motherboard
  #yubikey-manager
  #yubikey-manager-qt
)
install_tools "system" "${system[@]}"

network=(
  #nmap
  net-tools # netstat
  bind-tools  # contains dig / nslookup
  #traceroute
  #bmon
  #trickle
  nethogs
  #trickle (aur)
  #libmicrodns # vlc cast: https://wiki.archlinux.org/index.php/VLC_media_player#Chromecast_support to enable mdns
  # wifi
  #iwd
  #create_ap (aur)
)
install_tools "network" "${network[@]}"

filesystem=(
  #ntfs-3g
  #nemo-fileroller
  #nemo-share
  #gvfs-smb
  #mtpfs # kindle
  #android-file-transfer
  #gptfdisk
  udisks2 # easy usb mount
  udiskie # auto udisk2 - python!
  # ebooks
  #poppler
  #calibre
)
install_tools "filesystem" "${filesystem[@]}"

# Non-wayland bootstrap AUR deps.
# Not automated, just listing here.
# shellcheck disable=SC2034
aur=(
  slides # terminal presentation framework
  ueberzugpp # image rendering for yazi + alacritty
  dyff # kubernetes GVK aware diffing
  rancher-k3d-bin # k3d from rancher's own repo: https://github.com/k3d-io/k3d/blob/main/deploy-aur.sh
  browserpass-chrome
  #ckb-next # corsair mouse things
  uim # japanese input method
)

#!/bin/bash
set -eux

if ! which brew > /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # shellcheck disable=SC2016
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.bash_profile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! which rustup > /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

brew install bash

if [ -f /opt/homebrew/bin/bash ]; then
  chsh -s /opt/homebrew/bin/bash;
  # echo changed default shell, update in advanced user settings also
fi

brew install ansible
ansible-galaxy collection install community.general

# casks currently don't install properly through the module
brew install --cask \
    alacritty \
    firefox \
    discord \
    docker \
    google-chrome \
    hammerspoon \
    karabiner-elements \
    openvpn-connect \
    signal \
    slack \
    visual-studio-code \
    background-music \
    vlc

# but can use ansible for the rest
ansible-playbook -i hosts -l "cluxm1" --tags=mac -v site.yml

# points to fix manually;
# background music needs to set default sound device to the generated one
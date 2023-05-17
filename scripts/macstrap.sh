#!/bin/bash
set -eux

if ! which brew > /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! which rustup > /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --no-lock --file scripts/Brewfile

ansible-galaxy collection install community.general

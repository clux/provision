#!/bin/bash
set -eux

if ! which brew > /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)" # ensure brew is available

if ! which rustup > /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# ansible for app installs are usually pretty bad, install direct
brew bundle --no-lock

# use ansible for the rest
ansible-galaxy collection install community.general
ansible-playbook -i hosts -l "${HOSTNAME}" --tags=mac -v site.yml

# points to fix manually;
# background music needs to set default sound device to the generated one

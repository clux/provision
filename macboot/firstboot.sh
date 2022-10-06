#!/bin/bash
set -eux

if ! which brew > /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install bash

if [ -f /opt/homebrew/bin/bash ]; then
  chsh -s /opt/homebrew/bin/bash;
  # echo changed default shell, update in advanced user settings also
fi

brew install ansible
brew install visual-studio-code --cask
brew install google-chrome --cask

#!/bin/bash
set -e

# ssh keys
echo "Generating github identity"
# NB: bitbucket does not yet support ed25519
# https://bitbucket.org/site/master/issues/10983/ed25519-ssh-keys-bb-13645
ssh-keygen -t rsa -b 4096 -C "analsandblaster@gmail.com" -f ~/.ssh/github_id
xclip -sel clip < ~/.ssh/github_id.pub
echo "Log in to github and bitbucket and paste clipboarded public key"
read -p "Press any key when keys have been added..."

keychain --timeout 300 --host agent ~/.ssh/github_id
source ~/.keychain/agent-sh

echo "Verifying github"
ssh -T git@github.com
echo "Verifying bitbucket"
ssh -T git@bitbucket.org

# dotfiles
mkdir -p ~/repos && cd ~/repos
git clone ${GH}clux/dotfiles.git
cd dotfiles

make config
if [ -n "$XDG_CURRENT_DESKTOP" ]; then
  make ui
fi


# Personal stuff
cd ~/repos

git hub dotclux tf2configs vitae
git bb dotcisco gpg-pass mumble-keys ssh

./ssh/install.sh
./gpg-pass/install.sh
./mumble-keys/install.sh

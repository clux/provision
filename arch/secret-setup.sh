#!/bin/bash
export ANSIBLE_NOCOWS=1

get_ssh_from_root() {
  # Decrypt ssh key used to fetch secrets
  mkdir -p ~/.ssh
  # Fetch files copied by live.sh
  sudo cp /root/main_id.{pub,gpg} ~/.ssh/
  sudo chown "$USER:$USER" ~/.ssh/main_id*
  gpg -d ~/.ssh/main_id.gpg > ~/.ssh/main_id
  chmod 0600 ~/.ssh/main_id
  chmod 0644 ~/.ssh/main_id.pub
  rm ~/.ssh/main_id.gpg
}

fetch_secret_repos() {
  echo "Unlocking gogs.gpg - 'library' password please"
  gpg -d vars/gogs.yml.gpg > vars/gogs.yml
  echo "Unlocking main_id ssh key - password please"
  keychain --timeout 30 --quiet --host agent ~/.ssh/main_id
  source ~/.keychain/agent-sh
  ansible-playbook -i hosts -l "${HOSTNAME}" -e 'host_key_checking=False' secrets.yml -vvv
}

setup_dotfiles() {
  mkdir -p ~/repos && cd ~/repos
  git clone git@github.com:clux/dotfiles.git
  cd dotfiles
  just link
  just system
}

main() {
  set -e
  if [[ $EUID -eq 0 ]]; then
    echo "This role is not indended to be run as root"
    exit 1
  fi
  # interactive steps with passwords and key pasting here:
  set -x
  sudo chown -R "$USER:$USER" /usr/local # First sudo
  # If we haven't set up our ssh key from genprov, do so now
  [ -f ~/.ssh/main_id ] || get_ssh_from_root
  # If we haven't installed the last secret repo, fetch all repos
  [ -f ~/.ssh/work_id ] || fetch_secret_repos
  # Install repos we haven't yet installed
  [ -d ~/.gnupg/.git ] || ~/gpg/install.sh
  [ -d ~/.ssh/.git ] || ~/ssh/install.sh
  # Delete the rest
  rm -rf ~/ssh ~/gpg
  # Set up dotfiles
  [ -L ~/.functions ] || setup_dotfiles
}

# If we were not sourced as a library, pass arguments onto main
if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  main "$@"
else
  echo "${BASH_SOURCE[0]} sourced"
fi

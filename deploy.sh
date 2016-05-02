#!/bin/bash
source dev.sh
if [[ $1 == "bootstrap" ]]; then
  sudo chown -R "$USER" /usr/local
  ansible-playbook -i hosts -vv --ask-become-pass $1
fi

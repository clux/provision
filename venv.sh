#!/bin/bash
set -x

VENV_BIN="virtualenv2"
if ! hash virtualenv2 2> /dev/null; then
  if hash pacman 2> /dev/null; then
    pacman -S --noconfirm python2-virtualenv
  else
    VENV_BIN="virtualenv"
  fi
fi

if [ ! -d venv ]; then
  "$VENV_BIN" -p "$(which python2)" venv
fi
source venv/bin/activate

export ANSIBLE_NOCOWS=1
echo "Entering virtual env $VIRTUAL_ENV"
pip install -r requirements.txt > /dev/null

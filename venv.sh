set -e

if ! hash virtualenv2 2> /dev/null; then
  pacman -S --noconfirm python2-virtualenv
fi

if [ ! -d venv ]; then
  virtualenv2 -p $(which python2) venv
fi
source venv/bin/activate

export ANSIBLE_NOCOWS=1
echo "Entering virtual env $VIRTUAL_ENV"
pip install -r requirements.txt

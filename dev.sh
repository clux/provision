if [ ! -d venv ]; then
  virtualenv -p $(which python2) venv
fi
source venv/bin/activate
echo "Entering virtual env $VIRTUAL_ENV"
pip install -r requirements.txt

# .clux
Use this if you are clux and you are reinstalling linux.

## Usage
Get git first, clone this repo, then plow through these scripts:

```bash
sudo apt-get install git
cd && mkdir repos && cd repos
git clone https://github.com/clux/.clux.git fix
cd fix
sudo ./linux
./node 0.8.16
./shell
./git
# PASTE SSH KEYS
# setup chrome, user account picture, pidgin, guake (then continue in guake)
./editor
./cpy
./repos
cd .. && rm -rf fix
npm install symlink
./node_modules/symlink/symlink.js -tr .
rm -rf node_modules
```

## Script Description
### node
Gets specified version of node, makes, installs locally.

### shell
Prepares everything related to bashrc; texlive path, local node + npm symlinks to ~/local/bin + paths + npm completion.

### git
Initializes the git config and sets up ssh keys to paste to github.

### editor
Scrapes the latest 64bit linux sublime text url and extracts it to HOME dir.

### linux
apt basics

### cpy
Installs settings for:

- sublime_text2
- jshint
- gconf/keyb

### repos
clones all personal modules + installs standard global modules

### symlink
npm links together personal modules (they can because node is under HOME and my modules have no cyclical dependencies) and installs the remaining dependencies from npm.

NB: since I want the deps for symlink analyzed as well, I need a temporary non-global install of symlink to do the analyzing.

## License
Licensed to clux exclusively

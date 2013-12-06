# dotclux
Use this if you are clux and you are reinstalling linux.
Last attempted with Mint 15 Cinnamon x64.

## Usage
Follow this, in order listed:

```bash
sudo apt-get install git curl g++
cd && mkdir repos && cd repos
git clone https://github.com/clux/dotclux.git fix
cd fix
sudo ./linux
./node 0.10.22 # can be in parallel with previous
./shell
./git
# PASTE SSH KEYS
# setup chrome, guake (then continue in guake)
./editor
./cpy
# if not at work, install and link local repos
./repos
cd .. && rm -rf fix
npm install symlink
./node_modules/symlink/symlink.js -r . -g tap -d
rm -rf node_modules
# while symlinking add sublime license and add guake + redshift to startup apps
# perhaps tweak the npm dependency tree of your modules i symlinking did something silly

# if at work - get extra dependencies and setup fileserver links
./work

# set up user account picture (may be on networked drive), pidgin
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
- redshift

### repos
clones all personal modules + installs standard global modules

### symlink
npm links together personal modules (they can because node is under HOME and my modules have no cyclical dependencies) and installs the remaining dependencies from npm.

NB: since I want the deps for symlink analyzed as well (because it's my module), I need a temporary non-global install of symlink to do the analyzing.

## License
Licensed to clux exclusively

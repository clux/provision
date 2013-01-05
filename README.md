# .clux
Use this if you are clux and you are reinstalling linux.

## Usage
Get git first, clone this repo, then plow through these scripts:

```bash
sudo apt-get install git
cd && mkdir repos && cd repos
git clone https://github.com/clux/.clux.git fix
cd fix
./linux
./node 0.8.16
./rcs
./git
# PASTE SSH KEYS
./editor
./cpy
./repos
cd .. && rm -rf fix
npm install symlink
./node_modules/symlink/symlink.js fsx operators ... symlink deathmatch ..
npm uninstall symlink
```

## Script Description
### node
Gets specified version of node, makes, installs and chowns global node_modules folder.
Last two steps will ask for sudo pw.

### rcs
Adds stuff that's needed to `.bashrc`; texlive, local node bin and npm completion.

### git
Initializes the git config and sets up ssh keys to paste to github.

### editor
Scrapes the latest 32bit linux sublime text url and extracts it to HOME dir.

### linux
apt-get basics

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

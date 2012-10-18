# .clux
Use this if you are clux and you are reinstalling linux.

## Usage
Get git & chrome separately, clone this repo, then plow through these scripts:

```bash
cd && mkdir repos && cd repos
git clone https://github.com/clux/.clux.git fix
cd fix
./linux
./node 0.8.12
./git
# PASTE SSH KEYS
./editor
./cpy
./repos
cd .. && rm -rf fix
./symlink fsx operators ... deathmatch ..
```

## Script Description
### node
Gets specified version of node, makes, installs and chowns global node_modules folder.
Last two steps will ask for sudo pw.

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
npm links together personal modules (they can because node is under HOME and my modules have no cyclical dependencies)
and installs the remaining dependencies from npm

## License
Licensed to clux exclusively

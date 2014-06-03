# dotclux
Use this if you are clux and you are reinstalling linux.
Last attempted with Mint 16 Cinnamon x64.

## Usage
Follow this, in order listed:

```bash
sudo apt-get install -y -qq git curl g++
mkdir repos && cd repos && git clone https://github.com/clux/dotclux.git df && cd df

# run these in parallel
sudo ./linux
./node 0.10.24
# need to wait for node - so setup a few things outside installation:
# - startup apps: guake, redshift, pidgin, remove caribou
# - keyboard layout: add "us int dead", alt-shift change, caps compose
# - guake configure
# - look and feel of UI
./shell
# continue in guake (applies new bashrc)
./editor
./git
./cpy
# login to chrome and dvcs services and paste ssh keys
./repos
# while repos is cloning and setting up their dependencies:
# - setup sublime text license
# - setup sublime package control and install clang formater plugin
# - user account picture

# if at work - get extra dependencies and setup fileserver links
./work
```

## Script Description
### linux
apt basics

### node
Gets specified version of node, makes, installs locally. Leaves a pre-compiled folder of that node version in ~/Downloads for quick version switching.

### shell
Prepares shell shortcuts, PATH extensions and npm auto-completion.

### git
Initializes the git config and sets up ssh keys to paste to github.

### editor
Scrapes the latest 64bit linux sublime text 3 url and extracts it to ~/local/sublime_text_3.

### cpy
Installs settings for:

- sublime_text2
- jshint
- redshift

### repos
Does a bunch of stuff with my git and npm modules:

- Installs global npm modules
- Clones all personal modules
- npm link all my personal modules so they are available globally (in correct order)

## License
Licensed to clux exclusively

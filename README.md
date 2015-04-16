# dotclux
Use this if you are clux and you are installing linux.

## Usage
Follow this, in order listed:

```sh
sudo apt-get install -y -qq git curl g++ xclip guake
mkdir repos && cd repos && git clone https://github.com/clux/dotclux.git df && cd df

# run these in parallel:
sudo ./linux
./node 0.10.38
./io 1.3.6
./git
# need to wait - so setup a few things outside installation when possible:
# - startup apps: clean out what isn't needed (likely everything)
# - keyboard layout: add "us int dead", alt-shift change, caps compose
# - look and feel of UI: { effects: OFF, mouse: PAD, general: SCALE }
# - login to chrome and dvcs services and paste ssh keys (once chrome is there)

./editor # and related install tasks below
./cpy
./shell
# continue in guake (applies new bashrc)
./repos
# clean up `df` directory if no changes were made - otherwise commit there
./cleanup

# if at work - clone work gist and follow that
```

## Script Description
### linux
apt basics

### node
basic node fetcher and installer into `~/local/node` - still not sold on `nvm`

### git
Initializes the git config and sets up ssh keys to paste to github.

### editor
Fetches the latest `amd64.deb` sublime text 3 build and `dpkg` installs it.

Afterwards:

- setup sublime [license](https://mail.google.com/mail/u/0/#search/sublime+license/13a942d72a211e81)
- setup sublime [package control](https://packagecontrol.io/installation)

Then install the following packages:

- SublimeLinter
- SublimeLinter-jshint # `jshint` installed in npmdeps
- SublimeLinter-json
- SublimeLinter-cppcheck # `cppcheck` installed in linux - catches basics
- SublimeLinter-shellcheck
- SublimeLinter-pep8 # pep8 from pythondeps
- Seti_UI

The SublimeLinter-contrib-clang is too manual to be worth it. Have to set all flags and include dirs yourself.

### cpy
Installs settings for:

- sublime_text3
- jshint
- redshift

Safe to do after sublime has been installed (i.e. after `editor`)

### shell
Prepares shell shortcuts, PATH extensions and npm auto-completion.

### repos
Does a bunch of stuff with my git and npm modules - requires `shell` swap.

- Installs global npm modules
- Clones all personal modules
- npm link all my personal modules so they are available globally (in correct order)

### llvm
The entire llvm toolchain; llvm, clang, clang extras, compiler-rt. Prepares for a global install, and leaves a pre-compiled version in ~/Downloads for version switching.

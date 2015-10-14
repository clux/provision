# dotclux
Personal Linux reinstall scripts and configs.

## Usage
Bootstrap and run main script:

```sh
sudo apt-get install -y -qq git curl
mkdir repos && cd repos && git clone https://github.com/clux/dotclux.git df && cd df
sudo ./jessie.sh
```

## Manual tasks
Need to wait for at least `git` to finish before tweaking chrome, so can do the following things first:

- startup apps: clean out what isn't needed
- keyboard layout: add "us int dead", alt-shift change, caps compose
- look and feel of UI: { effects: OFF, mouse: PAD, general: SCALE }

After `git`:

- login to chrome and dvcs services and paste ssh keys (once chrome is there)

After `editor`:

- setup sublime [license](https://mail.google.com/mail/u/0/#search/sublime+license/13a942d72a211e81)
- setup sublime [package control](https://packagecontrol.io/installation)

Then install the following packages:

- SublimeLinter
- SublimeLinter-jshint # `jshint` installed in `npmdeps`
- SublimeLinter-eslint # `eslint` installed in `npmdeps`
- SublimeLinter-json
- SublimeLinter-cppcheck # `cppcheck` installed in `linux`
- SublimeLinter-shellcheck # `shellcheck` installed in `linux`
- SublimeLinter-pylint # `pylint` installed in `pipdeps`
- Seti_UI
- Stylus (language)
- MarkdownEditing # (reopen .md files after restart - `cpy` settings should have been preserved by install)

The SublimeLinter-contrib-clang is too manual to be worth it. Have to set all flags and include dirs yourself.

Finally, if at work - clone work gist and follow that.

## Script Description
### linux
apt basics

### node
basic node fetcher and installer into `~/local/node` - not sold on `nvm`

### git
Initializes the git config and sets up ssh keys to paste to github.

### editor
Fetches the latest `amd64.deb` sublime text 3 build and `dpkg` installs it.

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

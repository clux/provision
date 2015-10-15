# dotclux
Personal Linux reinstall scripts and configs. Only tested on Debian 8 lately, but should work on most debian based systems.

## Usage
Fetch latest version of this repo and deploy:

```sh
wget -qO- https://github.com/clux/dotclux/archive/master.tar.gz | tar xz
sudo ./dotclux-master/desktop.sh
```

## Manual tasks
Need to wait for at least `ssh` to finish before doing all chrome things, so can do the following things first:

- startup apps: clean out what isn't needed
- keyboard layout: add "us int dead", alt-shift change, caps compose
- look and feel of UI: { effects: OFF, mouse: PAD, general: SCALE }

After `ssh`:

- login to chrome and dvcs services and paste ssh keys (once chrome is there)

After `editor`:

- setup sublime [license](https://mail.google.com/mail/u/0/#search/sublime+license/13a942d72a211e81)
- setup sublime [package control](https://packagecontrol.io/installation)

Then install the following packages:

- SublimeLinter
- SublimeLinter-jshint # `jshint` installed in `npm`
- SublimeLinter-eslint # `eslint` installed in `npm`
- SublimeLinter-json
- SublimeLinter-cppcheck # `cppcheck` installed in `apt`
- SublimeLinter-shellcheck # `shellcheck` installed in `apt`
- SublimeLinter-pylint # `pylint` installed in `pip`
- Seti_UI
- Stylus (language)
- MarkdownEditing # (reopen .md files after restart - `cpy` settings should have been preserved by install)

The SublimeLinter-contrib-clang is too manual to be worth it. Have to set all flags and include dirs yourself.

Finally, if at work - clone work gist and follow that.

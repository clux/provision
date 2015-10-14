# dotclux
Personal Linux reinstall scripts and configs.

## Usage
Fetch latest version of this repo and deploy:

```sh
wget https://github.com/clux/dotclux/archive/master.zip && unzip master.zip && rm master.zip
cd dotclux-master
sudo ./jessie.sh
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

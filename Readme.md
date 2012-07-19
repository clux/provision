# .clux
Get git, clone the repo, then plow through these scripts:

````bash
cd && mkdir repos && cd repos
git clone git@github.com:clux/.clux.git
cd .clux
./node 0.8.3
./git
./cpy
./repos
````

# Node Setup
Execute once (asks for sudo pw at the end)

# Git Config
Execute once and paste resulting key to github

# Copy Configs
Installs settings for:

- sublime_text2
- jshint

# Repos Setup
Verify lists are updated, then execute (must be done after node script so that global modules are chowned). Links all my modules to each other using npm link.

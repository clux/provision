#!/bin/bash
set -e
old=$(localectl)

localectl set-locale LANG=en_GB.UTF-8
localectl set-keymap colemak
localectl set-x11-keymap us pc104 colemak

diff <(echo "$old") <(echo $(localectl))

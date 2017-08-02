#!/bin/bash
set -e
old=$(timedatectl)

timedatectl set-ntp true
timedatectl set-timezone Europe/London

diff <(echo "$old") <(timedatectl)

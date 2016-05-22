#!/bin/bash
set -e
old=$(timedatectl)

timedatectl set-ntp true

diff <(echo $old) <(echo $(timedatectl))

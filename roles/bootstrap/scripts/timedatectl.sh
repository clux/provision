#!/bin/bash
old=$(timedatectl)

timedatectl set-ntp true

diff <(echo $old) <(echo $(timedatectl))

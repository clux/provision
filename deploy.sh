#!/bin/bash
source dev.sh
ansible-playbook -i hosts -vv --ask-become-pass $1

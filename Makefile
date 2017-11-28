
SHELL := /bin/bash

define green
	@tput -T xterm setaf 2
	@echo -n "$1"
	@tput -T xterm sgr0
	@echo -e "\t$2"
endef
define yellow
	@tput -T xterm setaf 3
	@echo -n "$1"
	@tput -T xterm sgr0
	@echo -e "\t$2"
endef

.PHONY: help

# yellow targets escalate with --become
help:
	@tput -T xterm bold
	$(call green,"Main targets:")
	$(call yellow," bootstrap", "root bootstrap configuration during first boot")
	$(call green," secrets", "check out and set up secrets")
	$(call yellow," core", "full provision")
	$(call green," cargo", "upgrade rust packages")
	$(call green," pip", "upgrade python packages")
	$(call green," npm", "upgrade npm packages")
	$(call yellow," pacman", "upgrade pacman packages")

core:
	@./DEPLOY core -fsc

pip:
	@./DEPLOY pip -f

npm:
	@./DEPLOY npm -f

cargo:
	@./DEPLOY cargo -f

pacman:
	@sudo pacman -Syu

lint:
	yamllint *.yml roles/ vars/
	test -z "$(find roles/ -type f -iname '*.yaml')" && echo "Extensions OK"
	shellcheck DEPLOY archboot/*.sh genprov.sh

test: lint
	bats test

.PHONY: core pip npm cargo pacman lint test


SHELL := /bin/bash

define green
	@tput -T xterm setaf 2
	@echo -n "$1"
	@tput -T xterm sgr0
	@echo -e "\t$2"
endef
define red
	@tput -T xterm setaf 1
	@echo -n "$1"
	@tput -T xterm sgr0
	@echo -e "\t$2"
endef

.PHONY: help

help:
	@tput -T xterm bold
	$(call green,"Main targets:")
	$(call green," bootstrap", "root bootstrap configuration during first boot")
	$(call green," secrets", "check out and set up secrets")
	$(call green," cargo", "upgrade/install rust modules")
	$(call green," pip", "upgrade/install python modules")
	$(call green," npm", "upgrade/install npm modules")

pip:
	@./DEPLOY pip -f

npm:
	@./DEPLOY npm -f

cargo:
	@./DEPLOY cargo -fc


.PHONY: pip npm cargo

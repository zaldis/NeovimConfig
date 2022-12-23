SHELL := /bin/bash
.DEFAULT_GOAL := help

export PIP_REQUIRE_VIRTUALENV=true
UNAME := $(shell uname)

# Colors
PAD := =========================================
RED          := $(shell tput -Txterm setaf 1)
GREEN        := $(shell tput -Txterm setaf 2)
YELLOW       := $(shell tput -Txterm setaf 3)
LIGHTPURPLE  := $(shell tput -Txterm setaf 4)
PURPLE       := $(shell tput -Txterm setaf 5)
BLUE         := $(shell tput -Txterm setaf 6)
WHITE        := $(shell tput -Txterm setaf 7)
RESET        := $(shell tput -Txterm sgr0)

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s # %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

ifneq (, $(shell which python3))
	PY := $(shell which python3)
else
	PY := python
endif

help:
	@echo -e "\n$(YELLOW)Available targets$(RESET)\n$(PAD)" && $(PY) -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

checkshell: ## check Shell files
	@shellcheck --shell=bash --format=gcc scripts/*.sh

checklua: ## check Lua files
	@luacheck --formatter plain nvim

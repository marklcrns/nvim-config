SHELL = /bin/bash
vim := $(if $(shell which nvim),nvim,$(shell which vim))
vim_version := '${shell $(vim) --version}'
XDG_CACHE_HOME ?= $(HOME)/.cache
XDG_CONFIG_HOME ?= $(HOME)/.config

default: install

install: install-dep create-dirs

update: update-repo

upgrade: update

install-dep:
	scripts/install.sh

create-dirs:
	@mkdir -vp "$(XDG_CACHE_HOME)/vim/"{backup,session,swap,tags,undo}

update-repo:
	git pull --ff --ff-only

clean:
	rm -rf "$(XDG_CACHE_HOME)/vim"

.PHONY: install create-dirs update-repo update-plugins clean test

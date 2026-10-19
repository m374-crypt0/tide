SHELL := /bin/bash
MAKEFLAGS += --no-print-directory

TIDE_ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(firstword \
	$(MAKEFILE_LIST))))/..)

IDE_WEB_APP_ROOT_DIR := $(TIDE_ROOT_DIR)/ide-web-app
REGISTRY_ROOT_DIR := $(TIDE_ROOT_DIR)/registry
NON_ROOT_USER_ROOT_DIR := $(TIDE_ROOT_DIR)/non-root-user
IDE_ROOT_DIR := $(TIDE_ROOT_DIR)/ide
DOCKER_IN_DOCKER_ROOT_DIR := $(TIDE_ROOT_DIR)/docker-in-docker
EMACS_ROOT_DIR := $(TIDE_ROOT_DIR)/emacs

include $(REGISTRY_ROOT_DIR)/.env
include $(NON_ROOT_USER_ROOT_DIR)/.env
include $(IDE_ROOT_DIR)/.env
include $(DOCKER_IN_DOCKER_ROOT_DIR)/.env
include $(EMACS_ROOT_DIR)/.env
include $(IDE_WEB_APP_ROOT_DIR)/.env

$(REGISTRY_ROOT_DIR)/.env:
$(NON_ROOT_USER_ROOT_DIR)/.env:
$(IDE_ROOT_DIR)/.env:
$(DOCKER_IN_DOCKER_ROOT_DIR)/.env:
$(EMACS_ROOT_DIR)/.env:
$(IDE_WEB_APP_ROOT_DIR)/.env:
	@ . $(IDE_WEB_APP_ROOT_DIR)/scripts/env.bash

export

.PHONY: help
help:
	@ . $(IDE_WEB_APP_ROOT_DIR)/scripts/help.bash

.PHONY: build
build:
	@ . $(IDE_WEB_APP_ROOT_DIR)/scripts/build.bash

.PHONY: up
up:
	@ . $(IDE_WEB_APP_ROOT_DIR)/scripts/up.bash

.PHONY: login
login:
	@ . $(IDE_WEB_APP_ROOT_DIR)/scripts/login.bash

.PHONY: down
down:
	@ . $(IDE_WEB_APP_ROOT_DIR)/scripts/down.bash

.PHONY: rm
rm:
	@ . $(IDE_WEB_APP_ROOT_DIR)/scripts/rm.bash

.PHONY: ps
ps:
	@ . $(IDE_WEB_APP_ROOT_DIR)/scripts/ps.bash

.PHONY: push
push:
	@ . $(IDE_WEB_APP_ROOT_DIR)/scripts/push.bash

.PHONY: pull
pull:
	@ . $(IDE_WEB_APP_ROOT_DIR)/scripts/pull.bash

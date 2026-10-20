SHELL := /bin/bash
MAKEFLAGS += --no-print-directory

TIDE_ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(firstword \
	$(MAKEFILE_LIST))))/..)

IDE_MODERN_CPP_ROOT_DIR := $(TIDE_ROOT_DIR)/ide-modern-cpp
REGISTRY_ROOT_DIR := $(TIDE_ROOT_DIR)/registry
NON_ROOT_USER_ROOT_DIR := $(TIDE_ROOT_DIR)/non-root-user
DOCKER_IN_DOCKER_ROOT_DIR := $(TIDE_ROOT_DIR)/docker-in-docker
LLVM_ROOT_DIR := $(TIDE_ROOT_DIR)/llvm
EMACS_ROOT_DIR := $(TIDE_ROOT_DIR)/emacs
IDE_ROOT_DIR := $(TIDE_ROOT_DIR)/ide

include $(REGISTRY_ROOT_DIR)/.env
include $(NON_ROOT_USER_ROOT_DIR)/.env
include $(DOCKER_IN_DOCKER_ROOT_DIR)/.env
include $(LLVM_ROOT_DIR)/.env
include $(EMACS_ROOT_DIR)/.env
include $(IDE_ROOT_DIR)/.env
include $(IDE_MODERN_CPP_ROOT_DIR)/.env

$(REGISTRY_ROOT_DIR)/.env:
$(NON_ROOT_USER_ROOT_DIR)/.env:
$(DOCKER_IN_DOCKER_ROOT_DIR)/.env:
$(LLVM_ROOT_DIR)/.env:
$(EMACS_ROOT_DIR)/.env:
$(IDE_ROOT_DIR)/.env:
$(IDE_MODERN_CPP_ROOT_DIR)/.env:
	@ . $(IDE_MODERN_CPP_ROOT_DIR)/scripts/env.bash

export

.PHONY: help
help:
	@ . $(IDE_MODERN_CPP_ROOT_DIR)/scripts/help.bash

.PHONY: build
build:
	@ . $(IDE_MODERN_CPP_ROOT_DIR)/scripts/build.bash

.PHONY: up
up:
	@ . $(IDE_MODERN_CPP_ROOT_DIR)/scripts/up.bash

.PHONY: login
login:
	@ . $(IDE_MODERN_CPP_ROOT_DIR)/scripts/login.bash

.PHONY: down
down:
	@ . $(IDE_MODERN_CPP_ROOT_DIR)/scripts/down.bash

.PHONY: rm
rm:
	@ . $(IDE_MODERN_CPP_ROOT_DIR)/scripts/rm.bash

.PHONY: ps
ps:
	@ . $(IDE_MODERN_CPP_ROOT_DIR)/scripts/ps.bash

.PHONY: push
push:
	@ . $(IDE_MODERN_CPP_ROOT_DIR)/scripts/push.bash

.PHONY: pull
pull:
	@ . $(IDE_MODERN_CPP_ROOT_DIR)/scripts/pull.bash

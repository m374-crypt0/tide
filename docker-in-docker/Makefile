SHELL := /bin/bash
MAKEFLAGS += --no-print-directory

TIDE_ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(firstword \
	$(MAKEFILE_LIST))))/..)

DOCKER_IN_DOCKER_ROOT_DIR := $(TIDE_ROOT_DIR)/docker-in-docker
REGISTRY_ROOT_DIR := $(TIDE_ROOT_DIR)/registry
ALPINE_PINNED_ROOT_DIR := $(TIDE_ROOT_DIR)/alpine-pinned
NON_ROOT_USER_ROOT_DIR := $(TIDE_ROOT_DIR)/non-root-user

include $(REGISTRY_ROOT_DIR)/.env
include $(ALPINE_PINNED_ROOT_DIR)/.env
include $(NON_ROOT_USER_ROOT_DIR)/.env
include $(DOCKER_IN_DOCKER_ROOT_DIR)/.env

$(REGISTRY_ROOT_DIR)/.env:
$(ALPINE_PINNED_ROOT_DIR)/.env:
$(NON_ROOT_USER_ROOT_DIR)/.env:
$(DOCKER_IN_DOCKER_ROOT_DIR)/.env:
	@ . $(DOCKER_IN_DOCKER_ROOT_DIR)/scripts/env.bash

export

.PHONY: help
help:
	@ . $(DOCKER_IN_DOCKER_ROOT_DIR)/scripts/help.bash

.PHONY: build
build:
	@ $(MAKE) -C $(NON_ROOT_USER_ROOT_DIR) build
	@ . $(DOCKER_IN_DOCKER_ROOT_DIR)/scripts/build.bash

.PHONY: rm
rm:
	@ . $(DOCKER_IN_DOCKER_ROOT_DIR)/scripts/rm.bash

.PHONY: ps
ps:
	@ . $(DOCKER_IN_DOCKER_ROOT_DIR)/scripts/ps.bash

.PHONY: push
push:
	@ . $(DOCKER_IN_DOCKER_ROOT_DIR)/scripts/push.bash

.PHONY: login
login:
	@ . $(DOCKER_IN_DOCKER_ROOT_DIR)/scripts/login.bash

.PHONY: pull
pull:
	@ . $(DOCKER_IN_DOCKER_ROOT_DIR)/scripts/pull.bash

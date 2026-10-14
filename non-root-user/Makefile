SHELL := /bin/bash
MAKEFLAGS += --no-print-directory

TIDE_ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(firstword \
	$(MAKEFILE_LIST))))/..)

NON_ROOT_USER_ROOT_DIR := $(TIDE_ROOT_DIR)/non-root-user
REGISTRY_ROOT_DIR := $(TIDE_ROOT_DIR)/registry
ALPINE_PINNED_ROOT_DIR := $(TIDE_ROOT_DIR)/alpine-pinned

include $(REGISTRY_ROOT_DIR)/.env
include $(ALPINE_PINNED_ROOT_DIR)/.env
include $(NON_ROOT_USER_ROOT_DIR)/.env

$(REGISTRY_ROOT_DIR)/.env:
$(ALPINE_PINNED_ROOT_DIR)/.env:
$(NON_ROOT_USER_ROOT_DIR)/.env:
	@ . $(NON_ROOT_USER_ROOT_DIR)/scripts/env.bash

export

.PHONY: help
help:
	@ . $(NON_ROOT_USER_ROOT_DIR)/scripts/help.bash

.PHONY: build
build:
	@ . $(NON_ROOT_USER_ROOT_DIR)/scripts/build.bash

.PHONY: rm
rm:
	@ . $(NON_ROOT_USER_ROOT_DIR)/scripts/rm.bash

.PHONY: ps
ps:
	@ . $(NON_ROOT_USER_ROOT_DIR)/scripts/ps.bash

.PHONY: push
push:
	@ . $(NON_ROOT_USER_ROOT_DIR)/scripts/push.bash

.PHONY: pull
pull:
	@ . $(NON_ROOT_USER_ROOT_DIR)/scripts/pull.bash

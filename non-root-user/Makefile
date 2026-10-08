SHELL := /bin/bash
MAKEFLAGS += --no-print-directory
NON_ROOT_USER_ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(firstword \
	$(MAKEFILE_LIST)))))
REGISTRY_ROOT_DIR := $(patsubst %/,%,$(abspath \
	$(NON_ROOT_USER_ROOT_DIR)/../registry))
ALPINE_PINNED_ROOT_DIR := $(patsubst %/,%,$(abspath \
	$(NON_ROOT_USER_ROOT_DIR)/../alpine-pinned))

include $(NON_ROOT_USER_ROOT_DIR)/.env
include $(REGISTRY_ROOT_DIR)/.env
include $(ALPINE_PINNED_ROOT_DIR)/.env

$(REGISTRY_ROOT_DIR)/.env:
	@ $(MAKE) -C $(REGISTRY_ROOT_DIR) $(REGISTRY_ROOT_DIR)/.env

$(ALPINE_PINNED_ROOT_DIR)/.env:
	@ $(MAKE) -C $(ALPINE_PINNED_ROOT_DIR) $(ALPINE_PINNED_ROOT_DIR)/.env

$(NON_ROOT_USER_ROOT_DIR)/.env:
	@ . $(NON_ROOT_USER_ROOT_DIR)/scripts/env.bash

export

.PHONY: help
help:
	@ . $(NON_ROOT_USER_ROOT_DIR)/scripts/help.bash

.PHONY: build
build:
	@ $(MAKE) -C $(ALPINE_PINNED_ROOT_DIR) build
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

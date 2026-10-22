SHELL := /bin/bash
MAKEFLAGS += --no-print-directory

THIS_ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(firstword \
	$(MAKEFILE_LIST)))))

TIDE_ROOT_DIR := $(shell git -C '$(MAKEFILE_DIR)' rev-parse \
	--show-toplevel 2>/dev/null)

EMACS_ROOT_DIR := $(THIS_ROOT_DIR)
REGISTRY_ROOT_DIR := $(TIDE_ROOT_DIR)/registry
ALPINE_PINNED_ROOT_DIR := $(TIDE_ROOT_DIR)/base-images/alpine-pinned
NON_ROOT_USER_ROOT_DIR := $(TIDE_ROOT_DIR)/base-images/non-root-user
LLVM_ROOT_DIR := $(TIDE_ROOT_DIR)/resources/llvm

include $(REGISTRY_ROOT_DIR)/.env
include $(ALPINE_PINNED_ROOT_DIR)/.env
include $(NON_ROOT_USER_ROOT_DIR)/.env
include $(LLVM_ROOT_DIR)/.env
include $(EMACS_ROOT_DIR)/.env

$(REGISTRY_ROOT_DIR)/.env:
$(ALPINE_PINNED_ROOT_DIR)/.env:
$(NON_ROOT_USER_ROOT_DIR)/.env:
$(LLVM_ROOT_DIR)/.env:
$(EMACS_ROOT_DIR)/.env:
	@ . $(EMACS_ROOT_DIR)/scripts/env.bash

export

.PHONY: help
help:
	@ . $(EMACS_ROOT_DIR)/scripts/help.bash

.PHONY: build
build:
	@ . $(EMACS_ROOT_DIR)/scripts/build.bash

.PHONY: rm
rm:
	@ . $(EMACS_ROOT_DIR)/scripts/rm.bash

.PHONY: ps
ps:
	@ . $(EMACS_ROOT_DIR)/scripts/ps.bash

.PHONY: push
push:
	@ . $(EMACS_ROOT_DIR)/scripts/push.bash

.PHONY: pull
pull:
	@ . $(EMACS_ROOT_DIR)/scripts/pull.bash

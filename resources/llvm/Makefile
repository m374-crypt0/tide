SHELL := /bin/bash
MAKEFLAGS += --no-print-directory

THIS_ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(firstword \
	$(MAKEFILE_LIST)))))

TIDE_ROOT_DIR := $(shell git -C '$(MAKEFILE_DIR)' rev-parse \
	--show-toplevel 2>/dev/null)

LLVM_ROOT_DIR := $(THIS_ROOT_DIR)
REGISTRY_ROOT_DIR := $(TIDE_ROOT_DIR)/registry
ALPINE_PINNED_ROOT_DIR := $(TIDE_ROOT_DIR)/base-images/alpine-pinned
NON_ROOT_USER_ROOT_DIR := $(TIDE_ROOT_DIR)/base-images/non-root-user

include $(REGISTRY_ROOT_DIR)/.env
include $(ALPINE_PINNED_ROOT_DIR)/.env
include $(NON_ROOT_USER_ROOT_DIR)/.env
include $(LLVM_ROOT_DIR)/.env

$(REGISTRY_ROOT_DIR)/.env:
$(ALPINE_PINNED_ROOT_DIR)/.env:
$(NON_ROOT_USER_ROOT_DIR)/.env:
$(LLVM_ROOT_DIR)/.env:
	@ . $(LLVM_ROOT_DIR)/scripts/env.bash

export

.PHONY: help
help:
	@ . $(LLVM_ROOT_DIR)/scripts/help.bash

.PHONY: build
build:
	@ . $(LLVM_ROOT_DIR)/scripts/build.bash

.PHONY: rm
rm:
	@ . $(LLVM_ROOT_DIR)/scripts/rm.bash

.PHONY: ps
ps:
	@ . $(LLVM_ROOT_DIR)/scripts/ps.bash

.PHONY: push
push:
	@ . $(LLVM_ROOT_DIR)/scripts/push.bash

.PHONY: pull
pull:
	@ . $(LLVM_ROOT_DIR)/scripts/pull.bash

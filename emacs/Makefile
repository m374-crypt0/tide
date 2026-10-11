SHELL := /bin/bash
MAKEFLAGS += --no-print-directory
EMACS_ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(firstword \
	$(MAKEFILE_LIST)))))
LLVM_ROOT_DIR := $(patsubst %/,%,$(abspath \
	$(EMACS_ROOT_DIR)/../llvm))
REGISTRY_ROOT_DIR := $(patsubst %/,%,$(abspath \
	$(EMACS_ROOT_DIR)/../registry))
NON_ROOT_USER_ROOT_DIR := $(patsubst %/,%,$(abspath \
	$(EMACS_ROOT_DIR)/../non-root-user))

include $(EMACS_ROOT_DIR)/.env
include $(LLVM_ROOT_DIR)/.env
include $(REGISTRY_ROOT_DIR)/.env
include $(NON_ROOT_USER_ROOT_DIR)/.env

$(REGISTRY_ROOT_DIR)/.env:
	@ $(MAKE) -C $(REGISTRY_ROOT_DIR) $(REGISTRY_ROOT_DIR)/.env

$(NON_ROOT_USER_ROOT_DIR)/.env:
	@ $(MAKE) -C $(NON_ROOT_USER_ROOT_DIR) $(NON_ROOT_USER_ROOT_DIR)/.env

$(LLVM_ROOT_DIR)/.env:
	@ $(MAKE) -C $(LLVM_ROOT_DIR) $(LLVM_ROOT_DIR)/.env

$(EMACS_ROOT_DIR)/.env:
	@ . $(EMACS_ROOT_DIR)/scripts/env.bash

export

.PHONY: help
help:
	@ . $(EMACS_ROOT_DIR)/scripts/help.bash

.PHONY: build
build:
	@ $(MAKE) -C $(LLVM_ROOT_DIR) build
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

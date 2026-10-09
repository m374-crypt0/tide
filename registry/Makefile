SHELL := /bin/bash
MAKEFLAGS += --no-print-directory
REGISTRY_ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(firstword \
	$(MAKEFILE_LIST)))))

include $(REGISTRY_ROOT_DIR)/.env

$(REGISTRY_ROOT_DIR)/.env:
	@ . $(REGISTRY_ROOT_DIR)/scripts/env.bash

export

.PHONY: help
help:
	@ . $(REGISTRY_ROOT_DIR)/scripts/help.bash

.PHONY: build
build:
	@ . $(REGISTRY_ROOT_DIR)/scripts/build.bash

.PHONY: up
up:
	@ . $(REGISTRY_ROOT_DIR)/scripts/up.bash

.PHONY: down
down:
	@ . $(REGISTRY_ROOT_DIR)/scripts/down.bash

.PHONY: rm
rm:
	@ . $(REGISTRY_ROOT_DIR)/scripts/rm.bash

.PHONY: ps
ps:
	@ . $(REGISTRY_ROOT_DIR)/scripts/ps.bash

.PHONY: push
push:
	@ . $(REGISTRY_ROOT_DIR)/scripts/push.bash

.PHONY: pull
pull:
	@ . $(REGISTRY_ROOT_DIR)/scripts/pull.bash

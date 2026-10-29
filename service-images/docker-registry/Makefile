SHELL := /bin/bash
MAKEFLAGS += --no-print-directory

THIS_ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(firstword \
	$(MAKEFILE_LIST)))))

TIDE_ROOT_DIR := $(shell git -C '$(MAKEFILE_DIR)' rev-parse \
	--show-toplevel 2>/dev/null)

DOCKER_REGISTRY_ROOT_DIR := $(THIS_ROOT_DIR)

include $(DOCKER_REGISTRY_ROOT_DIR)/.env

$(DOCKER_REGISTRY_ROOT_DIR)/.env:
	@ . $(DOCKER_REGISTRY_ROOT_DIR)/scripts/env.bash

export

.PHONY: help
help:
	@ . $(DOCKER_REGISTRY_ROOT_DIR)/scripts/help.bash

.PHONY: build
build:
	@ . $(DOCKER_REGISTRY_ROOT_DIR)/scripts/build.bash

.PHONY: up
up:
	@ . $(DOCKER_REGISTRY_ROOT_DIR)/scripts/up.bash

.PHONY: gc
gc:
	@ . $(DOCKER_REGISTRY_ROOT_DIR)/scripts/gc.bash

.PHONY: down
down:
	@ . $(DOCKER_REGISTRY_ROOT_DIR)/scripts/down.bash

.PHONY: rm
rm:
	@ . $(DOCKER_REGISTRY_ROOT_DIR)/scripts/rm.bash

.PHONY: ps
ps:
	@ . $(DOCKER_REGISTRY_ROOT_DIR)/scripts/ps.bash

.PHONY: push
push:
	@ . $(DOCKER_REGISTRY_ROOT_DIR)/scripts/push.bash

.PHONY: pull
pull:
	@ . $(DOCKER_REGISTRY_ROOT_DIR)/scripts/pull.bash

SHELL := /bin/bash
MAKEFLAGS += --no-print-directory

THIS_ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(firstword \
	$(MAKEFILE_LIST)))))

TIDE_ROOT_DIR := $(shell git -C '$(MAKEFILE_DIR)' rev-parse \
	--show-toplevel 2>/dev/null)

ALPINE_PINNED_ROOT_DIR := $(THIS_ROOT_DIR)
DOCKER_REGISTRY_ROOT_DIR := $(TIDE_ROOT_DIR)/service-images/docker-registry

include $(DOCKER_REGISTRY_ROOT_DIR)/.env
include $(ALPINE_PINNED_ROOT_DIR)/.env

$(DOCKER_REGISTRY_ROOT_DIR)/.env:
$(ALPINE_PINNED_ROOT_DIR)/.env:
	@ . $(ALPINE_PINNED_ROOT_DIR)/scripts/env.bash

export

.PHONY: help
help:
	@ . $(ALPINE_PINNED_ROOT_DIR)/scripts/help.bash

.PHONY: build
build:
	@ . $(ALPINE_PINNED_ROOT_DIR)/scripts/build.bash

.PHONY: rm
rm:
	@ . $(ALPINE_PINNED_ROOT_DIR)/scripts/rm.bash

.PHONY: ps
ps:
	@ . $(ALPINE_PINNED_ROOT_DIR)/scripts/ps.bash

.PHONY: push
push:
	@ . $(ALPINE_PINNED_ROOT_DIR)/scripts/push.bash

.PHONY: pull
pull:
	@ . $(ALPINE_PINNED_ROOT_DIR)/scripts/pull.bash

SHELL := /bin/bash
MAKEFLAGS += --no-print-directory

THIS_ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(firstword \
	$(MAKEFILE_LIST)))))

TIDE_ROOT_DIR := $(shell git -C '$(MAKEFILE_DIR)' rev-parse \
	--show-toplevel 2>/dev/null)

LOCAL_DOCKER_REGISTRY_ROOT_DIR := $(THIS_ROOT_DIR)

include $(LOCAL_DOCKER_REGISTRY_ROOT_DIR)/.env

$(LOCAL_DOCKER_REGISTRY_ROOT_DIR)/.env:
	@ . $(LOCAL_DOCKER_REGISTRY_ROOT_DIR)/scripts/env.bash

export

.PHONY: help
help:
	@ . $(LOCAL_DOCKER_REGISTRY_ROOT_DIR)/scripts/help.bash

.PHONY: build
build:
	@ . $(LOCAL_DOCKER_REGISTRY_ROOT_DIR)/scripts/build.bash

.PHONY: up
up:
	@ . $(LOCAL_DOCKER_REGISTRY_ROOT_DIR)/scripts/up.bash

.PHONY: gc
gc:
	@ . $(LOCAL_DOCKER_REGISTRY_ROOT_DIR)/scripts/gc.bash

.PHONY: down
down:
	@ . $(LOCAL_DOCKER_REGISTRY_ROOT_DIR)/scripts/down.bash

.PHONY: rm
rm:
	@ . $(LOCAL_DOCKER_REGISTRY_ROOT_DIR)/scripts/rm.bash

.PHONY: ps
ps:
	@ . $(LOCAL_DOCKER_REGISTRY_ROOT_DIR)/scripts/ps.bash

.PHONY: push
push:
	@ . $(LOCAL_DOCKER_REGISTRY_ROOT_DIR)/scripts/push.bash

.PHONY: pull
pull:
	@ . $(LOCAL_DOCKER_REGISTRY_ROOT_DIR)/scripts/pull.bash

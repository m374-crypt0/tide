SHELL := /bin/bash
MAKEFLAGS += --no-print-directory

THIS_ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(firstword \
	$(MAKEFILE_LIST)))))

TIDE_ROOT_DIR := $(shell git -C '$(MAKEFILE_DIR)' rev-parse \
	--show-toplevel 2>/dev/null)

STRIX_HALO_ROOT_DIR := $(THIS_ROOT_DIR)
DOCKER_REGISTRY_ROOT_DIR := $(TIDE_ROOT_DIR)/docker-registry
NON_ROOT_USER_ROOT_DIR := $(TIDE_ROOT_DIR)/base-images/non-root-user
LLVM_ROOT_DIR := $(TIDE_ROOT_DIR)/resource-images/llvm

include $(DOCKER_REGISTRY_ROOT_DIR)/.env
include $(NON_ROOT_USER_ROOT_DIR)/.env
include $(LLVM_ROOT_DIR)/.env
include $(STRIX_HALO_ROOT_DIR)/.env

$(DOCKER_REGISTRY_ROOT_DIR)/.env:
$(NON_ROOT_USER_ROOT_DIR)/.env:
$(LLVM_ROOT_DIR)/.env:
$(STRIX_HALO_ROOT_DIR)/.env:
	@ . $(STRIX_HALO_ROOT_DIR)/scripts/env.bash

export

.PHONY: help
help:
	@ . $(STRIX_HALO_ROOT_DIR)/scripts/help.bash

.PHONY: ensure-non-rootless
ensure-non-rootless:
	@ . $(STRIX_HALO_ROOT_DIR)/scripts/ensure-non-rootless.bash

.PHONY: ensure-env-is-set
ensure-env-is-set:
	@ . $(STRIX_HALO_ROOT_DIR)/scripts/ensure-env-is-set.bash

.PHONY: ensure-running
ensure-running:
	@ . $(STRIX_HALO_ROOT_DIR)/scripts/ensure-running.bash

.PHONY: build
build: ensure-non-rootless
	@ . $(STRIX_HALO_ROOT_DIR)/scripts/build.bash

.PHONY: up
up: ensure-non-rootless
	@ . $(STRIX_HALO_ROOT_DIR)/scripts/up.bash

.PHONY: model-download
model-download: ensure-non-rootless ensure-env-is-set  ensure-running
	@ . $(STRIX_HALO_ROOT_DIR)/scripts/model-download.bash

.PHONY: model-set
model-set: script=
model-set: ensure-non-rootless ensure-env-is-set ensure-running
	@ . $(STRIX_HALO_ROOT_DIR)/scripts/model-set.bash

.PHONY: model-up
model-up: ensure-non-rootless ensure-env-is-set ensure-running
	@ . $(STRIX_HALO_ROOT_DIR)/scripts/model-up.bash

.PHONY: model-down
model-down: ensure-non-rootless ensure-env-is-set ensure-running
	@ . $(STRIX_HALO_ROOT_DIR)/scripts/model-down.bash

.PHONY: down
down: ensure-non-rootless
	@ . $(STRIX_HALO_ROOT_DIR)/scripts/down.bash

.PHONY: rm
rm: ensure-non-rootless
	@ . $(STRIX_HALO_ROOT_DIR)/scripts/rm.bash

.PHONY: ps
ps:
	@ . $(STRIX_HALO_ROOT_DIR)/scripts/ps.bash

.PHONY: push
push: ensure-non-rootless
	@ . $(STRIX_HALO_ROOT_DIR)/scripts/push.bash

.PHONY: pull
pull: ensure-non-rootless
	@ . $(STRIX_HALO_ROOT_DIR)/scripts/pull.bash

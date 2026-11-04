SHELL := /bin/bash
MAKEFLAGS += --no-print-directory

THIS_ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(firstword \
	$(MAKEFILE_LIST)))))

TIDE_ROOT_DIR := $(shell git -C '$(MAKEFILE_DIR)' rev-parse \
	--show-toplevel 2>/dev/null)

ADVG_ROOT_DIR := $(THIS_ROOT_DIR)
LOCAL_DOCKER_REGISTRY_ROOT_DIR := $(TIDE_ROOT_DIR)/service-images/local-docker-registry
NON_ROOT_USER_ROOT_DIR := $(TIDE_ROOT_DIR)/base-images/non-root-user
LLVM_ROOT_DIR := $(TIDE_ROOT_DIR)/resource-images/llvm

include $(LOCAL_DOCKER_REGISTRY_ROOT_DIR)/.env
include $(NON_ROOT_USER_ROOT_DIR)/.env
include $(LLVM_ROOT_DIR)/.env
include $(ADVG_ROOT_DIR)/.env

$(LOCAL_DOCKER_REGISTRY_ROOT_DIR)/.env:
$(NON_ROOT_USER_ROOT_DIR)/.env:
$(LLVM_ROOT_DIR)/.env:
$(ADVG_ROOT_DIR)/.env:
	@ . $(ADVG_ROOT_DIR)/scripts/env.bash

export

.PHONY: help
help:
	@ . $(ADVG_ROOT_DIR)/scripts/help.bash

# TODO: ensure-non-rootless is refactorable in ${TIDE_ROOT_DIR}/.scripts
.PHONY: ensure-non-rootless
ensure-non-rootless:
	@ . $(ADVG_ROOT_DIR)/scripts/ensure-non-rootless.bash

.PHONY: ensure-env-is-set
ensure-env-is-set:
	@ . $(ADVG_ROOT_DIR)/scripts/ensure-env-is-set.bash

.PHONY: ensure-running
ensure-running:
	@ . $(ADVG_ROOT_DIR)/scripts/ensure-running.bash

.PHONY: build
build: ensure-non-rootless
	@ . $(ADVG_ROOT_DIR)/scripts/build.bash

.PHONY: up
up: ensure-non-rootless
	@ . $(ADVG_ROOT_DIR)/scripts/up.bash

.PHONY: model-fetch
model-fetch: ensure-non-rootless ensure-env-is-set  ensure-running
	@ . $(ADVG_ROOT_DIR)/scripts/model-fetch.bash

.PHONY: model-set
model-set: script=
model-set: ensure-non-rootless ensure-env-is-set ensure-running
	@ . $(ADVG_ROOT_DIR)/scripts/model-set.bash

.PHONY: decoding-up
decoding-up: ensure-non-rootless ensure-env-is-set ensure-running
	@ . $(ADVG_ROOT_DIR)/scripts/decoding-up.bash

.PHONY: decoding-down
inference-down: ensure-non-rootless ensure-env-is-set ensure-running
	@ . $(ADVG_ROOT_DIR)/scripts/decoding-down.bash

.PHONY: down
down: ensure-non-rootless
	@ . $(ADVG_ROOT_DIR)/scripts/down.bash

.PHONY: rm
rm: ensure-non-rootless
	@ . $(ADVG_ROOT_DIR)/scripts/rm.bash

.PHONY: ps
ps:
	@ . $(ADVG_ROOT_DIR)/scripts/ps.bash

.PHONY: push
push: ensure-non-rootless
	@ . $(ADVG_ROOT_DIR)/scripts/push.bash

.PHONY: pull
pull: ensure-non-rootless
	@ . $(ADVG_ROOT_DIR)/scripts/pull.bash

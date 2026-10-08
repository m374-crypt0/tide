SHELL := /bin/bash
MAKEFLAGS += --no-print-directory
DOCKER_IN_DOCKER_ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(firstword \
	$(MAKEFILE_LIST)))))
REGISTRY_ROOT_DIR := $(patsubst %/,%,$(abspath \
	$(DOCKER_IN_DOCKER_ROOT_DIR)/../registry))
NON_ROOT_USER_ROOT_DIR := $(patsubst %/,%,$(abspath \
	$(DOCKER_IN_DOCKER_ROOT_DIR)/../non-root-user))

include $(DOCKER_IN_DOCKER_ROOT_DIR)/.env
include $(REGISTRY_ROOT_DIR)/.env
include $(NON_ROOT_USER_ROOT_DIR)/.env

# TODO: remove comments in Makefiles
# There is a dependency to the registry service
$(REGISTRY_ROOT_DIR)/.env:
	@ $(MAKE) -C $(REGISTRY_ROOT_DIR) $(REGISTRY_ROOT_DIR)/.env

# There is a dependency to the alpine-pinned service
$(NON_ROOT_USER_ROOT_DIR)/.env:
	@ $(MAKE) -C $(NON_ROOT_USER_ROOT_DIR) $(NON_ROOT_USER_ROOT_DIR)/.env

$(DOCKER_IN_DOCKER_ROOT_DIR)/.env:
	@ . $(DOCKER_IN_DOCKER_ROOT_DIR)/scripts/env.bash

export

.PHONY: help
help:
	@ . $(DOCKER_IN_DOCKER_ROOT_DIR)/scripts/help.bash

.PHONY: build
build:
	@ $(MAKE) -C $(NON_ROOT_USER_ROOT_DIR) build
	@ . $(DOCKER_IN_DOCKER_ROOT_DIR)/scripts/build.bash

.PHONY: rm
rm:
	@ . $(DOCKER_IN_DOCKER_ROOT_DIR)/scripts/rm.bash

.PHONY: ps
ps:
	@ . $(DOCKER_IN_DOCKER_ROOT_DIR)/scripts/ps.bash

.PHONY: push
push:
	@ . $(DOCKER_IN_DOCKER_ROOT_DIR)/scripts/push.bash

.PHONY: login
login:
	@ . $(DOCKER_IN_DOCKER_ROOT_DIR)/scripts/login.bash

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
	@ . $(REGISTRY_ROOT_DIR)/.env
	@ . $(REGISTRY_ROOT_DIR)/scripts/build.bash

SHELL := /bin/bash
MAKEFLAGS += --no-print-directory
REGISTRY_ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(firstword \
	$(MAKEFILE_LIST)))))

export

help:
	@ . $(REGISTRY_ROOT_DIR)/scripts/help.bash

init:
	@ . $(REGISTRY_ROOT_DIR)/scripts/init.bash

MAKEFLAGS += --no-print-directory

SHELL := /bin/bash
TIDE_ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

export

.PHONY: help
help:
	@echo targets: help test watch

.PHONY: init_submodules
init_submodules:
	@git submodule update --init --recursive

.PHONY: test
test: init_submodules
	@. ./test/runner/test.sh

.PHONY: watch
watch: init_submodules
	@. ./test/runner/watch.sh

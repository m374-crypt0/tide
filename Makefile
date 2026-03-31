MAKEFLAGS += --no-print-directory

SHELL := /bin/bash
TIDE_ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

export

.PHONY: help
help:
	@echo targets: help test watch

.PHONY: test
test:
	@. ./test/runner/test.sh

.PHONY: watch
watch:
	@. ./test/runner/watch.sh

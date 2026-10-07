SHELL := /bin/bash
MAKEFLAGS += --no-print-directory
MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

help:
	@ . $(MAKEFILE_DIR)/scripts/help.bash

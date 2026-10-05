#!/bin/env bash

~/.local/share/gem/ruby/3.3.0/bin/bashly g -qu

"${TIDE_ROOT_DIR}test/bats/bin/bats" -pr "${TIDE_ROOT_DIR}test/suites"

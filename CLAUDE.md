# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

## Project overview

**tide** is a Docker-based development environment CLI tool (successor to
*nideovim*). The vision is a rootless-Docker, Alpine-based dev environment that
can be integrated into any project via a `.tide/` directory. The CLI has two
entry points:

- `src/install` — bootstrapped via `curl | bash`, downloads `tide` and `tideup`
  into `$TIDE_INSTALL_DIR` (default `~/.tide/`)
- `src/tide` — the main CLI (still being built)
- `src/tideup` — the updater (still being built)

All scripts are bash. The shebang is `#!/bin/env bash`.

## Commands

```bash
# Run the full test suite
make test

# Watch src/ and test/ for changes and re-run tests automatically (requires inotifywait)
make watch
```

To run a single test file directly:

```bash
./test/bats/bin/bats test/suites/unit/install.bats
./test/bats/bin/bats test/suites/integration/install.bats
```

To run a single test by name:

```bash
./test/bats/bin/bats --filter 'test name pattern' test/suites/unit/install.bats
```

## Test architecture

Tests use [bats-core](https://github.com/bats-core/bats-core) with three helper
libraries, all managed as git submodules:

- `test/bats/` — bats-core test runner
- `test/test_helper/bats-support/` — base assertion helpers
- `test/test_helper/bats-assert/` — `assert_output`, `assert_success`,
  `assert_failure`, etc.
- `test/test_helper/bats-file/` — `assert_file_exists`, `assert_dir_exists`,
  `assert_files_equal`, etc.

Test suites live in `test/suites/` split by `unit/` and `integration/`. The
runner (`test/runner/test.sh`) invokes bats with `-pr` (pretty, recursive)
against the entire `test/suites/` tree. `TIDE_ROOT_DIR` is exported by the
Makefile and used in both runner scripts and test setup to build absolute
paths.

# ideas in draft

- successor of nideovim
- still docker-based dev env
- docker rootless from the very beginning
- drop docker desktop support
- direct cli instead of invoked by make
- using Alpine instead of Debian
- can be integrated into any project (.tide dir)
- allow users to develop their own tide types
  - global, host local or project local
  - think about a registry (github repo)
- allow users to move their built instances easily to avoid rebuild
- enhance composability
- rethink the init process, lighter, data file more intuitive (ini + posix tooling)
- take into account rootless docker for user management
- get inspired by github env to look how it works
- create its very own glossary
  - types (from nideovim), could become templates
  - instances (from nideovim), could stay as is

## pseudo plan

- define how to interact with *tide*
  - [x] tideup to install the thing
  - tide ... to use the thing
- Full test suite and coverage
  - using bats-core

### tideup - install it

- [x] should be easy, same stuff as *rakeup*, a curl command, interpreted by *bash*

### tide - the CLI

- almost same command/verb set of *nideovim*
- plus stuff to create new types, publish them
- plus stuff to export / import instances
- plus stuff to customize at build time with user's Dockerfile
- plus stuff to be scriptable (no interactive mode, could be integrated in
  CI/CD pipelines)

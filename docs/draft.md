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

## tide - the CLI

- almost same command/verb set of *nideovim*
- plus stuff to create new types, publish them
- plus stuff to export / import instances
- plus stuff to customize at build time with user's Dockerfile
- plus stuff to customize at run time with user's compose file
- plus stuff to be scriptable (no interactive mode, could be integrated in
  CI/CD pipelines)

## requirements

- docker, docker compose and buildx plugins
- git

## how it works

- pure CLI
- installed in user home directory in the *.tide* directory
- must be protected against concurrent accesses
- first class citizen is the project
  - installed either in the root dir of the current git repository or in the
    current directory
- have an official repository of templates
- can define per-project user defined templates
- can be seen as a docker wrapper for full featured development environments
  (like github dev containers)

## user workflows

### user developer (instance user)

1. Create a *tide project* within her git repository: `tide init`
2. Create an *instance* corresponding to its workload: `tide instance new`
3. Use her *instance*: `tide instance login`
4. Work within the *instance* then logout from it
5. Stop the *instance*: `tide instance stop`

### contributor developer (template creator)

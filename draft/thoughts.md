# ideas in draft

- successor of nideovim
- still docker-based dev env
- docker rootless from the very beginning
- drop docker desktop support
- direct cli instead of invoked by make
- using Alpine instead of Debian
- can be integrated into any project (.tide dir)
- allow users to develop their own tide templates
  - official, host local or project local
  - think about a registry (github repo) for official templates
  - push official template in docker hub repositories
- allow users to move their built instances easily to avoid rebuild
  - ideally, dedicated feature not using underlying docker inner details
- enhance composability of templates
  - keep ancestor chain
  - allow build customization
  - allow run customization
- rethink the init process, lighter, data file more intuitive (ini + posix tooling)
  - both for build and run
  - data file as a preferred way to embed variables
- take into account rootless docker for user management
- get inspired by github env to look how it works
- create its very own glossary
  - types (from nideovim), could become templates
  - instances (from nideovim), could stay as is

## tide - the CLI

- almost same command/verb set of *nideovim*
- plus stuff to create new types, publish them
- plus stuff to export / import instances
- plus stuff to customize at build time with user's Dockerfile and data file
- plus stuff to customize at run time with user's compose file and data file
- plus stuff to be scriptable (no interactive mode, could be integrated in
  CI/CD pipelines)
  - such as hook scripts
- plus stuff to configure tide itself (`tide config ...`)

## requirements

- docker, docker compose and buildx plugins
- docker rootless
- git

## how it works

- pure CLI
- installed in user home directory in the *.tide* directory
- must be protected against concurrent accesses
- first class citizen is the project
  - installed either in the root dir of the current git repository or in the
    current directory
- have an official repository of templates
- can define per-project user defined templates (either project local or system
  wide)
- can be seen as a docker wrapper for full featured development environments
  (like github dev containers)

## user workflows

### user setup

1. execute the command to install: `curl -L https://raw.githubusercontent.com/m374-crypt0/tide/refs/heads/main/src/install | bash`
2. source *bashrc* or start a new shell session
3. run `tideup` to actually install `tide`

### user developer (instance user)

1. Create a *tide project* within her git repository: `tide init`
2. Create an *instance* corresponding to its workload: `tide instance new`
3. Query the *instance* information: `tide instance info`
   - status: *created (not built or pulled), stopped (built or pulled, not
    running) and running*
   - underlying template name and provenance of this template
   - customization points (on-demand, dedicated verb)
     - build data file and Dockerfile
     - run data file and compose.yaml
4. Use her *instance*: `tide instance login`
   - may ask for build if not already done or pulled
     `tide instance build`
   - may ask for run if not already done
     `tide instance run`
5. Work within the *instance* then logout from it
6. Use her *instance*: `tide instance login` (any number of time)
7. Stop the *instance*: `tide instance stop`

### contributor developer (template creator)

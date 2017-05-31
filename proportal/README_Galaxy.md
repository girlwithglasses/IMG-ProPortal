# IMG / ProPortal: Galaxy #

## What is it for? ##

Galaxy is a free, open-source analysis environment and workflow builder. Galaxy provides a framework for running third party tools and creating shareable pipelines for data analysis.

## Get the code ##

The IMG / ProPortal Galaxy installation is located at `/webfs/projectdirs/microbial/img/external/galaxy`, and is tracking the `master` branch of the Galaxy GitHub repo, `https://github.com/galaxyproject/galaxy`.

Instructions for setting up Galaxy: `https://galaxyproject.org/admin/get-galaxy/`

## Dependencies ##

### Python ###

Galaxy runs on python 2.7 and manages its own python modules, downloading any that it needs.

### Apache ###

Galaxy runs its own server, but it is far more efficient to proxy requests through Apache and have Apache deal with static resources (javascript, css, images, etc.). The IMG Galaxy installation runs at `https://img-galaxy-test.jgi.doe.gov`. The virtual host is configured using the Apache rules described at `https://galaxyproject.org/admin/config/apache-proxy/` .

### Database backend ###

Galaxy uses a PostgreSQL server. See `config/galaxy.ini` for the config information.

### Configuration ###

The current Galaxy config files are maintained in SVN at `/webUI/galaxy/` and the Galaxy installation symlinks to these files. The primary configuration file is `/webUI/galaxy/config.ini`.

### Third-Party Tools ###

Tool dependencies are largely managed by conda, `https://anaconda.org`. New Galaxy tools can be installed from the Galaxy Toolshed, and are found in `/webfs/projectdirs/microbial/img/external/tool-deps/` (the path to this directory has to be short due to a limitation with conda, hence not having it within the `galaxy` directory).

### IMG Galaxy tools ###



### Logs ###


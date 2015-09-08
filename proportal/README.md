# IMG / ProPortal #

## What is it for? ##

The IMG ProPortal provides access and tools for the ProPortal, a subset of the IMG database focussed on *Prochlorococcus*, *Synechococcus*, and cyanophage spp.

Data comes from the IMG GOLD Oracle database and is served by a Perl application.

The project is a collaboration between IMG and MIT, with the projected user base being a global community of biologists interested in these particular marine microbe species.

The code uses the Dancer2 framework, and can be run locally (e.g. on a laptop) using any PSGI/Plack server; by default, installing Plack (a prerequisite of Dancer2) gives you a basic server that can be used for demo purposes. See the Dancer2 documentation for other deployment options.

## Get the code ##

```
#!bash

git clone https://bitbucket.org/berkeleylab/gn-img-proportal-mojo

```
(TO DO: fix permissions to allow global access)

## Dependencies ##

Perl modules: install from cpan; see `cpanfile` in this distribution for the required modules.

* existing IMG Perl installation (from SVN -- for non-ProPortal stuff)
* WebConfig and WebConfigCommon modules (and their dependencies) are required for setting up the environment
* access to third party / external tools (blast, etc.) is optional since this is a demo

### Installation ###

- get the code:

```
#!bash

git clone https://bitbucket.org/berkeleylab/gn-img-proportal-mojo

```

## Set up ##

* Database configuration (taken from IMG WebConfig.pm): set database config parameters in `environments/development.pl`.

## Launching the server

* `cd` to the distribution directory and run `plackup bin/app.psgi`. You'll see a message like `HTTP::Server::PSGI: Accepting connections at http://0:5000/`. Visit `http://localhost:5000` in your browser to view the site.

See the `plackup` documentation on options for running different Plack/PSGI servers.


## Set up with existing IMG installation ##

- install the existing IMG code:

```
#!bash

svn co https://svn.jgi-psf.org/viewvc/img_dev/

```
- run install script with params

- create config file ...

- run `plackup bin/app.psgi` to start the service;

- visit http://localhost:5000 to view the data.

* libsass:
* node / npm
* bower

## Usage

* `cd` to the distribution directory and run `npm install` and then `bower install` (you'll need gulp install as well)
* `gulp styles` runs the SASS compiler (requires libsass: see ...), autoprefixer, and pixrem
* `gulp jshint` runs jshint on the JS files
* `gulp watch` will enable `livereload` and development version
* `gulp build` for production versions with minified `js` and `css` files


### How to run tests ###

### Deployment instructions ###

### Contribution guidelines ###

#### Writing tests ####

#### Code review ####

#### Other guidelines ####

* All display code (html, css, js, etc.) goes into the templates. No exceptions!
* Keep code modular and as loosely coupled as possible. Reduce module interdependency.
* [Task::Kensho] for module suggestions

* Use npm, gulp, and bower to manage JS/CSS dependencies, compile SASS, minify JS, etc.

### Who do I talk to? ###

* Amelia Ireland, aireland@lbl.gov
* Ken Chu, klchu@lbl.gov
* Other team members:

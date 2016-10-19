# IMG / ProPortal #

## What is it for? ##

The IMG ProPortal provides access and tools for the ProPortal, a subset of the IMG database focussed on *Prochlorococcus*, *Synechococcus*, and cyanophage spp.

Data comes from the IMG Oracle databases and is served by a Perl application. A demo version of the ProPortal can be run off an SQLite database.

The project is a collaboration between IMG and MIT, with the projected user base being a global community of biologists interested in these particular marine microbe species.

The code uses the Dancer2 framework, and can be run locally (e.g. on a laptop) using any PSGI/Plack server; by default, installing Plack (a prerequisite of Dancer2) gives you a basic server that can be used for demo purposes. See the Dancer2 documentation for other deployment options.

## Get the code ##

All the ProPortal code lives in the IMG svn repository under /proportal and /webui.cgi. If installing from GitHub, download and extract the code, or clone the repository with the command:

	git clone https://github.com/girlwithglasses/IMG-ProPortal.git

## Dependencies ##

### Perl! ###

To keep things neat and tidy, we are going to install a clean version of perl and the ProPortal dependencies using `perlbrew`.

Install `perlbrew` from https://perlbrew.pl (follow the instructions on the website).

Use `perlbrew` to install the CPAN client `cpanm` and `patchperl`:

	perlbrew install-cpanm
	perlbrew install-patchperl

Now install a local version of a recent version of Perl, and create a standard library to go with it:

	perlbrew install perl-5.18.4
	perlbrew lib create perl-5.18.4@std
	perlbrew switch perl-5.18.4@std

You're now using perl version 5.18.4 and any extra modules you install will be in the library `@std`.

Install the ProPortal dependencies using `cpanm`. You'll need to locate the path to `cpanfile` in the `proportal` folder; in this example, it's in my home directory within  the folder `webUI`.

	cpanm --cpanfile ~/webUI/proportal/cpanfile --installdeps ~/webUI/proportal/

Install BioPerl (more detailed instructions at http://bioperl.org/INSTALL.html if required):

	cpanm CJFIELDS/BioPerl-1.6.924.tar.gz

Some modules may need to be installed by hand, including `DBD::Oracle` (for installations not using Oracle databases, this should not be an issue).


### Apache ###

You will need to have `mod_rewrite`, `mod_proxy`, and `mod_expires` enabled in your Apache config file (usually `/private/etc/apache2/httpd.conf`); find the lines

	LoadModule proxy_module libexec/apache2/mod_proxy.so
	LoadModule proxy_http_module libexec/apache2/mod_proxy_http.so

	LoadModule expires_module libexec/apache2/mod_expires.so

	LoadModule rewrite_module libexec/apache2/mod_rewrite.so

and make sure that they are uncommented.

On MacOS X, you can drop sample_server.conf (in `proportal/apache/` in the git repository) into `/private/etc/apache2/other/` and make sure that the line

	Include /private/etc/apache2/other/

is uncommented in your Apache config file (usually `/private/etc/apache2/httpd.conf`).

Check that the new configuration works by running

	sudo apachectl configtest

Restart the server to activate the new server configuration using the command

	sudo apachectl -k restart

The configuration included sets up a ProPortal server at http://img-proportal.dev. Check it is working by visiting this URL:

	http://img-proportal.dev/... [TO DO!]


Test out the Apache installation by


### Other software ###

Install JBrowse:

download JBrowse from http://jbrowse.org






ProPortal uses bower to manage web-related dependencies -- javascript and CSS libraries, etc. Bower can be installed



### Installation on genepool (NERSC users) ###

To set up bower, you need to activate the nodejs module and install the assets. `cd` to your home directory and do the following:

	module add nodejs  (for genepool)
	npm install npm


    - install npm (Node Package Manager)
    - install bower, and then

        ubuntu 14 LTS install
        - sudo apt-get install nodejs
        - sudo apt-get install npm
        - sudo ln -s /usr/bin/nodejs /usr/bin/node OR sudo apt-get install nodejs-legacy
        - sudo apt-get install git
        - sudo npm install -g bower
        --- I did have issues so I had to undo everything -- eg sudo apt-get remove --purge node


It's much easier if you now set npm's default install directory to your own home directory, as illustrated in the instructions here:
https://docs.npmjs.com/getting-started/fixing-npm-permissions -- use option 2. (for genepool)

    module load nodejs/4.2.6
    npm config set prefix '/webfs/projectdirs/microbial/img/npm-global'

in ~/.profile or ~/.bashrc:

	export PATH=/webfs/projectdirs/microbial/img/npm-global:$PATH


When you have done this, you can install bower globally:
    `npm install -g bower`

Now `cd` to the `proportal` directory, and run
    `bower install`

If you look in the `public` folder, you should find a `bower` directory with various sub-directories containing javascript and css.

### Installation ###

## Simple set up: ProPortal pages only on Genepool servers ##

* The majority of config parameters are set in `environments/development.pl`. The parameters that may need to be changed are the database login details and the URLs for the application. To get the current database login details, run the following from the proportal directory:

    `perl script/write_db_config_files.pl`

This will parse the database config files and dump the relevant DB details as JSON files in the `environments` directory.
The database config details (username, password) should be copied into development.pl

TODO: create development.pl from source files.

## Launching the server

`cd` to the distribution directory `proportal` and run the launch script using `plackup bin/app.psgi`. You'll see a message like `HTTP::Server::PSGI: Accepting connections at http://0:5000/`. Visit `http://localhost:5000` in your browser to view the site.

See the `plackup` documentation on options for running different Plack/PSGI servers. Starman is a good option for standard use. Sample launch instructions:

`plackup -E development -s Starman --workers=10 bin/app.psgi`

By default, Plack reads `app.psgi` once and keeps the application in memory. To allow live development, you can use the Shotgun loader, which will reload the application if any of the source files have changed. To do this, launch the app with the following command:

`plackup -L Shotgun bin/app.psgi`

## Set up to include the cgi-based installation ##

* WebConfig.pm and WebConfigCommon.pm need to be edited to provide the correct parameters. Anything that previously pointed
to the Apache cgi-bin directory needs to point at $base/webUI/webui.cgi, and the htdocs directory should now be
$base/webUI/webui.htd. If there are two .htd directories for an installation (e.g. for proportal), the files should be
combined into a single directory.

Set $base to the directory that the webUI installation is installed in. The following parameters should be changed:

    base_url      => "https://<server-name>/pristine_assets",
    cgi_url       => "https://<server-name>/cgi-bin",
    domain_name   => "<server-name>",
    https_cgi_url => "https://<server-name>/cgi-bin/main.cgi",
    tmp_url       => "https://<server-name>/tmp",

    base_dir      => $base . "/webUI/webui.htd",
    cgi_dir       => $base . "/webUI/webui.cgi",
    scriptEnv_script => $base . "/webUI/webui.cgi/bin/scriptEnv.sh",
    tmp_dir       => $base . "/tmp",
    top_base_url  => "https://img.jgi.doe.gov/",

This is not a comprehensive list but will suffice for simple usage.

- run `plackup bin/server-app.psgi` to start the server;

- visit http://<server-name> to view the data.

## Application Structure ##

The ProPortal app is split into a number of parts. Core application functionality is in the webui.cgi/IMG::* modules, and
ProPortal-specific code is (generally) in /proportal/lib/. Modules with general functionality will be shifted to the
IMG:: namespace.

The ProPortal modules consist of the following:

ProPortalPackage.pm -- wrapper for all ProPortal modules.

DataModel::*        -- DBIx::DataModel models of the Gold and core databases

Routes::*           -- Dancer-based routing modules that parse the URL and dispatch the appropriate request.

AppCore             -- Dancer-based functionality common to all routes, such as checks on incoming requests and template
                       defaults. Caching capabilities are available but not yet implemented.

ProPortal::Controller::*    -- controllers for specific ProPortal routes. Base.pm has the core controller functionality. Controllers and their functionality are independent of Dancer.

ProPortal::IO::*    -- Input/output-related modules. Currently just DBIxDataModel
                    -- previously had other modules but these are no longer in use.

ProPortal::Util::*  -- various utility modules, including adaptors for Dancer2 plugins that have now been abandoned.


The IMG modules consist of the following:

IMG::App.pm         -- wrapper for the IMG core app functionality. Functionality is
                    implemented using roles in the IMG::App::* namespace. An IMG::App
                    instance can be created de novo, or automatically created by the ProPortal app.

General App.pm functionality:

- Database connections: DBIx::Connector connections to the databases.
- Dispatch: parameter parsing, selecting which module to load
- FileManager and IMG::Util::File: centralized file manager and useful file parsing shortcuts
- HTTP client: defaults to a new HTTP::Tiny instance
- JGISessionClient: interacts with Caliban to check the JGI session is valid
- PreFlight: runs preflight checks to ensure the environment is ready
- Schema:    provides access to the Gold and core databases via DBIx::DataModel
- User:      access to user data and user checks

TODO:
- logger
- cache

IMG::App::Role::LinkManager:  Link manager. In development.
IMG::App::Role::MenuManager:  Menu manager. In development.
IMG::App::Role::Templater:    renders a Template::Toolkit template

IMG::Util::Base:    defines sets of modules to be loaded together; see Import::Base
IMG::Util::DB:      useful database-related functions, mostly DB config file-related.
IMG::Util::Untaint: untaint your paths!

IMG::Views::ExternalLinks   functional interface to external link data
IMG::Views::Links           functional interface to internal link data


## Installing Galaxy

Install Galaxy from

- biojs2galaxy, for using biojs tools:

http://www.benjamenwhite.com/2015/07/biojs2galaxy-a-step-by-step-guide/

	then install MSA tool:
	biojs2galaxy msa -o <path2galaxy>/config/plugins/visualizations/


## Installing JBrowse

Download the latest JBrowse release from http://jbrowse.org.


## Usage


### How to run tests ###

### Deployment instructions ###


## Development ##

* Node.js and NPM apps: ProPortal uses Bower to manage its web dependencies (e.g. JS and CSS libraries), and Gulp to compile
stylesheets and minify javascript. To install gulp, use the command `npm install -g gulp`. `cd` to the `proportal` directory,
and run `gulp install` to automatically install the required modules.

* libsass: SASS is a compiled stylesheet language that makes it easy to write CSS in a more programmatic manner (e.g. using
variables, creating functions, etc.). To install libsass for SASS compilation, follow the instructions at
https://github.com/sass/sassc/blob/master/docs/building/unix-instructions.md

* `gulp styles` runs the SASS compiler (requires libsass), autoprefixer, and pixrem
* `gulp jshint` runs jshint on the JS files
* `gulp watch` will enable `livereload` and development version
* `gulp build` for production versions with minified `js` and `css` files

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

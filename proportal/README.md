# IMG / ProPortal #

## What is it for? ##

The IMG ProPortal provides access and tools for the ProPortal, a subset of the IMG database focussed on *Prochlorococcus*, *Synechococcus*, and cyanophage spp.

Data comes from the IMG Oracle databases and is served by a Perl application. A demo version of the ProPortal can be run off an SQLite database.

The project is a collaboration between IMG and MIT, with the projected user base being a global community of biologists interested in these particular marine microbe species.

The code uses the Dancer2 framework, and can be run locally (e.g. on a laptop) using any PSGI/Plack server; by default, installing Plack (a prerequisite of Dancer2) gives you a basic server that can be used for demo purposes. See the Dancer2 documentation for other deployment options.

## Get the code ##

All the ProPortal code lives in the IMG svn repository under /proportal and /webui.cgi. If installing from GitHub, download and extract the code, or clone the repository with the command:

	git clone https://github.com/ialarmedalien/IMG-ProPortal.git

I have installed it in my home directory with the base directory renamed `webUI` to mimic the IMG svn structure; my git command was:

	git clone https://github.com/ialarmedalien/IMG-ProPortal.git ~/webUI

## Dependencies ##

### Perl! ###

To keep things neat and tidy, we are going to install a clean version of Perl and the ProPortal dependencies using `perlbrew`. Perlbrew allows you to maintain several Perl versions on the same machine and to keep sets of Perl modules specific to each Perl version.

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

	cpanm --installdeps ~/webUI/proportal/

Some modules may fail installation and need to be installed manually or using the `--force` flag (e.g. an issue with `Scalar::Does` meant it needed to be installed using `cpanm --force Scalar::Does`). Rerunning the command `cpanm --installdeps ~/webUI/proportal/` will redo the installation of any modules that were not installed previously.

Install BioPerl (more detailed instructions at http://bioperl.org/INSTALL.html if required):

	cpanm CJFIELDS/BioPerl-1.6.924.tar.gz

If you have access to the IMG Oracle databases from your machine and want to run the code on those databases, you will need to install `DBD::Oracle`. This module may need to be installed by hand; see http://metacpan.org/pod/DBD::Oracle for downloads and installation instructions.

### Database set up

The ProPortal can run off a local database or using the IMG Oracle databases.

### Using a local database

Download the SQLite demo database:

https://www.dropbox.com/s/hm3xne8hc3d3vq7/dbschema-img_core.db?dl=0

* Edit the file `proportal/environments/db.pl` to set the appropriate location for the SQLite database in place of `/global/homes/a/aireland/webUI/proportal/share/dbschema-img_core.db`.

### Genepool server set up

* The majority of config parameters are set in `proportal/environments/development.pl`. The parameters that may need to be changed are the database login details and the URLs for the application. To get the current database login details, run the following from the proportal directory:

    `perl script/write_db_config_files.pl`

This will parse the database config files and dump the relevant DB details as JSON files in the `environments` directory.

The database config details (username, password) should be copied into db.pl

TODO: change this to slurp in files named after the DB.

### Apache and dnsmasq ###

The GitHub repository includes a sample Apache configuration file (see `proportal/apache/sample_server.conf`) for setting up a test server on your computer with the domain name http://img-proportal.dev. The config file requires Apache 2.4; to check the version of your Apache, run

	apachectl -v

on the command line.

If you are running the code on a Mac, you will need dnsmasq to be able to give localhost servers (i.e. servers on your computer) a domain name. dnsmasq is easily installed using the Mac package manager Homebrew (http://brew.sh). Follow the instructions at https://mallinson.ca/osx-web-development/ for installing and configuration of dnsmasq (scroll down to the dnsmasq section; the rest of the page is not relevant).

You will need to have `mod_rewrite`, `mod_proxy`, and `mod_expires` enabled in your Apache config file (usually `/private/etc/apache2/httpd.conf`); find the lines

	LoadModule proxy_module libexec/apache2/mod_proxy.so
	LoadModule proxy_http_module libexec/apache2/mod_proxy_http.so

	LoadModule expires_module libexec/apache2/mod_expires.so

	LoadModule rewrite_module libexec/apache2/mod_rewrite.so

and make sure that they are uncommented.

On MacOS X, you can drop `sample_server.conf` (in `proportal/apache/` in the git repository) into `/private/etc/apache2/other/` and make sure that the line

	Include /private/etc/apache2/other/

is uncommented in your Apache config file (usually `/private/etc/apache2/httpd.conf`).

Check that the new configuration works by running

	sudo apachectl configtest

Restart the server to activate the new server configuration using the command

	sudo apachectl -k restart

The configuration included sets up a ProPortal server at `http://img-proportal.dev`. Check it is working by visiting this URL:

	http://img-proportal.dev/404.html

You should get a ProPortal-themed 404 page.

## Launching the server

`cd` to the distribution directory `proportal` and run the launch script using `plackup bin/app.psgi`. You'll see a message like `HTTP::Server::PSGI: Accepting connections at http://0:5000/`. Visit `http://localhost:5000` in your browser to view the site.

If you have set up Apache as previously suggested, you should be able to go to http://img-proportal.dev to view the ProPortal pages.

See the `plackup` documentation on options for running different Plack/PSGI servers. Starman is a good option for standard use. Sample launch instructions:

`plackup -E development -s Starman --workers=10 bin/app.psgi`

By default, Plack reads `app.psgi` once and keeps the application in memory. To allow live development, you can use the Shotgun loader, which will reload the application if any of the source files have changed. To do this, launch the app with the following command:

`plackup -L Shotgun  -E development -s Starman --workers=10 bin/app.psgi`

The `-L Shotgun` parameter is the reloader.

To prevent the reloading of all the perl modules, you can use the standard `-M` switch:

`plackup -MMoo -MDancer2 -MDBIx::DataModel -MPlack -L Shotgun -E development -s Starman --workers=10 bin/app.psgi`

This will preload `Moo`, `Dancer2`, `DBIx::DataModel`, and `Plack` and reload any other modules, including those in the `proportal/lib` and `webui.cgi` directories.





## Set up to include the cgi-based installation (Genepool server only) ##

### IN PROGRESS! ###

* WebConfig.pm and WebConfigCommon.pm need to be edited to provide the correct parameters. Anything that previously pointed to the Apache cgi-bin directory needs to point at $base/webUI/webui.cgi, and the htdocs directory should now be $base/webUI/webui.htd. If there are two .htd directories for an installation (e.g. for proportal), the files should be combined into a single directory.

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


### Other software ###

Install JBrowse:

download JBrowse from http://jbrowse.org






ProPortal uses bower to manage web-related dependencies -- javascript and CSS libraries, etc. Bower can be installed


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

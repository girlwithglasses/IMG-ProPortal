#!/usr/bin/env perl

my @dir_arr;
my $dir;

BEGIN {
	use File::Spec::Functions qw( rel2abs catdir catfile );
	use File::Basename qw( dirname basename );
	$dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } ( 'install/proportal-local', 'install' );
}

use lib @dir_arr;
use strict;
use warnings;
use feature ':5.16';
use Data::Dumper;
use WebConfig qw();
use Config::Any;

my $conf = WebConfig::getEnv();

$conf->{sso_url_prefix} = 'https://signon.';
$conf->{sso_domain} = 'jgi.doe.gov';

# valid levels: production, development, testing
my @pieces = qw( debug db_test schema_test );
#
# {
# 	schema => 'schemafile.pl',
# 	level  => 'development'
# }

my @files = map { catfile( $dir, 'proportal/environments', $_  ) } @pieces;

my $cfg = Config::Any->load_stems({
	stems => [ @files ],
	use_ext => 1,
#	flatten_to_hash => 1,
});

my $hash = {};
for ( @$cfg ) {
	my $vals = ( values %$_ )[0];
	$hash = { %$hash, %$vals };
}

return { %$conf, %$hash };



{
# configuration file for development environment

# the logger engine to use
# console: log messages to STDOUT (your console where you started the
#          application server)
# file:    log message to a file in log/
	logger => "console",

# the log level for this environment
# core is the lowest, it shows Dancer2's core log messages as well as yours
# (debug, info, warning and error)
	log => "debug",

# should Dancer2 consider warnings as critical errors?
	warnings => 1,

	traces => 1,

# should Dancer2 show a stacktrace when an error is caught?
# if set to yes, public/500.html will be ignored and either
# views/500.tt, 'error_template' template, or a default error template will be used.
	show_errors => 1,

#	debug => 1,

	# print the banner
	startup_info => 1,

	# URL of the ProPortal app
#	pp_app => "http://localhost:5000/",
	pp_app => 'http://img-proportal.dev/',
	base_url => 'http://img-proportal.dev',

	# home of css, js, images folders. Should end with "/"
	pp_assets => 'http://img-proportal.dev/',

	# main.cgi location
#	main_cgi_url => 'http://localhost:5000/cgi-bin/main.cgi',
	main_cgi_url => 'http://img-proportal.dev/cgi-bin/main.cgi',

	assets => 'http://img-proportal.dev/pristine_assets/',

#	jbrowse_assets => 'http://localhost:5000/jbrowse_assets/',
	jbrowse_assets => 'http://img-proportal.dev/jbrowse_assets/',

#	scratch_dir => '/tmp/jbrowse',
#	web_data_dir => '/Users/gwg/webUI/proportal/t/files/img_web_data',

	session => 'CGISession',

	engines => {
#		logger => {
#			File => {
#				log_dir => "log/",
#				file_name => "proportal.log",
#			},
#		},
		session => {
			CGISession => {
#				name => 'CGISESSID_proportal',
				cookie_name => 'CGISESSID_proportal',
				cookie_duration => '1.5 hours',
#				cookie_domain => 'jgi-psf.org',
				driver_params => {
					Directory => '/tmp',
				},
			},
		},
	},

	schema => {
		img_core => { module => 'DataModel::IMG_Core', db => 'imgsqlite' },
		img_gold => { module => 'DataModel::IMG_Gold', db => 'imgsqlite' },
		missing  => { module => 'I::Made::This::Up', db => 'test' },
		absent   => { module => 'DataModel::IMG_Test', db => 'absent' },
	},

	dbi_module => 'datamodel',

	db => {
		# schema and db connection required
		imgsqlite => {
			driver => 'SQLite',
			database => 'share/dbschema-img_core.db',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
			},
	#		log_queries => 1,
		},
		test => {
			driver => 'SQLite',
			database => 't/files/test.db',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
			},
	#		log_queries => 1,
		},
		img_gold => { # this is GOLD
			driver => 'Oracle',
#			database => 'imgiprd',
			database => '//gpodb08.nersc:1521/imgiprd',
			user => 'imgsg_dev',
			password => 'Tuesday',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
				ora_drcp => 1,
			},
		},
		img_core_gem1 => {
			driver => 'Oracle',
			database => '//gpodb11.nersc.gov:1521/gemini1',
#			database => 'gemini1_shared',
			username => 'img_core_v400',
			password => 'imgCoreC0sM0s1',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
				ora_drcp => 1,
			},
		},
		img_core_gem2 => {
			driver => 'Oracle',
			database => '//gpodb11.nersc.gov:1521/gemini2',
#			database => 'gemini1_shared',
			username => 'img_core_v400',
			password => 'imgCoreC0sM0s1',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
				ora_drcp => 1,
			},
		},
	},
}




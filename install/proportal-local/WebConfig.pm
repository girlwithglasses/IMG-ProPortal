package WebConfig;
#
# $Id: WebConfig.pm 36613 2017-03-01 19:25:44Z aireland $
#
#	Configuration for testing ProPortal pieces or whole

our ( @ISA, @EXPORT_OK );

BEGIN {
	require Exporter;
	@ISA = qw( Exporter );
	@EXPORT = qw( getEnv );
	@EXPORT_OK = qw( getEnv );
}

use strict;
use warnings;
use feature ':5.16';
use Data::Dumper;
use File::Spec::Functions;
use File::Basename;

# get the @inc
my @pp_dirs = grep { m!proportal.*?lib! } @INC;
my $pp_dir = dirname $pp_dirs[0];
my $webui_dir = dirname $pp_dir;

#say 'pp_dirs: ' . join ", ", @pp_dirs;
#say 'pp_dir: ' . $pp_dir;
#say 'web ui dir: ' . $webui_dir;

my $conf = {

	verbose => 3,
	domain_name => 'img-proportal.dev',
	base_url => 'http://img-proportal.dev',

	jbrowse => 'http://img-jbrowse.dev',
	galaxy => 'http://img-galaxy.dev',
	galaxy_local => 'https://localhost:5011',

	pp_app => "http://img-proportal.dev/",
	# home of css, js, images folders. Should end with "/"
	pp_assets => "http://img-proportal.dev/",

	# main.cgi location
	main_cgi_url => 'http://img-proportal.dev/cgi-bin/main.cgi',

	cgi_tmp_dir => '/tmp/cgi_tmp_dir',
	base_dir => catdir( $webui_dir, 'webui.htd' ),

	webUI_dir => $webui_dir,
	scratch_dir => '/tmp/jbrowse',
	web_data_dir => catdir( $pp_dir, 't/files/img_web_data' ),

	message => 'IMG ProPortal local development site'

};

sub getEnv {
	return $conf;
}

1;

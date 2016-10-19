package WebConfig;
#
# $Id: WebConfig.pm 36314 2016-10-13 06:00:20Z aireland $
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

say 'pp_dirs: ' . join ", ", @pp_dirs;

my $pp_dir = dirname $pp_dirs[0];

say 'pp_dir: ' . $pp_dir;


my $webui_dir = dirname $pp_dir;
say 'web ui dir: ' . $webui_dir;

my $conf = {

	domain_name => 'img-proportal.dev',
	base_url => 'https://img-proportal.dev',

	jbrowse => 'https://img-jbrowse.dev',
	galaxy => 'https://img-galaxy.dev',

	pp_app => "https://img-proportal.dev/",
	# home of css, js, images folders. Should end with "/"
	pp_assets => "https://img-proportal.dev/",

	# main.cgi location
	main_cgi_url => 'https://img-proportal.dev/cgi-bin/main.cgi',

	webUI_dir => $webui_dir,
	scratch_dir => '/tmp/jbrowse',
	web_data_dir => catdir( $pp_dir, 't/files/img_web_data' ),

};

sub getEnv {
	return $conf;
}

1;

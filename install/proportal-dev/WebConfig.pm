package WebConfig;
#
# $Id: WebConfig.pm 36468 2016-12-04 22:37:40Z aireland $
#
#	Configuration for the ProPortal dev server

our ( @ISA, @EXPORT_OK );

BEGIN {
	require Exporter;
	@ISA = qw( Exporter );
	@EXPORT = qw( getEnv );
	@EXPORT_OK = qw( getEnv );
}

use strict;
use warnings;
use WebConfig_img_proportal;

my $conf = WebConfig_img_proportal::make_config({
	domain_name => 'img-proportal-dev.jgi.doe.gov',
	jbrowse => 'https://img-proportal-dev.jgi.doe.gov/jbrowse',
	galaxy => 'https://img-galaxy-test.jgi.doe.gov',
	in_place => 1,
	webUI_dir => '/global/homes/w/wwwimg/svn/webUI',
	scratch_dir => '/global/projectb/scratch/aireland',
	message => 'IMG ProPortal Development Site',
});

#$conf->{sso_url_prefix} = 'https://signon.';
#$conf->{sso_domain} = 'jgi.doe.gov';
$conf->{sso_enabled} = 0;

sub getEnv {
	return $conf;
}

1;

package WebConfig;
#
# $Id: WebConfig.pm 36420 2016-11-15 23:53:54Z aireland $
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
	jbrowse => 'https://img-jbrowse-test.jgi.doe.gov',
	galaxy => 'https://img-galaxy-test.jgi.doe.gov',
	in_place => 1,
	webUI_dir => '/global/homes/w/wwwimg/svn/webUI',
	scratch_dir => '/tmp',
	message => 'IMG ProPortal Development Site',
});

#$conf->{sso_url_prefix} = 'https://signon.';
#$conf->{sso_domain} = 'jgi.doe.gov';
$conf->{sso_enabled} = 0;

sub getEnv {
	return $conf;
}

1;

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
use WebConfigCommon;
use WebConfig_img_proportal;

my $conf = WebConfig_img_proportal::make_config({
	domain_name => 'img-proportal.dev',
	jbrowse => 'https://img-jbrowse.dev',
	galaxy => 'https://img-galaxy.dev',
	in_place => 1,
	webUI_dir => '/global/homes/a/aireland/webUI',
	scratch_dir => '/tmp/jbrowse',
	web_data_dir => '/Users/gwg/webUI/proportal/t/files/img_web_data',
});

#$conf->{sso_url_prefix} = 'https://signon.';
#$conf->{sso_domain} = 'jgi.doe.gov';
delete $conf->{sso_enabled} if $conf->{sso_enabled};

sub getEnv {
	return $conf;
}

1;

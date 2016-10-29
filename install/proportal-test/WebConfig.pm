package WebConfig;
#
# $Id: WebConfig.pm 36384 2016-10-26 21:09:57Z aireland $
#
#	Configuration for the ProPortal test server

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
	domain_name => 'img-proportal-test.jgi.doe.gov',
	jbrowse => 'https://img-jbrowse-test.jgi.doe.gov',
	galaxy => 'https://img-galaxy-test.jgi.doe.gov',
	in_place => 1,
	webUI_dir => '/global/homes/w/wwwimg/svn/webUI',
	scratch_dir => '/tmp',
	message => 'This is the IMG ProPortal test site. Please visit the <a href="https://img-proportal-dev.jgi.doe.gov/">IMG ProPortal Beta</a> to access the new IMG ProPortal features.',
	message_html => '<p class="site-message__p">
	This is the IMG ProPortal test site. Please visit the <a href="https://img-proportal-dev.jgi.doe.gov/">IMG ProPortal Beta</a> to access the new IMG ProPortal features.</p>'
});

#$conf->{sso_url_prefix} = 'https://signon.';
#$conf->{sso_domain} = 'jgi.doe.gov';
delete $conf->{sso_enabled};

sub getEnv {
	return $conf;
}

1;

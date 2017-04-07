#!/usr/bin/env perl
my @dir_arr;
my $dir;

BEGIN {
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	$dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw(
		webui.cgi
		proportal/lib
		jbrowse/src/perl5
		jbrowse/extlib/lib/perl5
	);
	my $home = dirname( $dir );
	unshift @dir_arr,  catdir( $home, 'ken-branch/webui.cgi' );
}
use lib @dir_arr;
use IMG::Util::Import 'psgi';

#use JBlibs;
#use CGI::Compile;
#use CGI::Emulate::PSGI;
#use Log::Contextual qw( :log );
#use Config::Any;

{	package ProPortalApp;
	use IMG::Util::Import;
	use Dancer2 appname => 'ProPortal';
	our $VERSION = '0.1.0';

	use AppCore;
	use AppCorePlugin;

	use Routes::Ajax;
	use Routes::MenuPages;
	# use Routes::JBrowse;
	use Routes::IMG;
#	use Routes::API;
	use Routes::ProPortal;
	# use Routes::TestStuff;

	1;
}

my $home = basename( $dir );

# $ENV{PLACK_URLMAP_DEBUG} = 1;

# CGI server
# use Plack::App::CGIBin;

# my $old_img = sub {
# 	Plack::App::CGIBin->new(root => catdir( $home, "pristine/webUI/webui.cgi" ) )->to_app;
# };

builder {
	enable 'Deflater';

	mount '/' => ProPortalApp->to_app;

};

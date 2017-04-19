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

	@dir_arr = map { catdir( $dir, $_ ) } qw(
		proportal/lib
		webui.cgi
		jbrowse/src/perl5
		jbrowse/extlib/lib/perl5
	);

	my $home = dirname( $dir );
	unshift @dir_arr,  catdir( $home, 'ken-branch/webui.cgi' );

}

use lib @dir_arr;
use IMG::Util::Logger;
use IMG::Util::Import 'psgi';
use File::Spec::Functions qw( catfile );

#use Carp::Always;

#use Log::Contextual qw(:log);
# $ENV{PLACK_URLMAP_DEBUG} = 1;
# $ENV{TWIGGY_DEBUG} = 1;

#=comment

# Mojolicious pod renderer
#use Mojo::Server::PSGI;

#my $server = Mojo::Server::PSGI->new;
#$server->load_app( catdir( $dir, 'proportal/bin/podserver' ) );

#=cut

{	package ProPortalApp;
	use IMG::Util::Import;
	use Dancer2 appname => 'ProPortal';
	our $VERSION = '0.1.0';

	use AppCore;
	use AppCorePlugin;
# 	use Routes::Ajax;
# 	use Routes::IMG;
#	use Routes::JBrowse;
#	use Routes::API;
	use Routes::MenuPages;
	use Routes::ProPortal;
#	use Routes::TestStuff;

#	say 'Config: ' . Dumper config;

	1;
}

use TestApp;

builder {
	enable "Deflater";
#	enable "Static", path => qr#^/(images|css|js)#, root => $base . "/public";
	enable_if { config->{debug} } "Debug";

#	mount "/cgi-bin" => $old_img->();

#	mount "/pod" => sub { $server->run(@_) };

#     mount "/testapp" => TestApp->to_app;
	mount "/" => ProPortalApp->to_app;

};

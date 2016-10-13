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
}
use lib @dir_arr;
use IMG::Util::Base;
use IMG::Util::File qw( :all );

use Plack::Builder;
#use Log::Contextual qw(:log);
$ENV{PLACK_URLMAP_DEBUG} = 1;
$ENV{TWIGGY_DEBUG} = 1;

# Mojolicious pod renderer
use Mojo::Server::PSGI;

my $server = Mojo::Server::PSGI->new;
$server->load_app( catdir( $dir, 'proportal/bin/podserver' ) );

say 'running app.psgi!';
sub make_config {

	my $env_dir = catdir( $dir, 'proportal/environments' );
	my @files = map { "$env_dir/$_" } get_dir_contents({
		dir => $env_dir,
		filter => sub { -f "$env_dir/$_" }
	});
	push @files, catfile( $dir, 'proportal/config.pl' );

	my $cfg = Config::Any->load_files({
		files => [ @files ],
		use_ext => 1,
		flatten_to_hash => 1
	});

	my @keys = keys %$cfg;
	for ( @keys ) {
		if ( m!.+/(\w+)\.\w+$!x ) {
			$cfg->{ $1 } = delete $cfg->{ $_ };
		}
	}

	say 'config: ' . Dumper $cfg;

	return $cfg;

}

use ProPortalPackage;
use TestApp;

builder {
	enable "Deflater";
#	enable "Static", path => qr#^/(images|css|js)#, root => $base . "/public";
	enable "Debug";

#	mount "/cgi-bin" => $old_img->();
#	enable "Log::Contextual";
#	enable "Session", store => "File";
	mount "/pod" => sub { $server->run(@_) };

	enable 'Static',
		path => sub { s!^/jbrowse_assets!! },
		root => $dir . '/jbrowse';

	enable 'Static',
		path => sub { s!^/data_dir!! },
		root => '/tmp/jbrowse';

    mount "/testapp" => TestApp->to_app;
	mount "/" => ProPortalPackage->to_app;

};

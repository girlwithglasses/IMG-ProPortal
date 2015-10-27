#!/usr/bin/env perl

BEGIN {
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	my $dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	our @dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib );
}
use lib @dir_arr;

use IMG::Util::Base;
use FindBin qw/ $Bin /;
my $base = dirname($Bin);
my $home = $base;
$home =~ s!webUI/.*!webUI!;
use Plack::Builder;
#use Log::Contextual qw(:log);
$ENV{PLACK_URLMAP_DEBUG} = 1;
$ENV{TWIGGY_DEBUG} = 1;

# Mojolicious pod renderer
use Mojo::Server::PSGI;

my $server = Mojo::Server::PSGI->new;
$server->load_app( "$base/bin/podserver" );

use ProPortalPackage;

my $pp = sub {
  ProPortalPackage->to_app;
};

use TestApp;
my $testapp = sub {
    TestApp->to_app;
};


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
		root => $home . '/jbrowse';

	enable 'Static',
		path => sub { s!^/data_dir!! },
		root => '/tmp/jbrowse';

#    mount "/" => $testapp->();
	mount "/" => $pp->();

};

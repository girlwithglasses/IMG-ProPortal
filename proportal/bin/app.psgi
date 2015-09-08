#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib (
	"$Bin/../lib",
	"$Bin/../../webui.cgi"
);
use local::lib;
use IMG::Util::Base;
use File::Basename;
#$Carp::Verbose = 1;

#use Plack::Middleware::Session;
#use Plack::Middleware::Conditional;

my $base = dirname($Bin);
say "base: $base";

my $sessions_enabled = 0;

use Plack::Builder;
#use Log::Contextual qw(:log);
$ENV{PLACK_URLMAP_DEBUG} = 1;

#use Plack::App::CGIBin;
#my $old_img = sub {
#	Plack::App::CGIBin->new(root => "$Bin/../../webui.cgi")->to_app;
#};

# Mojolicious pod renderer
use Mojo::Server::PSGI;

my $server = Mojo::Server::PSGI->new;
$server->load_app( "$base/bin/podserver" );

use AltProPortal;

my $pp = sub {
  AltProPortal->to_app;
};

builder {
	enable "Deflater";
#	enable "Static", path => qr#^/(images|css|js)#, root => $base . "/public";
	enable "Debug";

=cut
	enable_if { $sessions_enabled } "Session",
		state => Plack::Session::State::Cookie->new(
			session_key => 'img_proportal',
			domain => 'img.jgi.doe.gov',
		),
		store => Plack::Session::Store::File->new(
			dir => "$base/tmp",
			serializer => sub { ... },
			deserializer => sub { ... },
		);
=cut
#	mount "/cgi-bin" => $old_img->();
#	enable "Log::Contextual";
#	enable "Session", store => "File";
	mount "/pod" => sub { $server->run(@_) };

	mount "/" => $pp->();

};

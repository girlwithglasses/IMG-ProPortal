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

use ProPortalPackage;

my $pp = sub {
  ProPortalPackage->to_app;
};

use TestApp;

my $test = sub {
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

	mount "/" => $pp->();
	mount '/test' => $test->();

};

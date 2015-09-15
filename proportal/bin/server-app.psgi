#!/usr/bin/env perl

use strict;
use warnings;
use feature ':5.16';
use Data::Dumper;
use local::lib;

use FindBin qw/ $Bin /;
use lib ( "$Bin/../../webui.cgi", "$Bin/../lib" );
use CGI::Compile;
use CGI::Emulate::PSGI;
use File::Basename;
use ProPortalPackage;
use Plack::Builder;
use Log::Contextual qw(:log);
my $base = dirname($Bin);

$ENV{PLACK_URLMAP_DEBUG} = 1;

my $pp = sub {
	ProPortalPackage->to_app;
};

# CGI server
use Plack::App::CGIBin;

my %apps = (
	'main' => undef,
	'json_proxy' => undef,
	'xml' => undef );

#for my $a ( keys %apps ) {
#	my $sub = CGI::Compile->compile("/global/u1/a/aireland/pristine/webUI/webui.cgi/$a.pl");
#	$apps{ $a } = CGI::Emulate::PSGI->handler($sub);
#}

my $old_img = sub {
	Plack::App::CGIBin->new(root => "/global/u1/a/aireland/pristine/webUI/webui.cgi")->to_app;
};

# static file server
use Plack::App::Cascade;
use Plack::App::File;
my $casc = Plack::App::Cascade->new;
my @paths = (
	"/global/u1/a/aireland/pristine/webUI/webui.htd-proportal",
	"/global/u1/a/aireland/pristine/webUI/webui.htd",
	"/webfs/projectdirs/microbial/img/public-web/vhosts/img-stage.jgi-psf.org/htdocs/",
);
for (@paths) {
	$casc->add( Plack::App::File->new( root => $_ )->to_app );
}
my $s_app = $casc->to_app;

my $assets = Plack::App::File->new( root => '/global/u1/a/aireland/pristine/webUI/webui.htd' )->to_app();

builder {
	enable "Deflater";
#	enable "Static", path => qr#^/(images|css|js)
#	.*?
#	(\.(css|jpg|jpeg|png|gif|js))#x, root => $base . "/public";
#	enable "Static", path => qr#^/nyt#x, root => $base . "/public";
	enable 'Debug';
# 	enable_if { $_[0]->{REQUEST_URI} !~ m#/nyt/nytprofhtml# } 'Debug', panels => [
# 		'Timer',
# 		'Memory',
# 		'DBITrace',
# 		'Environment',
# 		'Response',
# 		[
# 			'Profiler::NYTProf',
# 			base_URL => 'https://img-proportal-dev.jgi-psf.org/nyt',
# 			root     => "$base/public/nyt",
# 			exclude  => [qw( .*\.css .*\.png .*\.ico .*\.js .*\.jpg .*\.gif )],
# 		]
# 	];
	mount "/" => $pp->();
	enable 'Static',
		path => sub { s!^/pristine_assets!! },
		root => '/global/u1/a/aireland/pristine/webUI/webui.htd';
	enable "Static",
		path => qr#^/yui282#x,
		root => "/webfs/projectdirs/microbial/img/public-web/vhosts/img-stage.jgi-psf.org/htdocs/";
	enable 'Static', path => qr[/pristine_assets], root => '/global/u1/a/aireland/pristine/webUI/webui.htd';
	mount '/pristine' => $old_img->();
};

#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";
use IMG::Util::Base;
use File::Basename;
my $base = dirname($Bin);

use local::lib;

$ENV{PLACK_URLMAP_DEBUG} = 1;

use Plack::Builder;
use Log::Contextual qw(:log);

use ProPortal;
my $pp = sub {
	ProPortal->to_app;
};

# CGI server
# use Plack::App::CGIBin;
#
# my $old_img = sub {
#
# 	Plack::App::CGIBin->new(root => "$Bin/../../webui.cgi")->to_app;
#
# };

# static file server
use Plack::App::Cascade;
my $static = Plack::App::Cascade->new;
my @paths = (
	"$Bin/../../webui.htd-proportal",
	"$Bin/../../webui.htd",
	"/webfs/projectdirs/microbial/img/public-web/vhosts/img-stage.jgi-psf.org/htdocs/",
);
for (@paths) {
	$static->add( Plack::App::File->new( root => $_ )->to_app );
}
my $s_app = $static->to_app;

builder {
	enable "Deflater";
	enable "Static", path => qr#^/(images|css|js)
	.*?
	(\.(css|jpg|jpeg|png|gif|js))#x, root => $base . "/public";
	enable "Static", path => qr#^/nyt#x, root => $base . "/public";
	enable 'Debug';
	enable_if { $_[0]->{REQUEST_URI} !~ m#/nyt/nytprofhtml# } 'Debug', panels => [
		'Timer',
		'Memory',
		'DBITrace',
		'Environment',
		'Response',
		[
			'Profiler::NYTProf',
			base_URL => 'https://img-proportal-dev.jgi-psf.org/nyt',
			root     => "$base/public/nyt",
			exclude  => [qw( .*\.css .*\.png .*\.ico .*\.js .*\.jpg .*\.gif )],
		]
	];
	mount "/proportal" => $pp->();
#	mount "/cgi-bin" => $old_img->();
	mount "/" => $s_app;
	mount "/" => $pp->();
};

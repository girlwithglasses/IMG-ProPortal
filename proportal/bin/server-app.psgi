#!/usr/bin/env perl

use strict;
use warnings;
use feature ':5.16';
use Data::Dumper::Concise;
use local::lib;

use FindBin qw/ $Bin /;
use lib ( "$Bin/../../webui.cgi", "$Bin/../lib", "$Bin/../../../WebAPI-DBIC/lib", "$Bin/../../jbrowse/src/perl5", "$Bin/../../jbrowse/extlib/lib/perl5");
use CGI::Compile;
use CGI::Emulate::PSGI;
use File::Basename;
use ProPortalPackage;
use Plack::Builder;
use Log::Contextual qw(:log);
use Config::Any;
my $base = dirname($Bin);

my $home = '/global/u1/a/aireland/';

sub make_config {

	my $env_dir = $base . '/environments';
	opendir(my $dh, $env_dir) || die "can't opendir $env_dir: $!";
	my @files = map { "$env_dir/$_" } grep { /^[^\.]/ && -f "$env_dir/$_" } readdir($dh);
	closedir $dh;
	push @files, $base . '/config.pl';


	my $cfg = Config::Any->load_files({ files => [ @files ], use_ext => 1, flatten_to_hash => 1 });
	my @keys = keys %$cfg;
	for ( @keys ) {
		if ( m!.+/(\w+)\.\w+$!x ) {
			$cfg->{ $1 } = delete $cfg->{ $_ };
		}
	}

	say 'config: ' . Dumper $cfg;



	return $cfg;

}

# $ENV{PLACK_URLMAP_DEBUG} = 1;

my $pp = sub {
	ProPortalPackage->to_app;
};

# CGI server
use Plack::App::CGIBin;

my $old_img = sub {
	Plack::App::CGIBin->new(root => $home . "pristine/webUI/webui.cgi")->to_app;
};

my $schema_h = {
	img_gold => 'DBIC::IMG_Gold',
	img_core => 'DBIC::IMG_Core',
};

=comment HAL+JSON WebAPI

use WebAPI::DBIC::WebApp;
use Alien::Web::HalBrowser;

my $apps;
for my $db ( qw( img_gold img_core ) ) {
	next unless defined $cfg->{$db};

	my $hal_app = Plack::App::File->new(
	  root => Alien::Web::HalBrowser->dir
	)->to_app;

	my $schema_class = $schema_h->{$db};
	eval "require $schema_class" or die "Error loading $schema_class: $@";

	my $schema = $schema_class->connect(
		$cfg->{$db}{dsn} || 'dbi:Oracle:' . $cfg->{$db}{database},
		$cfg->{$db}{username} || $cfg->{$db}{user},
		$cfg->{$db}{password}
	); # uses DBI_DSN, DBI_USER, DBI_PASS env vars

	my $app = WebAPI::DBIC::WebApp->new({
		routes => [ map( $schema->source($_), $schema->sources) ]
	})->to_psgi_app;

	$apps->{$db} = { main => $app, hal => $hal_app };;

}

=cut

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
	enable 'Static',
		path => sub { s!^/pristine_assets!! },
		root => $home . 'pristine/webUI/webui.htd';

	enable 'Static',
		path => sub { s!^/jbrowse_assets!! },
		root => $home . 'webUI/jbrowse';

	# jbrowse data directory
#	scratch_dir => '/global/homes/a/aireland/tmp/jbrowse/',

	enable 'Static',
		path => sub { s!^/data_dir!! },
		root => $home . 'tmp/jbrowse';

	enable "Static",
		path => qr#^/yui282#x,
		root => "/webfs/projectdirs/microbial/img/public-web/vhosts/img-stage.jgi-psf.org/htdocs/";

	mount "/" => $pp->();

	mount '/pristine' => $old_img->();

# 	mount "/img_core" => builder {
# 		mount "/browser" => $apps->{img_core}{hal};
# 		mount "/" => $apps->{img_core}{main};
# 	};
#      mount "/img_gold" => builder {
#          mount "/browser" => $apps->{img_gold}{hal};
#          mount "/" => $apps->{img_gold}{main};
#      };
};

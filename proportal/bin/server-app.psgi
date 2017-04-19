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
use IMG::Util::Import;
use IMG::Util::File qw( :all );

use JBlibs;
use CGI::Compile;
use CGI::Emulate::PSGI;
use File::Basename;
use ProPortalPackage;
use Plack::Builder;
use Plack::Middleware::Conditional;
use Log::Contextual qw( :log );
use Config::Any;
use Dancer2;

my $home = basename( $dir );

# $ENV{PLACK_URLMAP_DEBUG} = 1;

# my $pp = sub {
# 	ProPortalPackage->to_app;
# };

# CGI server
use Plack::App::CGIBin;

# my $old_img = sub {
# 	Plack::App::CGIBin->new(root => catdir( $home, "pristine/webUI/webui.cgi" ) )->to_app;
# };

# =comment HAL+JSON WebAPI

use WebAPI::DBIC::WebApp;
use Alien::Web::HalBrowser;

my $schema_h = {
	img_gold => 'DBIC::IMG_Gold',
	img_core => 'DBIC::IMG_Core',
};

my $cfg = config;

#say Dumper $cfg;
my $apps;
for my $db ( keys %{$cfg->{schema}} ) {
	next unless defined $cfg->{db}{ $cfg->{schema}{$db}{db} };

	my $hal_app = Plack::App::File->new(
	  root => Alien::Web::HalBrowser->dir
	)->to_app;

	my $schema_class = $schema_h->{$db};
	eval "require $schema_class" or die "Error loading $schema_class: $@";

	my $schema = $schema_class->connect(
		$cfg->{db}{ $cfg->{schema}{$db}{db} }{dsn} || 'dbi:Oracle:' . $cfg->{db}{ $cfg->{schema}{$db}{db} }{database},
		$cfg->{db}{ $cfg->{schema}{$db}{db} }{username} || $cfg->{db}{ $cfg->{schema}{$db}{db} }{user},
		$cfg->{db}{ $cfg->{schema}{$db}{db} }{password}
	); # uses DBI_DSN, DBI_USER, DBI_PASS env vars

	my $app = WebAPI::DBIC::WebApp->new({
		routes => [ map( $schema->source($_), $schema->sources) ]
	})->to_psgi_app;

	$apps->{$db} = { main => $app, hal => $hal_app };;

}



builder {
	enable 'Deflater';
	enable_if { config->{debug} } "Debug";

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
		root => catdir( $home, 'pristine/webUI/webui.htd' );

	enable 'Static',
		path => sub { s!^/jbrowse_assets!! },
		root => catdir( $home, 'webUI/jbrowse' );

	# jbrowse data directory
#	scratch_dir => '/global/homes/a/aireland/tmp/jbrowse/',

	enable 'Static',
		path => sub { s!^/data_dir!! },
		root => catdir( $home, 'tmp/jbrowse' );

	enable 'Static',
		path => qr#^/yui282#x,
		root => '/webfs/projectdirs/microbial/img/public-web/vhosts/img-stage.jgi-psf.org/htdocs/';

	mount "/img_core" => builder {
		mount "/browser" => $apps->{img_core}{hal};
		mount "/" => $apps->{img_core}{main};
	};
	mount "/img_gold" => builder {
		mount "/browser" => $apps->{img_gold}{hal};
		mount "/" => $apps->{img_gold}{main};
	};

	mount '/' => ProPortalPackage->to_app;

	mount '/pristine' => Plack::App::CGIBin->new(root => catdir( $home, "pristine/webUI/webui.cgi" ) )->to_app;

};

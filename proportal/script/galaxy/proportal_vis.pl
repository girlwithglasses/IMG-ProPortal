#!/usr/bin/env perl

my @dir_arr;
BEGIN {
#	$ENV{'DANCER_ENVIRONMENT'} = 'galaxy';
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	my $dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib );
}

use lib @dir_arr;

{
	package ScriptAppArgs;
	use IMG::Util::Import 'Class';
	use IMG::Util::File;
	with 'IMG::App::Role::ErrorMessages';
	use Routes::ProPortal;

	has 'query' => (
		is => 'ro',
		isa => sub {
			my $q = shift;
			my $comp = Routes::ProPortal::active_components->{filtered};
			if ( ! grep { $q eq $_ } @$comp ) {
				die 'invalid query ' . $q . '; ' . join ", ", @$comp;
			}
		}
	);

	has 'pp_subset' => (
		is => 'ro',
	);

	has 'outfile' => (
		is => 'ro',
		required => 1,
		coerce => sub {
			open my $fh, ">", $_[0] or die err({
				err => 'not_writable',
				subject => $_[0],
				msg => $!
			});
			return $fh;
		}
	);

	has 'test' => (
		is => 'ro',
		isa => Bool
	);

	1;
}

{
	package ProPortal::App::ProPortalRoutes;
	use IMG::Util::Import 'Class';
	use ScriptAppArgs;
	use AppCore;
	use Dancer2;
	extends 'IMG::App';
	with qw(
		ProPortal::IO::DBIxDataModel
		ProPortal::IO::ProPortalFilters
		IMG::Util::ScriptApp
		IMG::App::Role::Templater
	);

	sub run {
		my $self = shift;

		$self->add_controller_role( $self->args->query );
		$self->set_filters( pp_subset => $self->args->pp_subset );

		my $rslts = $self->render;
		$rslts = AppCore::get_tmpl_vars({ core => $self, output => $rslts });

		print { $self->args->outfile } $self->render_template({
			tmpl_args => {
				%{ $self->config->{engines}{template}{template_toolkit} },
				INCLUDE_PATH => $self->config->{views}
			},
			tmpl_data => { %$rslts,
				settings => $self->config,
				page_wrapper => 'layouts/contents_only.tt',
				mode => 'galaxy'
			},
			tmpl => $self->controller->tmpl
		});

	}

	1;
}


use IMG::Util::Import;
use Dancer2;
use IMG::App::Role::ErrorMessages qw( script_die );
use Getopt::Long;

my $args = {};
GetOptions(
	$args,
	"pp_subset|s=s",
	"query|q=s",
	"outfile|o=s",
	"test|t"         # flag for test mode
) or script_die( 255, [ "Error in command line arguments" ] );

my $cfg = config;
$cfg->{pp_assets} = 'https://img-galaxy-test.jgi.doe.gov/';

eval {

	ProPortal::App::ProPortalRoutes->new( dancer_config => $cfg, args => $args )->run();

};

script_die( 255, [ $@ ] ) if $@;

exit(0);


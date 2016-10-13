#!/usr/bin/env perl

my $dir;
my @dir_arr;

BEGIN {
	$ENV{'DANCER_ENVIRONMENT'} = 'testing';
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	$dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib proportal/t/lib );
}

use lib @dir_arr;
use IMG::Util::Base 'Test';
use Dancer2;


{
	package ScriptAppArgs;
	use IMG::Util::Base 'Class';
	with 'IMG::App::Role::ErrorMessages';
	use Getopt::Long qw( GetOptionsFromArray );

	has 'gene_taxon_file' => (
		is => 'ro',
		isa => sub {
			if ( ! -r $_[0] ) {
				if ( ! -e $_[0] ) {
					die 'gene taxon file ' . $_[0] . ' does not exist';
				}
				die 'gene taxon file ' . $_[0] . ' is not readable';
			}
		}

	);

	has 'newick_file' => (
		is => 'ro',
		isa => sub {
			if ( ! -r $_[0] ) {
				die 'Newick file ' . $_[0] .
				( -e $_[0]
					? ' is not readable'
					: ' does not exist' );
			}
		}
	);

	has 'outfile' => (
		is => 'ro',
		isa => sub {
			# either file does not exist or it is writable
			if ( -e $_[0] ) {
				die 'Outfile ' . $_[0] . ' cannot be written' unless -w $_[0];
			}
		}
	);

	has 'test' => (
		is => 'ro',
		isa => Bool
	);

	sub BUILDARGS {
		my $self = shift;
		say 'BUILDARGS for ScriptAppArgs: ' . Dumper( \@_ );

		my $args = {};
		GetOptionsFromArray( shift,
			$args,
			"outfile|o=s",   # string
			"gene_taxon_file|g=s",    # string
			"newick_file|n=s",  # sequence type
		#	"v|verbose"    => \$args->{verbose},   # flag for verbosity
			"test|t"         # flag for test mode
		) or die "Error in command line arguments";

		return $args;
	}

	1;

}

{
	package TestApp;
	use IMG::Util::Base 'Class';
	use Dancer2 appname => 'ProPortal';
	use ProPortal::Util::Factory;
	use ScriptAppArgs;
	extends 'IMG::App';
	with qw( ProPortal::IO::DBIxDataModel ProPortal::Controller::PhyloViewer::Pipeline IMG::Util::ScriptApp );

	1;
}

{
	package TestWithRoleApp;
	use IMG::Util::Base 'Class';
	use Dancer2 appname => 'ProPortal';
	use ProPortal::Util::Factory;
	use ScriptAppArgs;
	extends 'IMG::App';
	with qw( ProPortal::IO::DBIxDataModel ProPortal::Controller::PhyloViewer::Pipeline IMG::Util::ScriptApp ProPortal::Controller::PhyloViewer::Results );

	1;
}


{
	use IMG::Util::Base 'Test';
	use Dancer2;
	use File::Temp qw/tempfile/;
	use Template;
	use ProPortal::Controller::PhyloViewer::DemoData;

#	say 'config: ' . Dumper config;

	my ( $fn, $fh ) = tempfile();

	my $cmd = [ '--gene_taxon_file', $fn, '--newick', $fn, '--test' ];

	my $out = #eval {
		# get the config from Dancer2
		TestApp->new( config => config, args => $cmd );
	$out->add_controller_role('PhyloViewer::Results');
	Role::Tiny->apply_roles_to_object( $out, 'ProPortal::Controller::PhyloViewer::DemoData' );

	#};

	say 'test app: ' . Dumper $out;

	isa_ok( $out, 'TestApp' );

	ok( $out->args->gene_taxon_file eq $fn, 'Checking seq type is correct' );

	is_deeply( $out->controller->tmpl_includes, { tt_scripts => [
		'phylo_viewer',
	] }, 'Checking controller is OK' );

	say Dumper $out->controller->tmpl_includes;

	ok( $out->can('render'), 'Checking out can render' );
	ok( $out->can('get_metadata_for_taxa'), 'Checking out metadata for taxa' );

	my $output;

#	template 'pages/proportal/phylo_viewer/results', $out->render( $out->args ), \$output;

#	say 'output: ' . $output;

#	exit;

	my $tt = Template->new(
		%{ config->{engines}{template}{template_toolkit} },
		INCLUDE_PATH => config->{views}
	) || die $Template::ERROR;

	say 'config: ' . Dumper config;
	my $rslts = $out->render( $out->args );

	app->template( 'pages/proportal/phylo_viewer/results.tt', { %$rslts, mode => 'galaxy' } , \$output );
	say 'output: ' . Dumper $output;



# 	$tt->process( 'pages/proportal/phylo_viewer/results.tt', { %$rslts, mode => 'galaxy' } , \$output
# 	) || die 'Could not render page: ' . $tt->error;



	my $cmd2 = [ qw( --seq_type DNA --test ) ];

	undef $out;

	throws_ok { TestApp->new( config => config, args => $cmd2 ) } qr[dna is not a valid seq_type]i, 'Invalid parameter';


	done_testing();

}

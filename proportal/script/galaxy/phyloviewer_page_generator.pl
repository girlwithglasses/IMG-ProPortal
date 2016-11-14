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

{
	package ScriptAppArgs;
	use IMG::Util::Base 'Class';
	use Getopt::Long qw( GetOptionsFromArray );
	with 'IMG::App::Role::ErrorMessages';
	use IMG::Util::File;

	has 'gene_taxon_file' => (
		is => 'ro',
		isa => sub {
			if ( ! -r $_[0] ) {
				die 'gene taxon file ' . $_[0] .
				( -e $_[0]
					? ' is not readable'
					: ' does not exist' );
			}
		}
	);

	has 'newick' => (
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
			"outfile|o=s",
			"gene_taxon_file|g=s",
			"newick|n=s",
			"test|t"         # flag for test mode
		) or die "Error in command line arguments";

		return $args;
	}

	1;

}


{
	package PhyloViewerApp;
	use IMG::Util::Base 'Class';
	use ScriptAppArgs;
	use AppCore;
	extends 'IMG::App';
	with qw( ProPortal::IO::DBIxDataModel ProPortal::Controller::PhyloViewer::Pipeline IMG::Util::ScriptApp IMG::App::Role::Templater );

	has 'controller_role' => (
		is => 'ro',
		default => 'ProPortal::Controller::PhyloViewer::Results'
	);

	sub run {
		my $self = shift;

		my $tt = Template->new(
			%{ $self->config->{engines}{template}{template_toolkit} },
			INCLUDE_PATH => $self->config->{views}
		) || die $Template::ERROR;

		my $rslts = $self->render( $self->args );
		$rslts->{settings} = $self->config;

		my $out;
		$tt->process(
			'pages/proportal/phylo_viewer/results.tt',
			{ %$rslts, mode => 'galaxy' },
			\$out
		) || die 'Could not render page: ' . $tt->error;

		say 'output: ' . $out;
		open my $fh, '>', $self->args->outfile or die 'could not open outfile: ' . $!;
		print { $fh } $out;
		close $fh;

	}

	1;

}

use Dancer2;
my $out = PhyloViewerApp->new( config => config, args => \@ARGV, controller_role => 'PhyloViewer::Results' );
$out->run();

exit(0);


sub script_die {
	my $code = shift;
	my $err_arr = shift;
	if ( $err_arr ) {
		print STDERR 'Could not complete conversion. Errors:'
			. "\n"
			. ( join "\n", @$err_arr )
			. "\nDying!\n";
	}

	exit( $code );
}

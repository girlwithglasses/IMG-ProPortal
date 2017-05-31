{
	package ScriptAppArgs;
	use IMG::Util::Import 'Class';
	with 'IMG::App::Role::ErrorMessages';
	use IMG::Util::File;
	use Text::CSV_XS qw[ csv ];

	has 'valid_infile_formats' => (
		is => 'lazy',
	);

	sub _build_valid_infile_formats {
		return [ qw( arr tsv ) ];
	}

	has 'infile' => (
		is => 'ro',
		required => 1
	);

	has 'infile_format' => (
		is => 'lazy',
		isa => sub {
			my @valid = qw( arr tsv );
			if ( ! grep { $_[0] eq $_ } @valid ) {
				die err({
					err => 'invalid_enum',
					subject => $_[0],
					type => 'input format',
					enum => \@valid
				});
			}
		}
	);

	sub _build_infile_format {
		return 'tsv';
	}

	has 'outfile' => (
		is => 'ro',
		required => 1,
	);

	has 'test' => (
		is => 'ro',
		isa => Bool
	);

	1;

}

{

package ProPortal::App::GetTaxonMetadata;
use IMG::Util::Import 'Class';
use ScriptAppArgs;
use IMG::App::Role::ErrorMessages qw( err script_die );
extends 'IMG::App';
use IMG::Util::File;
with qw(
	ProPortal::IO::DBIxDataModel
	ProPortal::Controller::PhyloViewer::Pipeline
	IMG::Util::ScriptApp
	IMG::Util::FileAppender
);

has '+cols_reqd' => (
	builder => sub { return [ 'taxon_oid' ]; }
);

has '+csv_output_file' => (
	is => 'lazy',
	builder => sub {
		return shift->args->outfile;
	}
);

has '+csv_input_file' => (
	builder => sub {
		return shift->args->infile;
	}
);

has '+csv_args' => (
	builder => sub {
		return {
			binary => 1,
			sep => "\t",
			auto_diag => 2,
			empty_is_undef => 1
		};
	}
);

sub run {
	my $self = shift;

	my $ixes = $self->extract;

	# this dies if it does not return results
	my $rslts = $self->get_metadata_for_taxa({ taxon_oid => $ixes });

	my @cols = sort grep { $_ ne 'taxon_oid' && $_ ne 'taxon_display_name' && $_ ne '__schema' } keys %{$rslts->[0]};

	$self->_set_output_headers( [ qw( taxon_oid taxon_display_name ), @cols ] );

	$self->expel({
		data_arr => $rslts
	});

}

1;

}

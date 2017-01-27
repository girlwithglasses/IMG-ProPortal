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

package ProPortal::App::GetGeneMetadata;
use IMG::Util::Import 'Class';
use ScriptAppArgs;
use IMG::App::Role::ErrorMessages qw( err script_die );
extends 'IMG::App';
use IMG::Util::File;
with qw(
	ProPortal::IO::DBIxDataModel
	IMG::Util::ScriptApp
 	IMG::Util::FileAppender
);

has '+cols_reqd' => (
	builder => sub { return [ 'gene_oid' ]; }
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
#			binary => 1,
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
	my $rslts = $self->run_query({
		query => 'gene_details',
		where => {
			gene_oid => $ixes
		},
# 		check_results => {
# 			param => 'gene_oid',
# 			query => $args->{gene_oid},
# 			subject => 'gene_oids',
# 		}
	});

	my @cols = sort grep { $_ ne 'gene_oid' && $_ ne '__schema' } keys %{$rslts->[0]};
	$self->_set_output_headers( [ qw( gene_oid ), @cols ] );

	$self->expel({
		data_arr => $rslts
	});

}

1;

}

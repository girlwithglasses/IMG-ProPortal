{
	package ScriptAppArgs;
	use IMG::Util::Base 'Class';
#	use IMG::App::Role::ErrorMessages qw( err );
	with qw[
		IMG::App::Role::ErrorMessages
	];

	use IMG::Util::File;

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
			if (! grep { $_[0] eq $_ } @valid ) {
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

	has 'gene_taxon_file' => (
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

	has 'seq_type' => (
		is => 'lazy',
		isa => sub {
			die err({
				err => 'invalid',
				subject => $_[0],
				type => 'seq_type'
			}) if $_[0] !~ /^f[na]a$/;
		},
		coerce => sub { lc $_[0] }
	);

	sub _build_seq_type {
		return 'fna';
	}

	has 'test_mode' => (
		isa => Bool,
		is => 'lazy',
	);

	has 'gene_oid' => (
		is => 'lazy',
		isa => ArrayRef[Int|Str],
	);

	sub _build_gene_oid {
		my $self = shift;
		my @arr;
		if ( 'arr' eq $self->infile_format ) {
			@arr = grep { /^\d+$/ }
			map { s/\s*(\d+)\s*/$1/; $_ }
			@{ IMG::Util::File::file_to_array( $self->infile ) };
		}
		elsif ( 'tsv' eq $self->infile_format ) {

#			$self->choke({ err => 'not_implemented' });

			# parse in the file, save the lines
			my $csv = Text::CSV_XS->new ({
				auto_diag => 1,
				sep => "\t",
				empty_is_undef => 1
			});

			open my $fh, "<", $self->infile or $self->choke({
				err => 'not_readable', subject => $self->infile, msg => $!
			});

#			my @lines;
			my %ids;
			local $@;

			my @hdr = eval { $csv->header( $fh ) };

			say 'hdr: ' . Dumper \@hdr;

			if ( $@ || ! grep { "gene_oid" eq $_ } @hdr ) {

				if ( $@ ) {
					my @errs = $csv->error_diag();
					say 'Error! ' . join "\n", @errs;
				}

				$self->choke({
					err => 'not_found_in_file',
					subject => '"gene_oid" header',
					file => $self->infile
				});
			}
			my $row = {};
			$csv->bind_columns (\@{$row}{@hdr});
			while ($csv->getline( $fh )) {
				$ids{ $row->{gene_oid} }++ if defined $row->{gene_oid};
			}
			@arr = grep { /\d+/ } keys %ids;
		}

		if ( ! scalar @arr ) {
			$self->choke({
				err => 'not_found_in_file',
				subject => 'gene_oids',
				file => $self->infile
			});
		}

		return \@arr;

	}


# 	has 'gp_tax_arr' => (
# 		is => 'ro',
# 		lazy => 1
# 	);

	1;

}

package ProPortal::App::GeneIdToFasta;

use IMG::Util::Base 'Class';
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

	my $gp_arr = $self->get_taxon_oid_for_genes({
		gene_oid => $ixes
	});

	$self->write_gene_taxon_file({
		gp_arr => $gp_arr,
		fh => $self->args->gene_taxon_file
	});

	$self->create_FASTA_file({
		gp_arr => $gp_arr,
		seq_type => $self->args->seq_type,
		fh => $self->args->outfile
	});

}

1;

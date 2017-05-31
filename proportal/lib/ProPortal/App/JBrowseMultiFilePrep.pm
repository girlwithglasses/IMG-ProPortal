{
	package ScriptAppArgs;
	use IMG::Util::Import 'Class';
	with 'IMG::App::Role::ErrorMessages';
	use IMG::Util::File;
	use IMG::Model::Contact;
	use IMG::Model::Taxon;

	# input file with list of taxa
	has 'taxon_file' => (
		is => 'ro',
		required => 1
	);

	# destination
	has 'target_dir' => (
		is => 'ro',
		required => 1
	);

	has 'taxon_arr' => (
		is => 'lazy',
	);

	sub _build_taxon_arr {
		my $self = shift;
		return IMG::Util::File::file_to_array( $self->taxon_file )
	}

	1;
}

package ProPortal::App::JBrowseMultiFilePrep;

use IMG::Util::Import 'Class';
use ScriptAppArgs;
use File::Copy;
use File::Basename;
use File::Spec::Functions;
extends 'IMG::App';
with qw(
	IMG::Util::ScriptApp
);

sub run {
	my $self = shift;

	for my $t ( @{ $self->args->taxon_arr } ) {

		# copy / soft link the sequence file
		my $seq_src = $self->get_taxon_file({ type => 'dna_seq', taxon_oid => $t });

		# check that seq file exists and symlink
		-r $seq_src and copy(
			$seq_src,
			catfile( $self->args->target_dir, basename( $seq_src ) )
		) or $self->choke({
			err => 'action_err',
			action => 'Sequence file "' . $seq_src . '" symlinking',
			msg => $!
		});

		# copy / soft link the GFF File
		my $gff_src = $self->get_taxon_file({ type => 'gff', taxon_oid => $t});

		-r $gff_src and copy(
			$gff_src,
			catfile( $self->args->target_dir, basename( $gff_src ) )
		) or $self->choke({
			err => 'action_err',
			action => 'GFF file "' . $gff_src . '" symlinking',
			msg => $!
		});
	}

}

1;

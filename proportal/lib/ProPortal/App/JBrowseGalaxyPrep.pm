{
	package ScriptAppArgs;
	use IMG::Util::Import 'Class';
	with 'IMG::App::Role::ErrorMessages';
	use IMG::Util::File;
	use IMG::Model::Contact;
	use IMG::Model::Taxon;

	# sequence file destination
	has 'sequence' => (
		is => 'ro',
		required => 1
	);

	# gff file destination
	has 'gff' => (
		is => 'ro',
		required => 1
	);

	has 'email' => (
		is => 'ro',
		predicate => 1
	);

	has 'taxon' => (
		is => 'rwp',
		isa => InstanceOf['IMG::Model::Taxon']
	);

	has 'taxon_oid' => (
		is => 'ro',
		required => 1,
		coerce => sub {
			$_[0] =~ s/^"?(.*?)"?$/$1/;
			return $_[0];
		}
	);

	1;
}

package ProPortal::App::JBrowseGalaxyPrep;

use IMG::Util::Import 'Class';
use ScriptAppArgs;
use File::Copy;
extends 'IMG::App';
with qw(
	ProPortal::IO::DBIxDataModel
	IMG::Util::ScriptApp
);

sub run {
	my $self = shift;

	if ( $self->args->has_email && $self->args->email ne 'Anonymous' ) {
		# check the user can access the taxon
		my $user_h = $self->get_db_contact_data({ email => $self->args->email });
		$self->_set_user( $user_h );
	}

	# check taxon is public
	my $t_data = $self->run_query({
		query => 'taxon_name_public',
		where => {
			taxon_oid => $self->args->{taxon_oid},
		}
	});

	if ( ! scalar @$t_data || 'private' eq $t_data->[0]{viewable} ) {
		$self->choke({
			err => 'private_data'
		});
	}


	# copy / soft link the sequence file
	my $seq_src = $self->get_taxon_file({ type => 'dna_seq', taxon_oid => $self->args->taxon_oid });

	# check that seq file exists and symlink
	-r $seq_src and copy( $seq_src, $self->args->sequence ) or $self->choke({
		err => 'action_err',
		action => 'Sequence file symlinking',
		msg => $!
	});

	# copy / soft link the GFF File
	my $gff_src = $self->get_taxon_file({ type => 'gff', taxon_oid => $self->args->taxon_oid });

	-r $gff_src and copy( $gff_src, $self->args->gff ) or $self->choke({
		err => 'action_err',
		action => 'GFF file symlinking',
		msg => $!
	});

}

1;

package ProPortal::Controller::Details::Taxon;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Base';

with 'IMG::Model::DataManager';

has '+page_id' => (
	default => 'details/taxon'
);

has '+page_wrapper' => (
	default => 'layouts/default_wide.tt'
);

=head3 render

Details page for a taxon / metagenome

@param taxon_oid

=cut

sub _render {
	my $self = shift;
	return { results => { taxon => $self->get_data( @_ ), label_data => $self->get_label_data } };
}

sub get_data {
	my $self = shift;
	my $args = shift;

	if ( ! $args || ! $args->{taxon_oid} ) {
		$self->choke({
			err => 'missing',
			subject => 'taxon_oid'
		});
	}

	my $res = $self->_core->run_query({
		query => 'taxon_details',
		where => $args
	});

	if ( scalar @$res != 1 ) {
		$self->choke({
			err => 'no_results',
			subject => 'IMG taxon ' . ( $args->{taxon_oid} || 'unspecified' )
		});
	}
	$res = $res->[0];

	my $associated = {
		multi => [ qw(
			gold_sp_cell_arrangements
			gold_sp_collaborators
			gold_sp_diseases
			gold_sp_energy_sources
			gold_sp_genome_publications
			gold_sp_habitats
			gold_sp_metabolisms
			gold_sp_phenotypes
			gold_sp_relevances
			gold_sp_seq_centers
			gold_sp_seq_methods
			gold_sp_study_gold_ids
			taxon_ext_links
		)],
		single => [ qw(
			taxon_stats
		)]
	};
# 		goldanaproj

	for my $type ( %$associated ) {
		for my $assoc ( @{ $associated->{$type} } ) {
			if ( $res->can( $assoc ) ) {
				my $r = $res->$assoc;
		#		log_debug { 'looking at ' . $assoc . '; found ' . Dumper $r };

				if ($r
					&& ( ( 'multi' eq $type && scalar @$r )
					|| ( 'single' eq $type && defined $r ) ) ) {
					$res->{$assoc} = $r;
				}
			}
		}
	}
	return $res;

}

1;

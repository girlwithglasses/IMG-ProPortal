package ProPortal::Controller::TaxonDetails;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Base';

with 'IMG::Model::DataManager';

# has 'controller_args' => (
# 	is => 'lazy',
# 	default => sub {
# 		return {
# 			class => 'ProPortal::Controller::Filtered',
# 			page_id => 'taxon_details',
# 			tmpl => 'pages/taxon_details.tt',
# 			tmpl_includes => {},
# 			page_wrapper => 'layouts/default_wide.html.tt',
# 		};
# 	}
# );


has '+page_id' => (
	default => 'taxon_details'
);

has '+page_wrapper' => (
	default => 'layouts/default_wide.html.tt'
);

=head3 render

Details page for a taxon / metagenome

@param taxon_oid

=cut

sub _render {
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
		%$args
	});

	if ( scalar @$res != 1 ) {
		$self->choke({
			err => 'no_results',
			subject => 'IMG taxon ' . ( $args->{taxon_oid} || 'unspecified' )
		});
	}
	$res = $res->[0];

	my @associated = qw(
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
	);

# 		goldanaproj


	for my $assoc (@associated) {
		if ( $res->can( $assoc ) ) {
			my $r = $res->$assoc;
			if ($r && scalar @$r) {
				$res->{$assoc} = $r;
			}
		}
	}

	return { results => { taxon => $res, label_data => $self->get_label_data } };

}

1;

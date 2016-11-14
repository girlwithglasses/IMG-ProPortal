# NOT YET IMPLEMENTED (Oct 2016)

package ProPortal::Controller::TaxonDetails;

use IMG::Util::Base 'MooRole';

has 'controller_args' => (
	is => 'lazy',
	default => sub {
		return {
			class => 'ProPortal::Controller::Filtered',
			tmpl => 'pages/proportal/taxon_details.tt',
			tmpl_includes => {
#				tt_scripts => qw( data_type )
			}
		};
	}
);


=head3 render

Details page for a taxon / metagenome

@param taxon_oid

=cut

sub render {
	my $self = shift;
	my $args = shift;
	my $res = $self->run_query({
		query => 'taxon_details',
		%$args
#		filters => $self->filters
	});

#	my $data = $self->taxon_details( $self->filters->{taxon_oid} );

	if (scalar @$res != 1) {
		croak "Found " . scalar(@$res) . " results for taxon query";
	}
	$res = $res->[0];

	my @associated = qw(
		gold_sp_genome_publications
		gold_sp_habitats
		gold_sp_energy_sources
		gold_sp_phenotypes
		goldanaproj
		gold_sp_seq_centers
		gold_sp_seq_methods
		gold_sp_relevances
		gold_sp_cell_arrangements
		gold_sp_metabolisms
		gold_sp_study_gold_ids
		gold_sp_collaborators
		gold_sp_diseases
	);

	for my $assoc (@associated) {
		if ( $res->can( $assoc ) ) {
			say 'can do ' . $assoc;
			my $r = $res->$assoc;
			if ($r && scalar @$r) {
				$res->{$assoc} = $r;
			}
		}
	}

	say "results: " . Dumper $res;

	return $self->add_defaults_and_render( $res );

}

1;

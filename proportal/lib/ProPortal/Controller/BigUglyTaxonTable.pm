package ProPortal::Controller::BigUglyTaxonTable;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Filtered';

use Template::Plugin::JSON::Escape;

has 'controller_args' => (
	is => 'lazy',
	default => sub {
		return {
			page_id => 'proportal/big_ugly_taxon_table',
			tmpl => 'pages/proportal/big_ugly_taxon_table.tt',
			class => 'ProPortal::Controller::Filtered',
		}
	}
);

has '+page_id' => (
	default => 'proportal/big_ugly_taxon_table'
);


=head3 render

Get all the GoldTaxonVw table data

=cut

sub _render {
	my $self = shift;

	my $res = $self->get_data();
    if ( ! $res || ! scalar @$res ) {
		$self->choke({
			err => 'no_results',
		});
    }

	my $cols = [ qw( genome_type ncbi_kingdom domain ),
[ qw( phylum ncbi_phylum ) ],
[ qw( ir_class ncbi_class ) ],
[ qw( ir_order ncbi_order ) ],
[ qw( family ncbi_family ) ],
[ qw( genus ncbi_genus ) ],
'clade',
[ qw( species ncbi_species ) ],
qw( strain ncbi_taxon_id analysis_project_id study_gold_id gold_id sequencing_gold_id ecosystem ecosystem_category ecosystem_type ecosystem_subtype specific_ecosystem ecotype geo_location longhurst_code longhurst_description latitude longitude altitude biotic_rel cell_shape combined_sample_flag ), [ qw( depth depth_string ) ], qw( gram_stain motility oxygen_req salinity sporulation temp_range ) ];

	return { results => { js => { array => $res, cols => $cols } } };

}

sub get_data {
	my $self = shift;
#	return decode_json <DATA>;
	return $self->_core->run_query({
		query => 'taxon_metadata',
		filters => $self->filters,
	});
}

1;

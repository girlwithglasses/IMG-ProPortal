package ProPortal::Controller::List::Taxon;

use IMG::Util::Import 'Class';#'MooRole';

extends 'ProPortal::Controller::Filtered';
with
qw( ProPortal::Controller::Role::TableHelper
	ProPortal::Controller::Role::Paged
);

use Template::Plugin::JSON::Escape;

has '+page_wrapper' => (
    default => 'layouts/default_wide.tt'
);

has '+page_id' => (
	default => 'list/taxon'
);

has '+filter_domains' => (
	default => sub {
		return [ qw( pp_subset dataset_type ) ];
	}
);

# has '+valid_filters' => (
# 	default => sub {
# 		return {
# 			pp_subset => {
# 				enum => [ qw( pro pro_phage syn syn_phage other other_phage isolate metagenome all_proportal ) ]
# 			},
# 			dataset_type => {
# 				enum => [ qw( isolate single_cell metagenome transcriptome metatranscriptome ) ]
# 			},
# 		};
# 	}
# );


=head3 taxon_list



=cut

sub _render {
	my $self = shift;

	my $output = {
		domain => 'taxon',
		table => $self->get_table('taxon'),
		params => $self->filters,
	};

	my $statement = $self->get_data;
#	$self->page_me( $statement );
	$output->{n_results} = $statement->row_count;
#	$output->{n_pages} = $statement->page_count;
	$output->{arr} = $statement->all;

	return { results => $output };

}


sub get_data {
	my $self = shift;

	# get basic taxon info for each of the members
	return $self->_core->run_query({
		query => 'taxon_dataset_type',
		filters => $self->filters,
		result_as => 'statement'
	});
}

sub examples {

# 	base_url => '/list/taxon',
# 	key_id => '<code>/list/taxon?</code>( <empty>[default] )',
# 	params => {
# 		pp_subset => '( pro | syn | other | pro_phage | syn_phage | other_phage | metagenome )',
# 		dataset_type => '( transcriptome | single_cell | isolate | metagenome | metatranscriptome )',
# 		return => '( all[default] | location | clade | ecosystem )',
# 	},
	return [{
		url => '/list/taxon?pp_subset=all_proportal',
		desc => 'list all taxa in ProPortal'
	},{
		url => '/list/taxon?pp_subset=pro',
		desc => 'list all (isolates, single cells, transcriptomes) classified as <i>Prochlorococcus</i>'
	},{
		url => '/list/taxon?pp_subset=metagenome',
		desc => 'list all metagenomes (including metatranscriptomes).'
	},{
		url => '/list/taxon?dataset_type=metagenome',
		desc => 'Returns all metagenomes (excluding metatranscriptomes)'
	},{
		url => '/list/taxon?pp_subset=pro&pp_subset=syn',
		desc => 'Return all taxa classified as either <i>Prochlorococcus</i> and <i>Synechococcus</i>'
	},{
		url => '/list/taxon?pp_subset=pro&dataset_type=single_cell',
		desc => 'Return all <i>Prochlorococcus</i> single cell genomes.'
	},{
		url => '/list/taxon?pp_subset=pro&dataset_type=metagenome',
		desc => 'Lists all <i>Prochlorococcus</i> taxa of type metagenome (i.e. returns nothing!)'
# 		url => '/list/taxon?sort=by_location ',
# 		desc => 'Lists all taxa in ProPortal. Sorts by geo_location and returns geo_location, ocean, depth, latitude, longitude'
# 	},{
# 		url => '/list/taxon?sort=by_clade ',
# 		desc => 'Lists all taxa in ProPortal. Sorts by clade and returns clade and ecotype.'
# 	},{
# 		url => '/list/taxon?sort=by_ecosystem ',
# 		desc => 'Lists all taxa in ProPortal. Sorts by ecosystem_subtype and returns ecosystem, ecosystem_category, ecosystem_type, ecosystem_subtype, specific_ecosystem.'
# 	},{
# 		url => '/list/taxon?pp_subset=pro&sort=by_clade',
# 		desc => 'Lists all <i>Prochlorococcus</i> taxa in ProPortal and sorts by clade.'
# 	},{
	}];
}

1;

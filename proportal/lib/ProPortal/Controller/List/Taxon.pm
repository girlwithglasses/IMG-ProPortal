package ProPortal::Controller::List::Taxon;

use IMG::Util::Import 'Class';#'MooRole';

extends 'ProPortal::Controller::Filtered';
with qw(
	ProPortal::Controller::Role::Paged
	ProPortal::Controller::Role::CommonQueries
);

use Template::Plugin::JSON::Escape;

has '+page_wrapper' => (
    default => 'layouts/default_wide.tt'
);

has '+page_id' => (
	default => 'list/taxon'
);

has '+tmpl_includes' => (
	default => sub {
		return {
			tt_scripts => qw( datatables ),
		};
	}
);

has '+filter_domains' => (
	default => sub {
		return [ qw( pp_subset dataset_type cycog_version ) ];
	}
);

has 'order_by' => (
	is => 'rwp',
	default => 'taxon_oid'
);

has 'table_cols' => (
	is => 'ro',
	default => sub {
		return [ qw( taxon_oid taxon_display_name dataset_type pp_subset ) ];
	}
);

=head3 taxon_list



=cut

sub _render {
	my $self = shift;

	my $domain = 'taxon';
	my $statement = $self->get_data;
	my $res;
# 	if ( 'ARRAY' eq ref $statement ) {
# 		# don't try to page it
# 		$res = $statement;
# 		$self->_set_n_results( scalar
# 	}
# 	else {
		$res = $self->page_me( $statement )->all;
# 	}
	return { results => {
		js => {
			arr => $res,
			table_cols => [ 'cbox_' . $domain, @{ $self->table_cols } ]
		},
		paging => $self->paging_helper,
		domain => $domain,
		params => $self->filters
	} };

}


sub get_data {
	my $self = shift;

	if ( $self->filters->{cycog_version} ) {
		return $self->taxon_list_by_cycog_version;
	}

	# get basic taxon info for each of the members
	return $self->_core->run_query({
		query => 'taxon_dataset_type',
		filters => $self->filters,
		-result_as => 'statement',
		-order_by => $self->order_by,
		-columns => $self->table_cols
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

package ProPortal::Controller::List::Scaffold;

use IMG::Util::Import 'Class';#'MooRole';

extends 'ProPortal::Controller::Filtered';
with 'ProPortal::Controller::Role::Paged';

use Template::Plugin::JSON::Escape;

has '+page_wrapper' => (
    default => 'layouts/default_wide.tt'
);

has '+page_id' => (
	default => 'list/scaffold'
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
		return [ qw( taxon_oid pp_subset ) ];
	}
);

has 'order_by' => (
	is => 'rwp',
	default => 'taxon_oid'
);

has 'table_cols' => (
	is => 'ro',
	default => sub {
		return [ qw(
			scaffold_oid
			scaffold_name
			mol_type
			mol_topology
			db_source
			ext_accession
			taxon_display_name
			pp_subset
		) ];
	}
);

=head3 data_type



=cut

sub _render {
	my $self = shift;
	my $domain = 'scaffold';
	my $statement = $self->get_data;
	my $res = $self->page_me( $statement )->all;
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

	# get basic taxon info for each of the members
	return $self->_core->run_query({
		query => 'scaffold_list',
		filters => $self->filters,
		-result_as => 'statement'
	});
}

sub examples {

	return [{
		url => '/list/scaffold?taxon_oid=640069325',
		desc => 'list all scaffolds for taxon NATL2A (taxon_oid 640069325)'
	}];

}

1;

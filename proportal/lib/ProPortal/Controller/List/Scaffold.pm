package ProPortal::Controller::List::Scaffold;

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
	default => 'list/scaffold'
);

has '+filter_domains' => (
	default => sub {
		return [ qw( taxon_oid pp_subset ) ];
	}
);


=head3 data_type



=cut

sub _render {
	my $self = shift;

	my $statement = $self->get_data;
	my $arr = $self->page_me( $statement )->all;

	return { results => {
		domain => 'scaffold',
		arr => $arr,
		n_results => $statement->row_count,
		n_pages   => $statement->page_count,
		table => $self->get_table('scaffold'),
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

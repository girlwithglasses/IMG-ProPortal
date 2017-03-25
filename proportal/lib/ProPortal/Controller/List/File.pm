package ProPortal::Controller::List::File;

use IMG::Util::Import 'Class';#'MooRole';

extends 'ProPortal::Controller::Filtered';

has '+page_wrapper' => (
    default => 'layouts/default_wide.tt'
);

has '+page_id' => (
	default => 'list/file'
);

has '+filter_domains' => (
	default => sub {
		return [ qw( pp_subset dataset_type file_type ) ];
	}
);

=head3 file_type



=cut

sub _render {
	my $self = shift;

	return { results => { taxon => $self->get_data } };
}


sub get_data {
	my $self = shift;

	# get basic taxon info for each of the members
	my $data = $self->_core->run_query({
		query => 'taxon_dataset_type',
		filters => $self->filters,
	});

	for my $tax ( @$data ) {
		for ( @{$self->query_filter_schema->{file_type}{enum}} ) {
			$tax->{$_} = -r $self->_core->get_taxon_file({ type => $_, taxon_oid => $tax->{taxon_oid} });
		}
	}

	return $data;


}

1;

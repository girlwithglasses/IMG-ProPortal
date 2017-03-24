package ProPortal::Controller::List::Function;

use IMG::Util::Import 'Class';

extends 'ProPortal::Controller::Filtered';

use Template::Plugin::JSON::Escape;

has '+page_wrapper' => (
    default => 'layouts/default_wide.tt'
);

has '+page_id' => (
	default => 'list/function'
);

has '+filter_domains' => (
	default => sub {
		return [ qw( db ) ];
	}
);

=head3 function list



=cut

sub _render {
	my $self = shift;

# 	count for paging?
# 	my $count = $self->_core->run_query({
# 		query => 'function_list_count',
# 		filters => $self->filters
# 	});

	return { results => { functions => $self->get_data } };
}


sub get_data {
	my $self = shift;

	my @valid_prefixes = ( qw( cycog cog ) );

	# get basic function info
	return $self->_core->run_query({
		query => 'cycog_list',
#		filters => $self->filters,
	});
}

1;

package ProPortal::Controller::List::Function;

use IMG::Util::Import 'Class';#'MooRole';

extends 'ProPortal::Controller::Filtered';

use Template::Plugin::JSON::Escape;

has '+page_wrapper' => (
    default => 'layouts/default_wide.tt'
);

has '+page_id' => (
	default => 'list/function'
);

# has '+filters' => (
# 	default => sub {
# 		return { pp_subset => 'all_proportal' };
# 	},
# );

# has '+filter_domains' => (
# 	is => 'ro',
# 	default => sub {
# 		return [ qw( db ) ];
# 	}
# );


=head3 data_type



=cut

sub _render {
	my $self = shift;
	my $data;

	my $res = $self->get_data;

#	say 'Got ' . scalar @$res . ' results. Sorting at ' . Time::HiRes::gettimeofday;

	# arrange by genome type, dataset_type, pp_subset, and then by ecosystem subtype

#	say 'Sorted. Returning at ' . Time::HiRes::gettimeofday;

	return { results => { functions => $res } };
}


sub get_data {
	my $self = shift;
	my $args = shift;

	my @valid_prefixes = ( qw( cycog cog ) );



	# get basic function info
	return $self->_core->run_query({
		query => 'cycog_list',
#		filters => $self->filters,
	});
}

1;

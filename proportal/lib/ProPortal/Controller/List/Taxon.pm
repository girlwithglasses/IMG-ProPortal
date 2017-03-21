package ProPortal::Controller::List::Taxon;

use IMG::Util::Import 'Class';#'MooRole';

extends 'ProPortal::Controller::Filtered';

use Template::Plugin::JSON::Escape;

has '+page_id' => (
	default => 'list/taxon'
);

# has '+filters' => (
# 	default => sub {
# 		return { pp_subset => 'all_proportal' };
# 	},
# );

has '+valid_filters' => (
	default => sub {
		return {
			pp_subset => {
				enum => [ qw( pro pro_phage syn syn_phage other other_phage isolate metagenome all_proportal ) ]
			},
			dataset_type => {
				enum => [ qw( isolate single_cell metagenome transcriptome metatranscriptome ) ]
			},
		};
	}
);


=head3 data_type



=cut

sub _render {
	my $self = shift;
	my $data;

	my $res = $self->get_data;

	say 'Got ' . scalar @$res . ' results. Sorting at ' . Time::HiRes::gettimeofday;

	# arrange by genome type, dataset_type, pp_subset, and then by ecosystem subtype

	say 'Sorted. Returning at ' . Time::HiRes::gettimeofday;

	return { results => { data => $res } };
}


sub get_data {
	my $self = shift;

	# get basic taxon info for each of the members
	return $self->_core->run_query({
		query => 'taxon_dataset_type',
		filters => $self->filters,
	});
}

1;

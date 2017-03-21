package ProPortal::Controller::DataType;

use IMG::Util::Import 'Class';#'MooRole';

extends 'ProPortal::Controller::Filtered';

use Template::Plugin::JSON::Escape;

has '+page_id' => (
	default => 'proportal/data_type'
);

has '+filter_domains' => (
	default => sub {
		return [ qw( pp_subset dataset_type ) ];
	}
);

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

	for (@$res) {
		local $@;
		eval {
		push @{$data->{subset_dataset_type}{ $_->{pp_subset} }{ $_->{dataset_type} }}, $_->{taxon_oid};
		push @{$data->{dataset_type_subset}{ $_->{dataset_type} }{ $_->{pp_subset} }}, $_->{taxon_oid};
		$data->{ix}{ $_->{taxon_oid} } = $_;
		};
		if ($@) {
			say Dumper $_;
			die 'error with ' . $_ . ": " . $@ ;
		}
	}

	say 'Sorted. Returning at ' . Time::HiRes::gettimeofday;

	return { results => { data => $data, sort_by => [ 'pp_subset', 'dataset_type' ] } };
}


sub get_data {
	my $self = shift;

	# get taxon and dataset info for each of the members
	return $self->_core->run_query({
		query => 'taxon_dataset_type',
		filters => $self->filters,
	});
}

1;

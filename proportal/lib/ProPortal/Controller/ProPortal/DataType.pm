package ProPortal::Controller::ProPortal::DataType;

use IMG::Util::Import 'Class';#'MooRole';

extends 'ProPortal::Controller::Filtered';

use Template::Plugin::JSON::Escape;

has '+page_id' => (
	default => 'proportal/data_type'
);

has '+tmpl_includes' => (
	default => sub {
		return {
			tt_scripts => qw( data_type ),
		};
	}
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
				enum => [ qw( pro pro_phage syn syn_phage other other_phage pp_isolate pp_metagenome all_proportal ) ]
			},
			dataset_type => {
				enum => [ qw( isolate single_cell metagenome transcriptome metatranscriptome genome_from_metagenome ) ]
			},
		};
	}
);


=head3 data_type



=cut

sub _render {
	my $self = shift;
	my $arr = $self->get_data->all;

	return { results => {
		js => {
			arr => $arr,
			table_cols => [
			'cbox_taxon',
			'taxon_oid', 'taxon_display_name', 'pp_subset', 'dataset_type'
			]
		}
	} };
}


sub get_data {
	my $self = shift;

	# get taxon and dataset info for each of the members
	return $self->_core->run_query({
		query => 'taxon_dataset_type',
		filters => $self->filters,
		-result_as => 'statement'
	});
}

1;

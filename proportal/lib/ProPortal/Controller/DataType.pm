package ProPortal::Controller::DataType;

use IMG::Util::Base 'Class';

extends 'ProPortal::Controller::Base';

has '+valid_filters' => (
	default => sub {
		return {
			ecosystem_subtype => {
				id => 'ecosystem_subtype',
				label => 'ecosystem subtype',
				type => 'checkbox',
				is_active => 0,
				values => [
					{ id => 'marginal', label => 'Marginal sea' },
					{ id => 'neritic',  label => 'Neritic zone' },
					{ id => 'pelagic',  label => 'Pelagic' }
				]
			}
		};
	},
);


=head3 data_type_graph



=cut

sub render {
	my $self = shift;
	my $data;

	# run taxon_oid_display_name for each of the members
	my $res = $self->run_query({
		query => 'taxon_oid_display_name',
		filters => $self->filters,
	});

	# arrange by genome type and then by ecosystem subtype
	for (@$res) {
		push @{$data->{ $_->{genome_type} }{ $_->{ecosystem_subtype} || 'Unclassified' }}, $_;
	}

	return $self->add_defaults_and_render( $data );

}

1;

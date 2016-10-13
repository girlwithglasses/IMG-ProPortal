package ProPortal::Controller::DataType;

use IMG::Util::Base 'MooRole';

#extends 'ProPortal::Controller::Filtered';

use Template::Plugin::JSON::Escape;

has 'controller_args' => (
	is => 'lazy',
	default => sub {
		return {
			class => 'ProPortal::Controller::Filtered',
			tmpl => 'pages/data_type.tt',
			tmpl_includes => {
				tt_scripts => qw( data_type )
			}
		};
	}
);

=head3 data_type



=cut

sub render {
	my $self = shift;
	my $data;

	my $res = $self->get_data;

	# arrange by genome type and then by ecosystem subtype
	for (@$res) {
		push @{$data->{ $_->{genome_type} }{ $_->{ecosystem_subtype} || 'Unclassified' }}, $_;
	}

	return $self->add_defaults_and_render({ sorted_data => $data, array => $res });
}


sub get_data {
	my $self = shift;

	# run taxon_oid_display_name for each of the members
	return $self->run_query({
		query => 'taxon_oid_display_name',
		filters => $self->filters,
	});
}

1;

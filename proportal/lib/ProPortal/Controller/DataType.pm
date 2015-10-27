package ProPortal::Controller::DataType;

use IMG::Util::Base 'Class';

extends 'ProPortal::Controller::Filtered';

use Template::Plugin::JSON::Escape;

has '+tmpl_includes' => (
	default => sub {
		return {
			tt_scripts => qw( data_type ),
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

	return $self->add_defaults_and_render({ sorted_data => $data, array => $res });

}

1;

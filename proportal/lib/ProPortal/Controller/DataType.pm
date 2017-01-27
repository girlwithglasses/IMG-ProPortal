package ProPortal::Controller::DataType;

use IMG::Util::Import 'Class';#'MooRole';

extends 'ProPortal::Controller::Filtered';

use Template::Plugin::JSON::Escape;

# has 'controller_args' => (
# 	is => 'lazy',
# 	default => sub {
# 		return {
# 			class => 'ProPortal::Controller::Filtered',
# 			tmpl => 'pages/proportal/data_type.tt',
# 			tmpl_includes => {
# 				tt_scripts => qw( data_type )
# 			}
# 		};
# 	}
# );

has '+page_id' => (
	default => 'proportal/data_type'
);

has '+tmpl_includes' => (
	default => sub {
		return { tt_scripts => qw( data_type ) };
	}
);


=head3 data_type



=cut

sub _render {
	my $self = shift;
	my $data;

	my $res = $self->get_data;

	# arrange by genome type and then by ecosystem subtype
	for (@$res) {
		push @{$data->{ $_->{genome_type} }{ $_->{ecosystem_subtype} || 'Unclassified' }}, $_;
	}

	return { results => { sorted_data => $data, array => $res } };
}


sub get_data {
	my $self = shift;

	# run taxon_oid_display_name for each of the members
	return $self->_core->run_query({
		query => 'taxon_oid_display_name',
		filters => $self->filters,
	});
}

1;

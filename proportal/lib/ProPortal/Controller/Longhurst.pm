package ProPortal::Controller::Longhurst;

use IMG::Util::Import 'Class';#'MooRole';

extends 'ProPortal::Controller::Filtered';

use Template::Plugin::JSON::Escape;

has '+page_id' => (
	default => 'proportal/longhurst'
);

# has '+tmpl_includes' => (
# 	default => sub {
# 		return { tt_scripts => qw( location ) };
# 	}
# );



=head3 render


=cut

sub _render {
	my $self = shift;

	my $res = $self->get_data->all;
	my $data;
	for ( @$res ) {
		$data->{ix}{ $_->{taxon_oid} } = $_;
		push @{$data->{by_lh}{ ( $_->{longhurst_description} || 'Unclassified' ) }}, $_->{taxon_oid};
	}

	return { results => $data };

}

sub get_data {
	my $self = shift;
	return $self->_core->run_query({
		query => 'longhurst',
		filters => $self->filters,
		result_as => ['hashref' => 'longhurst_description']
	});
}

1;

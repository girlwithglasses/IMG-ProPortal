package ProPortal::Controller::DatamartStats;

use IMG::Util::Base 'Class';

with 'ProPortal::Controller::Base';

=head3 datamart_stats



=cut

sub render {
	my $self = shift;

	my $data = $self->run_query({
		query => 'datamart_stats',
		filters => $self->filters,
	});

	return $self->add_defaults_and_render( $data );

}

1;

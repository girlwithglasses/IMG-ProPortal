# NOT IN USE (Oct 2016)

package ProPortal::Controller::DatamartStats;

use IMG::Util::Import 'Class';

extends 'ProPortal::Controller::Base';

=head3 datamart_stats



=cut

sub _render {
	my $self = shift;

	my $data = $self->_core->run_query({
		query => 'datamart_stats',
		filters => $self->filters,
	});

	return { results => $data };

}

1;

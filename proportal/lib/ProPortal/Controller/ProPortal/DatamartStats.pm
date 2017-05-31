# NOT IN USE (Oct 2016)

package ProPortal::Controller::DatamartStats;

use IMG::Util::Import 'Class';

use Template::Plugin::JSON::Escape;

extends 'ProPortal::Controller::Base';

=head3 datamart_stats



=cut

sub _render {
	my $self = shift;

	my $data = $self->_core->run_query({
		query => 'taxon_dataset_type',
		filters => $self->filters,
	});

	for ( @$data ) {
		$_->expand( 'taxon_stats' );
	}

	return { results => {
		js => {
			arr => $data
		}
	} };

}

1;

package ProPortal::Controller::Details;

use IMG::Util::Base 'Class';

extends 'ProPortal::Controller::Base';

=head3 render

Details page for a taxon / metagenome

@param taxon_oid

=cut

sub render {
	my $self = shift;

#	my $data = $self->run_query({
#		query => 'taxon_details',
#		filters => $self->filters
#	});

	my $data = $self->taxon_details( $self->filters->{taxon_oid} );

	return $self->add_defaults_and_render( $data );

}

1;

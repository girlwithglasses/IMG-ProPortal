package ProPortal::Controller::PhyloViewer::Submit;

use IMG::Util::Base 'Class';

extends 'ProPortal::Controller::Base';

with qw( ProPortal::Controller::PhyloViewer::DemoData ProPortal::Controller::PhyloViewer::Schema ProPortal::Controller::PhyloViewer::Pipeline );

=head3 render

Validate the PhyloViewer form and set up the workflow

=cut

sub render {
	my $self = shift;
	my $params = shift;

	$self->validate( $params );

	my $q_id = $self->init_pipeline( $params );

	return $self->add_defaults_and_render({
		query_id => $q_id
	});
}

=head3 validate

Ensure our query parameters are correct;

=cut

sub validate {
	my $self = shift;
	my $params = shift;

	die 'To be implemented!';

	# validate the parameters
	my $validator = JSON::Validator->new;

	$validator->schema( $self->get_query_schema );

	my @errors = $validator->validate( $params );

	if ( @errors ) {

		die @errors;

	}
}


1;

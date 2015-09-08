package ProPortal::Controller::Home;

use IMG::Util::Base 'Class';

extends 'ProPortal::Controller::Base';

=head3

ProPortal home page

=cut

sub render {
	my $self = shift;

	# get the news!
	my $data = $self->run_query({
		query => 'news',
	});

#	my $data = undef;

	return $self->add_defaults_and_render( $data );

}

1;

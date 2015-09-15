package ProPortal::Controller::Home;

use IMG::Util::Base 'Class';

extends 'ProPortal::Controller::Base';

=head3

ProPortal home page

=cut

sub render {
	my $self = shift;

	# get the news!
	local $@;
	my $data = eval { $self->run_query({ query => 'news' }); };

#	my $data = undef;

	return $self->add_defaults_and_render( $data || undef );

}

1;

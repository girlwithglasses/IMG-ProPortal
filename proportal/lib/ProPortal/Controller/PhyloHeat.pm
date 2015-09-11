package ProPortal::Controller::PhyloHeat;

use IMG::Util::Base 'Class';

extends 'ProPortal::Controller::Base';

#use Template::Plugin::JSON::Escape;

has '+tmpl_includes' => (
	default => sub {
		return {
			tt_scripts => [
				'phylo_heat',
			],
		};
	},
);

=head3 render

Will require JSON plugin for rendering data set

=cut

sub render {
	my $self = shift;

	return $self->add_defaults_and_render( {} );

}

1;

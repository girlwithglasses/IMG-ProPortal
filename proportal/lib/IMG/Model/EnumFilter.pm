package IMG::Model::EnumFilter;

use IMG::Util::Import 'Class';

extends 'IMG::Model::Filter';

has 'valid' => (
	is => 'rwp',
	default => sub {
		return [];
	}
);

sub _set_filter {
	my $self = shift;
	my $args = shift;

	if ( ! $args->{ $self->id } ) {
		# set the value to undefined?

	}

	if ( ! grep { $_ eq  $args->{ $self->id } } @{ $self->valid } ) {
		$self->choke({
			err => 'invalid',
			subject => $args->{ $self->id },
			type => 'filter value'
		});
	}

	$self->_set_current( $args->{ $self->id } );
	return;
}

1;

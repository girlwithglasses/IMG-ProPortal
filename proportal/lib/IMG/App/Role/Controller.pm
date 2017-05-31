package IMG::App::Role::Controller;

use IMG::Util::Import 'MooRole';
use IMG::Util::Factory;
use ProPortal::Controller::Base;
use Scalar::Util qw( blessed );

has 'controller' => (
	is => 'rwp',
	lazy => 1,
	predicate => 1,
	clearer => 1,
	trigger => 1,
	coerce => sub {
#		my @args = @_;
		log_debug { 'running coerce controller' };
		if ( @_ ) {
		log_debug { 'args to coerce: ' . Dumper @_ };
			if ( 1 == scalar @_ ) {
				# object
				if ( blessed $_[0] ) {
					return shift;
				}
				# class name
				elsif ( ! ref $_[0] ) {
					# must be a class, not a role
					log_debug { 'single scalar arg' };
					IMG::Util::Factory::load_module( $_[0] );
					return +shift->new()
				}
				# hashref
				else {
					log_debug { 'hashref' };
					my $href = shift;
					if ( $href->{class} ) {
						my $class = $href->{class};
						IMG::Util::Factory::load_module( $class );
						log_trace { 'class init-ing args: ' . Dumper $href };
						return $class->new( $href );
					}
					return $href;
				}
			}
			log_debug { 'found ' . ( scalar @_ ) . ' args. About to shift...' };
			my $cl = shift;
#			log_debug { Dumper $_[0] };
			return $cl->new( %{ +shift } );
		}
		die 'No controller supplied!';
	},
	default => sub {
		my $self = shift;
		log_debug { 'running controller default' };

		if ( $self->can( 'controller_args' ) ) {
			log_debug { 'I can controller args! ' . Dumper $self->controller_args };

			return $self->_set_controller( $self->controller_args );
		}
		return ProPortal::Controller::Base->new();
	},

	handles => [ qw( set_filters filters ) ]

);

sub add_controller {
	my $self = shift;
	my $class = $self->_prepare_controller( shift );
	my $extras = shift // {};

	log_debug { 'running _set_controller' };
	log_debug { 'extras: ' . Dumper $extras };
	$extras->{_core} = $self;

#	log_debug { 'controller: ' . $class };
	$self->_set_controller({ class => $class, %$extras });

	if ( $self->controller->can('controller_args') ) {
		log_error { 'Found old controller_args!' };
		$self->_set_controller( $self->controller->controller_args );
	}
	return $self;
}


sub add_controller_role {
	my $self = shift;
	log_debug { 'running add_controller_role' };
	my $role = $self->_prepare_controller( shift );
	Role::Tiny->apply_roles_to_object( $self, $role );

#	log_debug { 'self now: ' . Dumper $self };

	if ( $self->controller_args ) {
		$self->_set_controller( $self->controller_args );
	}
	$self->controller->_core( $self );
#	log_debug { 'self now: ' . Dumper $self };

	return $self;
}


sub _prepare_controller {
	my $self = shift;
	my $module = shift;
	if ( $module !~ /Controller/ ) {
		$module = IMG::Util::Factory::_rename( 'Controller', $module );
	}
	return $module;
}

sub _trigger_controller {
	my $self = shift;
	$self->controller->_core( $self );
}

around '_set_controller' => sub {
	my $orig = shift;
	my $self = shift;
	$orig->( $self, @_ );
	$self->controller->_core( $self );
	log_trace { 'controller now: ' . Dumper $self->controller };
};

1;

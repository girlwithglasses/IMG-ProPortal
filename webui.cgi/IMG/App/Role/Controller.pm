package IMG::App::Role::Controller;

use IMG::Util::Import 'MooRole';
use ProPortal::Util::Factory;
use ProPortal::Controller::Base;
use Scalar::Util qw( blessed );
#use IMG::App::Role::Logger;
#use Dancer2;

has 'controller' => (
	is => 'rwp',
	lazy => 1,
	predicate => 1,
	clearer => 1,
	coerce => sub {
#		my @args = @_;
		log_debug { 'running coerce controller' };
#		log_debug { Dumper \@args };
		if ( @_ ) {

			if ( 1 == scalar @_ ) {
				# object
				if ( blessed $_[0] ) {
					return shift;
				}
				# class name
				elsif ( ! ref $_[0] ) {
					# must be a class, not a role
				#	log_debug { 'single scalar arg' };
					IMG::Util::Factory::load_module( $_[0] );
					return +shift->new()
				}
				# hashref
				else {
					my $href = shift;
					if ( $href->{class} ) {
						my $class = $href->{class};
						IMG::Util::Factory::load_module( $class );
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

# sub _build_controller {
# 	log_debug { 'Running build controller!' };
# #	log_debug { 'args: ' . Dumper( \@_ ) };
# 	return ProPortal::Controller::Base->new();
# }

sub add_controller {
	my $self = shift;
	my $class = $self->_prepare_controller( shift );
	my $extras = shift // {};

	log_debug { 'running _set_controller' };
	$extras->{_core} = $self;

	log_debug { 'controller: ' . $class };
	$self->_set_controller({ class => $class, %$extras });

	if ( $self->controller->can('controller_args') ) {
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
		$module = ProPortal::Util::Factory::_rename( 'Controller', $module );
	}
	return $module;
}

1;

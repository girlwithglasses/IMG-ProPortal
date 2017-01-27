package IMG::App::Role::Controller;

use IMG::Util::Import 'MooRole';
use ProPortal::Util::Factory;
use ProPortal::Controller::Base;
use Scalar::Util qw( blessed );
#use Dancer2;

has 'controller' => (
	is => 'rwp',
	lazy => 1,
	predicate => 1,
	clearer => 1,
	coerce => sub {
		say 'running coerce controller';
#		say Dumper \@_;
		if ( @_ ) {

			if ( 1 == scalar @_ ) {

				# object
				if ( blessed $_[0] ) {
					return shift;
				}
				# class name
				elsif ( ! ref $_[0] ) {
					# must be a class, not a role
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
#			say 'found ' . ( scalar @_ ) . ' args. About to shift...';
			my $cl = shift;
#			say Dumper $_[0];
			return $cl->new( %{ +shift } );
		}
		die 'No controller supplied!';
	},
	default => sub {
		say 'running controller default';
#		say Dumper \@_;

		my $self = shift;
		if ( $self->can( 'controller_args' ) ) {
			say 'I can controller args! ' . Dumper $self->controller_args;

			return $self->_set_controller( $self->controller_args );
		}
		return ProPortal::Controller::Base->new();
	},

	handles => [ qw( set_filters filters ) ]

);

# sub _build_controller {
# 	say 'Running build controller!';
# #	say 'args: ' . Dumper( \@_ );
# 	return ProPortal::Controller::Base->new();
# }

sub BUILD {
	my ( $self, $args ) = @_;
	say 'running controller BUILD!';
#	say 'self: ' . $self;
#	say 'args: ' . Dumper $args;
	# is this for Galaxy modules?
	if ( $args->{controller_role} ) {
		say 'found a controller role!';
		$self->add_controller_role( $args->{controller_role} );
	}
	$self->controller->_core( $self );
#	say 'post BUILD self: ' . Dumper $self;
}

sub add_controller {
	my $self = shift;
	say 'running add_controller';
#	confess 'caller: ' . caller;
	my $class = $self->_prepare_controller( @_ );
#	if ( $class !~ /Controller/ ) {
#		$class = ProPortal::Util::Factory::_rename( 'Controller', $class );
#	}
#	IMG::Util::Factory::load_module( $class );
	$self->_set_controller( $class );
	$self->controller->_core( $self );
	if ( $self->controller->can('controller_args') ) {
		$self->_set_controller( $self->controller->controller_args );
	}
	return $self;
}


sub add_controller_role {
	my $self = shift;
	say 'running add_controller_role';
	my $role = $self->_prepare_controller( @_ );
#	if ( $role !~ /Controller/ ) {
#		$role = ProPortal::Util::Factory::_rename( 'Controller', $role );
#	}
#	IMG::Util::Factory::load_module( $role );

	Role::Tiny->apply_roles_to_object( $self, $role );

	say 'self now: ' . Dumper $self;

	if ( $self->controller_args ) {
		$self->_set_controller( $self->controller_args );
	}
	$self->controller->_core( $self );
#	say 'self now: ' . Dumper $self;

	return $self;
}


sub _prepare_controller {
	my $self = shift;
	my $module = shift;
	if ( $module !~ /Controller/ ) {
		$module = ProPortal::Util::Factory::_rename( 'Controller', $module );
	}
	IMG::Util::Factory::load_module( $module );
	return $module;
}

1;

package IMG::App::Role::Controller;

use IMG::Util::Base 'MooRole';
use ProPortal::Util::Factory;
use ProPortal::Controller::Base;
use Scalar::Util qw( blessed );
#use Dancer2;

has 'controller' => (
	is => 'rwp',
	lazy => 1,
	predicate => 1,
	coerce => sub {
#		say 'running coerce controller';
#		say Dumper \@_;
		# allow objects to be passed in
		if ( @_ ) {

			if ( 1 == scalar @_ ) {

#				say 'one arg only';

				if ( blessed $_[0] ) {
#					say 'I am blessed!';
					return shift;
				}
				elsif ( ! ref $_[0] ) {

#					say 'Got the name of the module to load!';
					# must be a class, not a role
					IMG::Util::Factory::load_module( $_[0] );
					return +shift->new()
				}
				else {
#					say 'Got a hashref with keys ' .  join ", ", keys %{$_[0]};
					my $href = shift;
					if ( $href->{class} ) {
						my $class = $href->{class};
						IMG::Util::Factory::load_module( $class );
#						say 'Class: ' . $class;
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
#		say 'running controller default';
#		say Dumper \@_;

		my $self = shift;
		if ( $self->can( 'controller_args' ) ) {
#			say 'I can controller args! ' . Dumper $self->controller_args;

			return $self->_set_controller( $self->controller_args );
		}
		return ProPortal::Controller::Base->new();
	},

	handles => [ qw( set_filters filters add_defaults_and_render ) ]

);

sub _build_controller {
#	say 'Running build controller!';
#	say 'args: ' . Dumper( \@_ );
	return ProPortal::Controller::Base->new();
}

sub BUILD {
#	say 'running BUILD!';
#	say 'args: ' . Dumper \@_;
	my ($self, $args) = @_;
	if ( $args->{controller_role} ) {
		$self->add_controller_role( $args->{controller_role} );
	}

}

sub add_controller_role {
	my $self = shift;
	my $role = shift;
	if ( $role !~ /Controller/ ) {
		$role = ProPortal::Util::Factory::_rename( 'Controller', $role );
	}

	IMG::Util::Factory::load_module( $role );

	Role::Tiny->apply_roles_to_object( $self, $role );

#	say 'controller args: ' . Dumper $self->controller_args;

# if ( $self->controller_args ) {
# 	$self->_set_controller( $self->controller_args );
# }

	return $self;
}

1;

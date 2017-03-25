package SessionParamRole;

use IMG::Util::Import 'MooRole';

sub param {
	my $self = shift;
	if ( scalar @_ == 2 ) {
		return $self->write( @_ );
	}
	return $self->read( @_ );
}

1;


package ProPortalPackage;

use IMG::Util::Import 'Class';

our $VERSION = 0.1.0;

use IMG::App::CurrentQuery;

extends 'IMG::App';
with ( qw(
	ProPortal::Views::ProPortalMenu
	IMG::App::Role::MenuManager
	ProPortal::IO::DBIxDataModel
	ProPortal::IO::ProPortalFilters
	IMG::App::Role::Controller
) );


has 'current_query' => (
	is => 'rwp',
	clearer => 1,
	coerce => sub {
		return IMG::App::CurrentQuery->new( @_ );
	}
);

sub init_current_query {
	my $self = shift;
	my $app = shift;
	$self->clear_current_query;
	$self->clear_controller;
	$self->_set_current_query({ _core => $self });
	$self->_set_app( $app );
	log_debug { 'session: ' . $self->session };
}

has 'app' => (
	is => 'rwp',
	lazy => 1
);

has '+session' => (
	is => 'lazy',
	builder => 1
);

sub _build_session {
	my $sess = shift->app->session;
	Moo::Role->apply_roles_to_object( $sess, qw(SessionParamRole) );

#	log_debug { Dumper $sess };

	return $sess;
}

1;

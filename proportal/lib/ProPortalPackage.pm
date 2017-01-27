package ProPortalPackage;

use IMG::Util::Import 'Class';

our $VERSION = 0.1.0;

extends 'IMG::App';
with ( qw(
	ProPortal::Views::ProPortalMenu
	IMG::App::Role::MenuManager
	ProPortal::IO::DBIxDataModel
	ProPortal::IO::ProPortalFilters
	IMG::App::Role::Controller
) );

has 'app' => (
	is => 'rwp',
	lazy => 1
);

has '+session' => (
	is => 'rwp',
	lazy => 1,
	default => sub {
		say 'getting session!';
		return $_[0]->app->{session};
	}
);

1;

{
	package ScriptAppArgs;
	use IMG::Util::Import 'Class';
#	use IMG::App::Role::ErrorMessages qw( err );
	with qw[
		IMG::App::Role::ErrorMessages
	];

	has 'email' => (
		is => 'ro',
		required => 1
	);

	has 'output_dir' => (
		is => 'ro',
		required => 1,
		isa => sub {
			return if -d $_[0] && -w $_[0];
			die err({
				err => 'not_writable',
				subject => $_[0],
			});
		}
	);

	has 'test_mode' => (
		isa => Bool,
		is => 'lazy',
	);

	1;

}

package ProPortal::App::ImportWorkspace;

use IMG::Util::Import 'Class';
use ScriptAppArgs;
use IMG::App::Role::ErrorMessages qw( err );
extends 'IMG::App';
use IMG::Util::File;
with qw(
	ProPortal::IO::DBIxDataModel
	ProPortal::Controller::PhyloViewer::Pipeline
	IMG::Util::ScriptApp
);

sub run {
	my $self = shift;
	my $args = shift;

	# set the user
	my $user_h = $self->get_db_contact_data({ email => $self->args->email });
	$self->_set_user( $user_h );

	my $wkspc = $self->get_workspace_dirname()

	# recapitulate wkspc files in the history item.
	my @dirs = get_dir_contents({ dir => $wkspc, filter => sub { -d $_ } });

}

1;

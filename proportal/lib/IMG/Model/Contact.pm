package IMG::Model::Contact;

use IMG::Util::Import 'Class';
use Scalar::Util qw( blessed );
use Acme::Damn;
with 'IMG::App::Role::ErrorMessages';

# Required attributes
my @reqd = qw( contact_oid name email );

# optional attributes
my @opt = qw( username super_user img_editor img_group role jgi_session_id caliban_user_name caliban_id );

has $_ => ( is => 'ro', lazy => 1, writer => 'set_' . $_, required => 1 ) for @reqd;

has $_ => ( is => 'ro', lazy => 1, writer => 'set_' . $_, predicate => 1 ) for @opt;

has 'edit_levels' => (
	is => 'lazy',
	predicate => 1,
	isa => ArrayRef[Maybe[Str]],
	coerce => sub {
		( $_[0] ) ? [ split " ", $_[0] ] : [];
	},
	init_arg => 'img_editing_level',
);

=head3 can_edit

Can this user edit $this?

if ( $user->can_edit('gene-term') ) {
	...
}

@param  $lvl  The edit level

@return undef if the user can't edit that
        1     if the user can edit

=cut

sub can_edit {
	my $self = shift;
	my $lvl = shift || $self->choke({ err => 'missing', subject => 'edit level' });
	return undef unless $self->has_edit_levels;
	return grep { $lvl eq $_ } @{$self->edit_levels};
}

sub is_superuser {
	my $self = shift;
	return 1 if $self->has_super_user && 'Yes' eq $self->super_user;
	return 0;
}

sub is_super_user {
	return shift->is_superuser;
}

sub is_editor {
	my $self = shift;
	return 1 if $self->has_img_editor && 'Yes' eq $self->img_editor;
	return 0;
}

sub BUILDARGS {
	my $class = shift;
	my $args = ( @_ && 1 < scalar( @_ ) ) ? { @_ } : shift || {};

	if ( $args->{db_data} || $args->{user_data} ) {

		my %new = %{ $args->{db_data} || {} };
		if ( $args->{user_data} ) {
			$new{jgi_session_id} = $args->{user_data}{id};
			$new{caliban_id} = $args->{user_data}{user}{contact_id};
			$new{caliban_user_name} = $args->{user_data}{user}{login};
		}

		for (keys %new) {
			delete $new{$_} unless defined $new{$_};
		}
		return \%new;
	}

	# DB object
	if ( blessed ($args) ) {
		my $a_h = damn $args;
		for (keys %$a_h) {
			delete $a_h->{$_} unless defined $a_h->{$_};
		}
		return $a_h;
	}

	# do nothing if it's a hashref
	return $args;
}


=cut

img-gold hmp-user
gene-term img-pathway
img-submit
hmp-user
img-gold
img-bin
img-gold img-submit img-bin

=cut

1;



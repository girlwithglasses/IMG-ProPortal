###########################################################################
#
# $Id: User.pm 34501 2015-10-13 23:40:50Z aireland $
#
############################################################################
package IMG::App::Role::User;

use IMG::Util::Base 'MooRole';

use DBI;
use JSON;
use IMG::Model::Contact;
use IMG::Util::File;

use DataModel::IMG_Core;
use DataModel::IMG_Gold;

requires 'config', 'schema';

has 'user' => (
	is => 'ro',
	writer => 'set_user',
);

=head3 get_db_contact_data

get user data from IMG Core

@param  $caliban_id     user ID on the JGI Caliban system

@return   die if no database connection
          contact data from IMG_Core if available
          undef if user not found in DB

=cut

sub get_db_contact_data {
	my $self = shift;
	my $caliban_id = shift // die "No Caliban ID supplied";

	my @cols = qw( contact_oid username name super_user email img_editor img_group img_editing_level );

	my $sth = $self->schema('img_core')->table('Contact')
		->select(
			-columns  => [ @cols ],
			-where    => { caliban_id  => $caliban_id },
			-result_as => 'sth'
		);

	my $user = $sth->fetchall_arrayref();

	die 'Found ' . ( scalar @$user ) . ' users with caliban ID ' . $caliban_id if scalar @$user != 1;

	# return user data as a hash:
	my %user_h;
	@user_h{ @cols } = @{$user->[0]};
	return \%user_h;
}

=head3 check_banned_users

Check that names and email addresses don't appear in the cancelled users table

@param  array of name and email addresses to check

@return   die with error if no db connection
          die with 403 if user account is locked
          do nothing if user is OK
=cut

sub check_banned_users {
	my $self = shift;
	my @names = map { lc( $_ ) } grep { defined $_ && /\w+/ } @_;
	die "No user names or emails supplied" unless @names;
	my %uniq;
	undef @uniq{ @names };
	die "No user names or emails supplied" unless scalar keys %uniq;

	my $losers = $self->schema('img_gold')->table('CancelledUser')
		->select(
			-where =>
			[
				'lower(username)' => [ keys %uniq ],
				'lower(email)'    => [ keys %uniq ],
			],
			-columns => [ qw( username email ) ],
			-result_as => 'flat_arrayref'
		);


	if ( @$losers ) {
		die {
			status  => 403,
			title   => 'Access denied',
			message => 'Your account has been locked. If you believe this is an error, please email us at <a href="mailto:imgsupp@lists.jgi-psf.org">imgsupp@lists.jgi-psf.org</a>.',
		};
	}

	return;
}

1;

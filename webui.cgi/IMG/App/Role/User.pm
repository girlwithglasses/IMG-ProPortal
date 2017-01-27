###########################################################################
#
# $Id: User.pm 36523 2017-01-26 17:53:41Z aireland $
#
############################################################################
package IMG::App::Role::User;

use IMG::Util::Import 'MooRole';
use Acme::Damn;

with 'IMG::App::Role::ErrorMessages';

requires 'user', 'config', 'schema', 'choke';

=head3 get_db_contact_data

get user data from IMG Core

@param  $args   hashref with key

caliban_id    user ID on the JGI Caliban system OR other unique parameter
email         email address on Caliban

username <-- is this unique?

@return   die if no database connection
          contact data from IMG_Core if available
          undef if user not found in DB

=cut

sub get_db_contact_data {
	my $self = shift;
	my $args = shift;
	if ( ! keys %$args ) {
		$self->choke({ err => 'missing', subject => "identifier for contact" });
	}

	my $pass;
	my @valid = qw( caliban_id contact_oid email );

	for ( @valid ) {
		$pass++ if defined $args->{$_};
	}

	if (! $pass ) {
		$self->choke({
			err => 'invalid_enum',
			type => 'identifier for contact',
			subject => join( ", ", keys %$args ),
			enum => [ @valid ]
		});
	}

	my $users = $self->run_query({
		query => 'user_data',
		where => $args
	});

	if ( ! scalar @$users ) {
		$self->choke({
			err => 'no_results',
			subject => 'users',
		});
	}

	if ( 1 != scalar @$users ) {

		## This is a seriously weird error!
		## LOG THIS!



		$self->choke({
			subject => 'users with matching user IDs',
			err => 'unexpected',
			msg => 'expected one result, but got ' . scalar( @$users )
		});

	}

	# return user data as a hash:
	my $hash = damn $users->[0];
	delete $hash->{__schema};
	return $hash;
}

=head3 check_banned_users

Check that names and email addresses don't appear in the cancelled users table

@param  $args  hashref of args with keys

	test => [ 'email@home.com', 'Carmen Sandiego', 'carmen@broderbund.net' ]
				# array of name and email addresses to check

@return 	die with error if no db connection
			die with 403 if user account is locked
			do nothing if user is OK
=cut

sub check_banned_users {
	my $self = shift;
	my $args = shift;
	my @names;

	if ( $args->{test} ) {
		@names = map { $_ = lc( $_ ) } grep { defined $_ && /\w+/ } @{$args->{test}};
	}

	$self->choke({
		err => 'missing',
		subject => 'user names or emails'
	}) if ! $args->{test} || ! scalar @names;

	my %uniq;
	undef @uniq{ @names };

	my $losers = $self->run_query({
		query => 'banned_users',
		where =>
		[	'lower(username)' => [ keys %uniq ],
			'lower(email)'    => [ keys %uniq ],
		],
	});

	if ( scalar @$losers ) {
		die {
			status  => 403,
			title   => 'Access denied',
			message => $self->make_message({ err => 'acc_locked' }),
		};
	}

	return;
}

1;

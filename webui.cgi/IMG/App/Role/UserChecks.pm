###########################################################################
#
# $Id: UserChecks.pm 35833 2016-07-06 02:42:03Z aireland $
#
###########################################################################
package IMG::App::Role::UserChecks;

use IMG::Util::Base 'MooRole';
use IMG::Model::Contact;

requires 'config', 'session', 'check_jgi_session', 'get_jgi_user_json', 'get_db_contact_data';

=head3 run_user_checks

Ensure that the user is valid

@param  $u_id   user ID

=cut

sub run_user_checks {
	my $self = shift;
	my $u_id = shift || $self->choke({ err => 'missing', subject => 'user ID' });

	# ping the server
	my $user_data = $self->get_jgi_user_json( $u_id );

	say 'got user data... continuing with my work!';

	my $db_data = $self->get_db_contact_data({ caliban_id => $user_data->{user}{id} });

	# this will die if all is not well
	if ( ! $self->has_session || ! $self->session->read('banned_checked') ) {
		$self->check_banned_users({
			test => [ $db_data->{email}, $user_data->{user}{email_address}, $db_data->{username} ]
		});
	}

	##	merge user and db data:
	my %new = %$db_data;
	if ( %$user_data ) {
		$new{jgi_session_id} = $user_data->{id};
		$new{caliban_id} = $user_data->{user}{contact_id};
		$new{caliban_user_name} = $user_data->{user}{login};
	}

	for (keys %new) {
		delete $new{$_} unless defined $new{$_};
	}

	# create a user object
#	my $user = IMG::Model::Contact->new({ db_data => $db_data, user_data => $user_data });
#	$self->_set_user( $user );
	$self->_set_user( %new );

	return { db_data => $db_data, user_data => $user_data };

=cut
	# set up session params
	session 'contact_oid'       => $q->[0];
	session 'username'          => $q->[1];
	session 'super_user'        => $q->[2];
	session 'name'              => $q->[3];
	session 'email'             => $q->[4];
	session 'jgi_session_id'    => $user_data->{id};
	session 'caliban_id'        => $user_data->{user}{contact_id};
	session 'caliban_user_name' => $user_data->{user}{login};
	session 'banned_checked'    => 1;
=cut


}

requires 'read_file';

=head3 load_user_preferences

Load user preferences from a saved file and save them in the session

=cut

sub load_user_preferences {
	my $self = shift;
	# load prefs into the session
	local $@;
	my $p_hash = eval { $self->read_file('prefs'); };
	return if $@;
	if ( $p_hash && %$p_hash ) {
		for ( keys %$p_hash ) {
		#	session $_ => $p_hash->{$_};
			$self->session->write( $_ => $p_hash->{$_} );
		}
	}
	return;
}


requires 'get_dirname';

=head3 touch_cart_files

Touch the user's cart files so they don't get purged

=cut

sub touch_cart_files {
	my $self = shift;

	my $cart_dir = $self->get_dirname('cart');
	if ( -e $cart_dir ) {
		# touch the cart
		my @carts = qw( gene genome scaf func cura );

		# cura carts are only on user-restricted sites
		if (! $self->config->{user_restricted_site} ) {
			pop @carts;
		}

		for my $f ( map { $_ . '_cart_state' } @carts ) {
			# touch the file (if it exists)
			$self->touch( $f );
			my $contents = eval { $self->read_file( $f ); };
			if ( $contents ) {
				# do something with this data?
				if ('func_cart_state' eq $f) {
					$self->session->write( $f, scalar keys %{$contents->{recs}} );
				}
				else {
					$self->session->write( $f, scalar @$contents );
				}
			}
		}

		$self->touch( 'gene_cart_col_ids' );

	}
	# autocreate the cart directory?
}

=cut
	require WebUtil;
	require GeneCartStor;
	require FuncCartStor;
	require ScaffoldCart;
	require GenomeCart;
	require CuraCartStor;

	# session dir = $env->{cgi_tmp_dir} / $sess_id
	# cart dir = session_dir/Cart
	my $c_dir = WebUtil::getCartDir();

#	my ( $cartDir, $sessionId ) = WebUtil::getCartDir;
	WebUtil::fileTouch($c_dir);

	my %c_types = (
		FuncCartStor => 'functions',
		GeneCartStor => 'genes',
		GenomeCart   => 'genomes',
		ScaffoldCart => 'scaffolds',
	);

	my %cart;
	for my $c ( keys %c_types ) {
		my $f = $c->getStateFile;
		if ( -e $f ) {
			# read file, count number of lines
			my $lines = IMG::Util::File::file_to_array( $f );
			$cart{ $c_types{ $c } } = scalar @$lines;
		}
	}
	if ( $self->config->{user_restricted_site} ) {
		my $file = CuraCartStor::getStateFile();
		WebUtil::fileTouch($file) if -e $file;
	}
	my $gf = GenomeCart::getColIdFile();
	WebUtil::fileTouch($gf) if -e $gf;

	say "cart looks like this: " . Dumper \%cart;
	return \%cart;
=cut


1;

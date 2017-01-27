############################################################################
#	IMG::App::Cart.pm
#
#	Interface to the various carts
#
#	$Id: Cart.pm 34542 2015-10-20 20:56:35Z aireland $
############################################################################
package IMG::App::Cart;

use IMG::Util::Import 'MooRole';

requires 'config', 'session';

sub BUILDARGS {
	my $class = shift;
	my $args = ( @_ && 1 < scalar( @_ ) ) ? { @_ } : shift;
	return $args || {};
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

=head3 get_contents( $cart )

Get the current contents of the specified cart

	my $gp_list = $self->cart->get_contents('gene');

=cut

sub get_contents {
	my $self = shift;
	my $cart = shift;

	my $state_file = $cart . '_cart_state';

	my $contents = eval { $self->read_file( $state_file ); };
	if ( $contents ) {
		# what state is this data in?




		return $contents;
	}
}

sub get_gene_cart_contents {
	my $self = shift;

	local $@;

	my $hdrs = eval { $self->read_file( 'gene_cart_col_ids' ); };
	my $contents = eval { $self->read_file( 'gene_cart_state' ); };

	if ( $@ ) {
		say 'errors: ' . $@;
		$self->choke({


		});
	}

	say 'hdrs: ' . Dumper $hdrs;
	say 'contents: ' . Dumper $contents;

	if ( $hdrs && $contents ) {

	}

}

1;

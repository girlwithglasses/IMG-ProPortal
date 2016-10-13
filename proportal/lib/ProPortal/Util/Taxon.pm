package ProPortal::Util::Taxon;

use IMG::Util::Base 'MooRole';

requires 'config', 'run_query', 'choke';

=head3 get_taxon_data

Given a taxon ID, gets the taxon display name and checks whether the taxon is public or not

@param  $args               hashref of arguments, including

    taxon_oid => 12345678 (optional; uses $self->taxon_oid otherwise)

@return hashref of taxon data

=cut

sub get_taxon_data {
	my $self = shift;
	my $args = shift // {};

	if ( ! $args->{taxon_oid} ) {
		$args->{taxon_oid} = $self->taxon_oid // $self->choke({
			err => 'missing',
			subject => 'taxon_oid'
		});
	}

	my $results = $self->run_query({
		query => 'taxon_name_public',
		where => {
			taxon_oid => $args->{taxon_oid},
		}
	});

#	say 'results: ' . Dumper $results;

	if ( scalar @$results ) {
		if ( $results->[0]->{is_public} ne 'Yes' ) {
			# dies if there is a permissions error
			$self->check_taxon_permissions({ taxon_oid => $args->{taxon_oid} });
		}
		return $results->[0];
	}

	$self->choke({
		err => 'invalid',
		subject => $args->{taxon_oid},
		type => 'taxon_oid'
	});

}

=head3 check_taxon_permissions

Check the permissions for a non-public taxon

NOTE: ASSUMES THAT THE TAXON IS NOT PUBLIC!

@param  $args               hashref of arguments, including

    taxon_oid => 12345678 (optional)
    uses $self->taxon_oid otherwise

	requires that $self->user be populated

@return dies with a private data error if the user does not have permission to view data
        returns if the user can view the data

=cut

sub check_taxon_permissions {
	my $self = shift;
	my $args = shift // {};

	if ( ! $self->can('user') || ! $self->has_user ) {
		# no user logged in
		$self->choke({
			err => 'private_data',
		});
	}

	my $results = $self->run_query({
		query => 'taxon_permissions_by_contact_oid',
		where => {
			taxon_permissions => $args->{taxon_oid} // $self->taxon_oid,
			contact_oid => $self->user->contact_oid
		}
	});

	if ( ! scalar @$results ) {
		$self->choke({
			err => 'private_data'
		});
	}

	return 1;
}

1;

package ProPortal::Controller::Details::Scaffold;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Filtered';

with 'IMG::Model::DataManager';

has '+page_id' => (
	default => 'details/scaffold'
);

has '+page_wrapper' => (
	default => 'layouts/default_wide.tt'
);

has '+filter_domains' => (
	default => sub {
		return [ qw( scaffold_oid ) ];
	}
);

=head3 render

Details page for a scaffold

@param scaffold_oid

=cut

sub _render {
	my $self = shift;

	return { results => { scaffold => $self->get_data( @_ ) } };
}

sub get_data {
	my $self = shift;
	my $args = shift;

	if ( ! $args || ! $args->{scaffold_oid} ) {
		$self->choke({
			err => 'missing',
			subject => 'scaffold_oid'
		});
	}

	my $res = $self->_core->run_query({
		query => 'scaffold_details',
		where => $args
	});

	if ( scalar @$res != 1 ) {
		$self->choke({
			err => 'no_results',
			subject => 'IMG scaffold ' . ( $args->{scaffold_oid} || 'unspecified' )
		});
	}
	$res = $res->[0];

	my $associated = {
		multi => [ qw(
			gene_cog_groups
			gene_img_interpro_hits
			gene_kog_groups
			gene_seed_names
			gene_tc_families
			gene_tigrfams
		)],
		single => [ qw(
			scaffold_stats
		)]
#			genes # too big!

# 			bin_scaffolds
# 			gene_cassettes
# 			gene_cassette_panfolds
#
# 			scaffold_ext_links
# 			scaffold_intergenics
# 			scaffold_misc_bindings
# 			scaffold_misc_features
# 			scaffold_notes
# 			scaffold_nx_features
# 			scaffold_panfold_compositions
# 			scaffold_repeats
# 			scaffold_sig_peptides
	};

	for my $type ( %$associated ) {
		for my $assoc ( @{ $associated->{$type} } ) {
			log_debug { 'looking at ' . $assoc };

			if ( $res->can( $assoc ) ) {
				my $r = $res->$assoc;
				if ($r
					&& ( ( 'multi' eq $type && scalar @$r )
					|| ( 'single' eq $type && defined $r ) )
					) {
					$res->{$assoc} = $r;
				}
			}
		}
	}
	return $res;

}

sub examples {
	return [{
		url => '/details/scaffold/$img_scaffold_oid',
		desc => 'metadata for scaffold <var>$img_scaffold_oid</var>'
	},{
		url => '/details/scaffold/640069311',
		desc => 'metadata for scaffold IMG:640069311, NC_008819 from <i>Prochlorococcus marinus</i> str. NATL1A'
	}];
}

1;

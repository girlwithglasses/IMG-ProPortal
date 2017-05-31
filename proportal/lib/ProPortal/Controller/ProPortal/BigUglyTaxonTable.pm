package ProPortal::Controller::ProPortal::BigUglyTaxonTable;

use IMG::Util::Import 'Class'; #'MooRole';

use Template::Plugin::JSON::Escape;

extends 'ProPortal::Controller::Filtered';
with 'ProPortal::Controller::Role::Paged',
'ProPortal::Controller::Role::TableHelper';

has '+page_id' => (
	default => 'proportal/big_ugly_taxon_table'
);

has '+tmpl_includes' => (
	default => sub {
		return {
			tt_scripts => qw( big_ugly_taxon_table ),
		};
	}
);

has '+filter_domains' => (
	default => sub {
		return [ qw( pp_subset dataset_type ) ];
	}
);


=head3 render

Get all the VwGoldTaxon table data

=cut

sub _render {
	my $self = shift;

#	my $stt2 = $self->get_data;
#	my $sth = $stt2->select( -result_as => 'sth' );
#	$self->_set_table_cols( $sth->{NAME_lc} );

	my $total = $self->get_data->row_count;
	$self->_set_n_results( $total );

	my $stt = $self->page_me( $self->get_data );
	my $res = $stt->all;

	return { results => {
		js => {
			arr => $res,
			table_cols => [ grep { $_ ne '__schema' } sort keys %{$res->[0]} ],
		},
		paging => $self->paging_helper
	} };

}

sub get_data {
	my $self = shift;
#	return decode_json <DATA>;
	return $self->_core->run_query({
		query => 'taxon_metadata',
		filters => $self->filters,
		-result_as => 'statement',
	});
}

1;

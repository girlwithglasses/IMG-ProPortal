package ProPortal::Controller::ProPortal::Phylogram;

use IMG::Util::Import 'Class';#'MooRole';

extends 'ProPortal::Controller::Filtered';

with 'ProPortal::Util::DataStructure';

use Template::Plugin::JSON::Escape;

has '+page_id' => (
	default => 'proportal/phylogram'
);

has '+filters' => (
	default => sub {
		return { pp_subset => 'pp_isolate' };
	}
);

has '+valid_filters' => (
	default => sub {
		return {
			pp_subset => {
				enum => [ qw( pro syn pro_phage syn_phage other other_phage pp_isolate ) ],
			}
		};
	}
);

has '+tmpl_includes' => (
	default => sub {
		return { tt_scripts => qw( phylogram ) };
	}
);

=head3 render

Phylogram query

=cut

sub _render {
	my $self = shift;

	my $stt = $self->get_data;

	my $res;
	my $data;
	my $count;
	while ( my $row = $stt->next ) {
		push @$res, $row;
		push @{ $data->{ $row->{genome_type} }
			{ $row->domain   || 'unclassified' }
			{ $row->phylum   || 'unclassified' }
			{ $row->class || 'unclassified' }
			{ $row->order || 'unclassified' }
			{ $row->family   || 'unclassified' }
			{ $row->{genus}    || 'unclassified'}
			{ $row->{clade}    || 'unclassified' } },
			{ name => $row->{taxon_display_name}, data => $row };
		$count++;
	}

	my $tree;
	if ( 1 == scalar keys %$data ) {
		$tree = { name => ( keys %$data )[0], children => $self->make_tree( ( values %$data )[0] ) };
	}
	else {
		$self->choke({ err => 'full_data_disabled' });
	}

	return { results => {
		array => $res,
		js => {
			arr => $res,
			count => $count,
			tree => $tree,
			class_types => [ qw( genome_type domain phylum class order family genus clade species ) ],
			table_cols => [ 'cbox_taxon',
			'taxon_oid', 'taxon_display_name', 'domain', 'phylum', 'class', 'order', 'family', 'genus', 'clade', 'pp_subset' ]

		}
	} };

}

sub get_data {
	my $self = shift;
	return $self->_core->run_query({
		query => 'phylogram',
		filters => $self->filters,
		-result_as => 'statement'
	});
}

1;

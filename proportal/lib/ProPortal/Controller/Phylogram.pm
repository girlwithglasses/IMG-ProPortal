package ProPortal::Controller::Phylogram;

use IMG::Util::Import 'Class';#'MooRole';

extends 'ProPortal::Controller::Filtered';

with 'ProPortal::Util::DataStructure';

use Template::Plugin::JSON::Escape;

has '+page_id' => (
	default => 'proportal/phylogram'
);

has '+filters' => (
	default => sub {
		return { pp_subset => 'isolate' };
	}
);

has '+valid_filters' => (
	default => sub {
		return {
			pp_subset => {
				enum => [ qw( pro syn pro_phage syn_phage other other_phage isolate ) ],
			}
		};
	}
);



=head3 render

Phylogram query

=cut

sub _render {
	my $self = shift;

	my $res = $self->get_data();

	my $data;
	my $count;
	for ( @$res ) {
		$count++;
		push @{ $data->{ $_->{genome_type} }
			{ $_->{domain}   || 'unclassified' }
			{ $_->{phylum}   || 'unclassified' }
			{ $_->{ir_class} || 'unclassified' }
			{ $_->{ir_order} || 'unclassified' }
			{ $_->{family}   || 'unclassified' }
			{ $_->{genus}    || 'unclassified'}
			{ $_->{clade}    || 'unclassified' } }, { name => $_->{taxon_display_name}, data => $_ };
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
			count => $count,
			tree => $tree,
			class_types => [ qw( genome_type domain phylum class order family genus clade species ) ],
		}
	} };

}

sub get_data {
	my $self = shift;
	return $self->_core->run_query({
		query => 'phylogram',
		filters => $self->filters,
	});
}

1;

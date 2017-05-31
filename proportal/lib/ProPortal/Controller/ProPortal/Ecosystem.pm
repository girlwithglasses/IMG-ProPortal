package ProPortal::Controller::ProPortal::Ecosystem;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Filtered';

with 'ProPortal::Util::DataStructure';

use Template::Plugin::JSON::Escape;

has '+page_id' => (
	default => 'proportal/ecosystem'
);

has '+tmpl_includes' => (
	default => sub {
		return { tt_scripts => qw( ecosystem ) };
	}
);

=head3 render

Ecosystem query

=cut

sub _render {
	my $self = shift;

	my $res = $self->get_data->all;
	if ( ! $res || ! scalar @$res ) {
		$self->choke({
			err => 'no_results',
		});
	}

	my $class_type_h;
	my @class_types = qw( all ecosystem ecosystem_category ecosystem_type ecosystem_subtype specific_ecosystem taxon );
	my $n = 0;
	for ( @class_types ) {
		( $class_type_h->{ $n++ } = $_ ) =~ s/_/ /g;
	}

	pop @class_types;
	shift @class_types;
	my $data;

	for my $r ( @$res ) {
		push @{$data->{ $r->{ecosystem} || 'Unclassified' }
			{ $r->{ecosystem_category} || 'Unclassified' }
			{ $r->{ecosystem_type} || 'Unclassified' }
			{ $r->{ecosystem_subtype} || 'Unclassified' }
			{ $r->{specific_ecosystem} || 'Unclassified' } }, {
				name => $r->{taxon_display_name},
				data => $r
			};
	}

	my $tree = { name => 'all', path => 'all', children => $self->make_tree_with_path( $data, 'all' ) };

	return { results => {
		class_types => \@class_types,
		array => $res,
		js => {
			class_type_h => $class_type_h,
			tree => $tree,
			arr => $res,
			table_cols => [ 'cbox_taxon', 'taxon_oid', 'taxon_display_name', 'ecosystem', 'ecosystem_category', 'ecosystem_type', 'ecosystem_subtype', 'specific_ecosystem', 'pp_subset' ]
		}
	} };
}

sub get_data {
	my $self = shift;
	return $self->_core->run_query({
		query => 'ecosystem',
		filters => $self->filters,
		-result_as => 'statement'
	});
}

1;

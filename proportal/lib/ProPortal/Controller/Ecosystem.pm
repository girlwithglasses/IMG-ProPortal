package ProPortal::Controller::Ecosystem;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Filtered';

with 'ProPortal::Util::DataStructure';

use Template::Plugin::JSON::Escape;

# has 'controller_args' => (
# 	is => 'lazy',
# 	default => sub {
# 		return {
# 			class => 'ProPortal::Controller::Filtered',
# 			tmpl => 'pages/proportal/ecosystem.tt',
# 			tmpl_includes => {
#     			tt_scripts => qw( ecosystem ),
# 	    	}
# 		};
# 	}
# );
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

	my $res = $self->get_data();
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
		push @{$data->{ $r->{ecosystem} }
			{ $r->{ecosystem_category} }
			{ $r->{ecosystem_type} }
			{ $r->{ecosystem_subtype} }
			{ $r->{specific_ecosystem} } }, {
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
		}
	} };
}

sub get_data {
	my $self = shift;
	return $self->_core->run_query({
		query => 'ecosystem',
		filters => $self->filters,
	});
}

1;

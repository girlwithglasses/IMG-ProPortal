package ProPortal::Controller::ProPortal::Clade;

use IMG::Util::Import 'Class'; #'MooRole';

use Template::Plugin::JSON::Escape;

extends 'ProPortal::Controller::Filtered';

with 'IMG::Util::Text';

has '+page_id' => (
	default => 'proportal/clade'
);

has '+tmpl_includes' => (
	default => sub {
		return {
			tt_scripts => qw( clade ),
		};
	}
);

has '+filters' => (
	default => sub {
		return { pp_subset => 'coccus' };
	}
);

has '+valid_filters' => (
	default => sub {
		return {
			pp_subset => {
				enum => [ qw( pro syn coccus ) ]
			}
		};
	}
);

=head3 render

Requires JSON plugin for rendering data set

=cut
sub _render {
	my $self = shift;

	my $stt = $self->get_data;
	my $arr = $stt->all;

	return { results => {
		js => {
			arr => $arr,
			total => scalar @$arr,
			table_cols => [ 'cbox_taxon', 'taxon_oid', 'taxon_display_name', 'generic_clade', 'clade', 'ecotype', 'pp_subset' ],
		}
	} };

}

sub get_data {
	my $self = shift;
	return $self->_core->run_query({
		query => 'clade',
		filters => $self->filters,
		-result_as => 'statement'
	});
}

1;


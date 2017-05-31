package ProPortal::Controller::JBrowse;

use IMG::Util::Import 'Class';#'MooRole';

has '+page_id' => (
	default => 'jbrowse'
);

# has '+filters' => (
# 	default => sub {
# 		return { pp_subset => 'pp_isolate' };
# 	}
# );
#
# has '+valid_filters' => (
# 	default => sub {
# 		return {
# 			pp_subset => {
# 				enum => [ qw( pro syn pro_phage syn_phage other other_phage pp_isolate ) ],
# 			}
# 		};
# 	}
# );



=head3 render

Phylogram query

=cut

sub _render {
	my $self = shift;

	return { data_dir => '/jbrowse_assets/data_dir/' . $taxon_oid, taxon_oid => $taxon_oid };

}

sub get_data {
	my $self = shift;

}

1;

package ProPortal::Controller::Details::File;

use IMG::Util::Import 'Class';#'MooRole';

extends 'ProPortal::Controller::Filtered';

use Template::Plugin::JSON::Escape;
use IO::All;

has '+page_wrapper' => (
    default => 'layouts/default_wide.tt'
);

has '+page_id' => (
	default => 'details/file'
);

# has '+valid_filters' => (
# 	default => sub {
# 		return {
# 			pp_subset => {
# 				enum => [ qw( pro pro_phage syn syn_phage other other_phage isolate metagenome all_proportal ) ]
# 			},
# 			dataset_type => {
# 				enum => [ qw( isolate single_cell metagenome transcriptome metatranscriptome ) ]
# 			},
# 		};
# 	}
# );

=head3 taxon type



=cut

sub _render {
	my $self = shift;

	return $self->get_data( @_ );
}


sub get_data {
	my $self = shift;
	my $args = shift;

	if ( ! $args || ! $args->{taxon_oid} || ! $args->{file_type} ) {
		$self->choke({
			err => 'missing',
			subject => 'taxon_oid or file_type'
		});
	}

	my $f = $self->_core->get_taxon_file({
		type => $args->{file_type},
		taxon_oid => $args->{taxon_oid}
	});

	if ( IMG::Util::File::is_readable( $f ) ) {

		# check the user has permission to get the file
		my $results = $self->_core->run_query({
			query => 'taxon_name_public',
			where => {
				taxon_oid => $args->{taxon_oid}
			}
		});

		if ( scalar @$results > 0 && $results->[0]->{viewable} ne 'private' ) {
			return $f;
		}
		# dies if there is a permissions error
		$self->choke({
			err => 'private_data'
		});

	}

}

1;

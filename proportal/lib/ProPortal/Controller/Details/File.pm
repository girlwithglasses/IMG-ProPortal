package ProPortal::Controller::Details::File;

use IMG::Util::Import 'Class';

extends 'ProPortal::Controller::Base';

has '+page_wrapper' => (
    default => 'layouts/default_wide.tt'
);

has '+page_id' => (
	default => 'details/file'
);

# required params: taxon_oid, file_type

sub _render {
	my $self = shift;

	return $self->get_data( @_ );
# 	if ( 'success' eq $self->status ) {
# 		return $self->results;
# 	}
}

=head3 file

Given a taxon ID and a file type, checks that the file is available for that taxon, and that the taxon is available to the public (or to the user)

@param  args hashref, with keys taxon_oid and file_type

@return $file_with_path for sending to the UI for download

=cut

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
			-where => {
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

sub examples {

	return [{
		url => '/api/file?taxon_oid=$img_taxon_oid&file_type=$file_type',
		desc => 'download $file_type for taxon $img_taxon_oid'
	},{
		url => '/api/file?taxon_oid=640069325&file_type=gff',
		desc => 'download the gff file for taxon 640069325'
	},{
		url => '/api/file?taxon_oid=640069325&file_type=bundle',
		desc => 'download the file bundle (containing sequence and functional annotations) for taxon 640069325'
	}];

}

1;

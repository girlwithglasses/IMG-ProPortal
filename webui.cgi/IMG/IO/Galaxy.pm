############################################################################
#	IMG::IO::Galaxy.pm
#
#	Interface to the Galaxy API
#
#	$Id: Galaxy.pm 35780 2016-06-15 20:41:20Z klchu $
############################################################################
package IMG::IO::Galaxy;

use IMG::Util::Import 'MooRole';

our $VERSION = 0.1.0;

requires 'http_ua';

has 'galaxy_api_key' => (
	required => 1,
	is => 'rwp',
	default => '4cb694b2c5256b255dd448cc36c090d5'
);

has 'workflow_id_h' => (
	is => 'lazy',
);


sub _build_workflow_id_h {

	# displays workflows
	# GET /api/workflows
	my $wf = $self->http_ua->get( $self->config->galaxy . '/api/workflows?key=' . $self->galaxy_api_key );

	log_debug { 'workflows: ' . Dumper $wf };

}

sub get_api_key {
	my $self = shift;


}

=head3 init_jbrowse

Start the JBrowse Galaxy workflow with the given ID


=cut

sub init_jbrowse {
	my $self = shift;
	my $args = shift;

	if ( ! $args || ! $args->{taxon_oid} ) {
		$self->choke({
			err => 'missing',
			subject => 'taxon_oid'
		});
	}

	# assemble the params

	'param=jbrowse_fetch_files=taxon_oid=' . $args->{taxon_oid};

# python workflow_execute.py
$self->galaxy_api_key
$self->config->galaxy . '/api/workflows'
$workflow_id 'hist_id=<history_id>' '38=hda=<file_id>' 'param=tool=name=value'
# python workflow_execute_parameters.py <api_key> http://localhost:8080/api/workflows 1cd8e2f6b131e891 'Test API' '69=ld=a799d38679e985db' '70=ld=33b43b4e7093c91f' 'param=peakcalling_spp=aligner=bowtie' 'param=bowtie_wrapper=suppressHeader=True' 'param=peakcalling_spp=window_size=1000'


}

sub init_phyloviewer {
	my $self = shift;

	# create history item with current cart



}

1;

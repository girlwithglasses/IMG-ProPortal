package ProPortal::Controller::Details::Gene;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Base';

with 'IMG::Model::DataManager';

# has 'controller_args' => (
# 	is => 'lazy',
# 	default => sub {
# 		return {
# 			class => 'ProPortal::Controller::Filtered',
# 			page_id => 'taxon_details',
# 			tmpl => 'pages/taxon_details.tt',
# 			tmpl_includes => {},
# 			page_wrapper => 'layouts/default_wide.tt',
# 		};
# 	}
# );


has '+page_id' => (
	default => 'details/gene'
);

has '+page_wrapper' => (
	default => 'layouts/default_wide.tt'
);

=head3 render

Details page for a gene

@param gene_oid

=cut

sub _render {
	my $self = shift;
	my $args = shift;

	log_debug { 'args: ' . Dumper $args };

	if ( ! $args || ! $args->{gene_oid} ) {
		$self->choke({
			err => 'missing',
			subject => 'gene_oid'
		});
	}

	my $genes = $self->get_data( $args );

	if ( ! scalar @$genes ) {
		$self->choke({
			err => 'no_results',
			subject => 'IMG gene ' . ( $args->{gene_oid} || 'unspecified' )
		});
	}

	log_debug { 'results: ' . Dumper $genes };

	return { results => { gene => $genes->[0] } };

}

sub get_data {
	my $self = shift;
	my $args = shift;

	# get the genes
	return $self->_core->run_query({
		query => 'gene_details',
		where => {
			gene_oid => $args->{gene_oid}
		}
	});

}

1;

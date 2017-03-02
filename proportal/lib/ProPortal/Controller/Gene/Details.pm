package ProPortal::Controller::Gene::Details;

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
# 			page_wrapper => 'layouts/default_wide.html.tt',
# 		};
# 	}
# );


has '+page_id' => (
	default => 'gene/details'
);

has '+page_wrapper' => (
	default => 'layouts/default_wide.html.tt'
);

=head3 render

Details page for a gene

@param taxon_oid

=cut

sub _render {
	my $self = shift;
	my $args = shift;

	if ( ! $args || ! $args->{gene_oid} ) {
		$self->choke({
			err => 'missing',
			subject => 'gene_oid'
		});
	}

	my $res = $self->_core->gene_details({
		where => $args
	});

	say 'results: ' . Dumper $res;

# 	make sure the taxon is public; get basic info
# 	my $taxon = $self->_core->run_query({
# 		query => 'taxon_name_public',
# 		where => {
# 			taxon_oid => $args->{taxon_oid},
# 		}
# 	});

	if ( ! $res->{gene} ) {
		$self->choke({
			err => 'no_results',
			subject => 'IMG gene ' . ( $args->{gene_oid} || 'unspecified' )
		});
	}

	return { results => $res };

}

1;

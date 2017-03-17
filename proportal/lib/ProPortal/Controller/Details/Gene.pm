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

	# get the genes
	my $genes = $self->_core->run_query({
		query => 'gene_list',
		where => {
			gene_oid => $args->{gene_oid}
		}
	});

	if ( ! scalar @$genes ) {
		$self->choke({
			err => 'no_results',
			subject => 'IMG gene ' . ( $args->{gene_oid} || 'unspecified' )
		});
	}

	my $tax_h;
	for ( @$genes ) {
		say 'gene: ' . Dumper $_;
		$tax_h->{ $_->{taxon} }++;
	}

	say 'taxon: ' . $genes->[0]{taxon};

	my @arr = keys %$tax_h;

	# make sure the taxon is public; get basic info
	my $taxon = $self->_core->run_query({
		query => 'taxon_name_public',
		where => {
			taxon_oid => $genes->[0]{taxon}
		}
	});

	say 'results: ' . Dumper $taxon;

# 	make sure the taxon is public; get basic info
# 	my $taxon = $self->_core->run_query({
# 		query => 'taxon_name_public',
# 		where => {
# 			taxon_oid => $args->{taxon_oid},
# 		}
# 	});


	return { results => { taxon => $taxon->[0], gene => $genes->[0] } };

}

1;

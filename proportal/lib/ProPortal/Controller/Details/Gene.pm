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

	my $res = $self->get_data( $args );

#	log_debug { 'results: ' . Dumper $res };

	return { results => { gene => $res } };

}

sub get_data {
	my $self = shift;
	my $args = shift;

	# get the genes
	my $genes = $self->_core->run_query({
		query => 'gene_details',
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

	my $res = $genes->[0];

	my $associated = {
		multi => [ qw(
			gene_cassette_genes
			gene_cog_groups
			gene_eggnogs
			gene_enzymes
			gene_ext_links
			gene_fusion_components
			gene_go_terms
			gene_img_interpro_hits
			gene_kog_groups
			gene_pdb_xrefs
			gene_rna_clusters
			gene_seed_names
			gene_sig_peptides
			gene_swissprot_names
			gene_tc_families
			gene_tigrfams
			gene_tmhmm_hits
			gene_xref_families
			img_cluster_member_genes
		)],
		single => [ qw(
			scaffold
		)]
	};

	return $res;

	for my $type ( %$associated ) {
		for my $assoc ( @{ $associated->{$type} } ) {
			if ( $res->can( $assoc ) ) {
				my $r = $res->$assoc;
		#		log_debug { 'looking at ' . $assoc . '; found ' . Dumper $r };

				if ($r
					&& ( ( 'multi' eq $type && scalar @$r )
					|| ( 'single' eq $type && defined $r ) ) ) {
					$res->{$assoc} = $r;
				}
			}
		}
	}

}

1;

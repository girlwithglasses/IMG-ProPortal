package ProPortal::Controller::Details::Gene;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Filtered';

with 'IMG::Model::DataManager';

has '+page_id' => (
	default => 'details/gene'
);

has '+page_wrapper' => (
	default => 'layouts/default_wide.tt'
);

has '+filter_domains' => (
	default => sub {
		return [ qw( gene_oid ) ];
	}
);

=head3 render

Details page for a gene

@param gene_oid

=cut

sub _render {
	my $self = shift;
	return { results => { gene => $self->get_data( @_ ) } };
}

sub get_data {
	my $self = shift;
	my $args = shift;

	if ( ! $args || ! $args->{gene_oid} ) {
		$self->choke({
			err => 'missing',
			subject => 'gene_oid'
		});
	}

	# check for deleted genes

	# check for replaced genes

	# check for metagenome genes



	# get the genes
	my $results = $self->_core->run_query({
		query => 'gene_details',
		where => {
			gene_oid => $args->{gene_oid}
		}
	});

	if ( ! scalar @$results ) {
		$self->choke({
			err => 'no_results',
			subject => 'IMG gene ' . ( $args->{gene_oid} || 'unspecified' )
		});
	}

	my $gene = $results->[0];

	my $associated = {
		multi => [ qw(
			gene_cog_groups
			gene_eggnogs
			gene_enzymes
			gene_ext_links
			gene_fusion_components
			gene_go_terms
			gene_img_interpro_hits
			gene_kog_groups
			gene_pdb_xrefs
			gene_seed_names
			gene_sig_peptides
			gene_swissprot_names
			gene_tc_families
			gene_tigrfams
			gene_tmhmm_hits
			gene_xref_families

			go_terms
			cog_terms
		)],
# 			gene_rna_clusters
# 			gene_cassette_genes
# 			img_cluster_member_genes
		single => [ qw(
			scaffold
		)]
	};

	for my $type ( %$associated ) {
		for my $assoc ( @{ $associated->{$type} } ) {
			if ( $gene->can( $assoc ) ) {
				my $r = $gene->$assoc;
		#		log_debug { 'looking at ' . $assoc . '; found ' . Dumper $r };
				if ($r
					&& ( ( 'multi' eq $type && scalar @$r )
					|| ( 'single' eq $type && defined $r ) ) ) {
					$gene->{$assoc} = $r;
				}
			}
		}
	}

# 	if ( $gene->gene_go_terms ) {
# 		for ( @{$gene->gene_go_terms} ) {
# 			# get the GO info
# 			$

	# fetch the cycogs
	my $cycogs = $self->_core->run_query({
		query => 'cycogs_by_gene_oid',
		where => {
			gene_oid => $args->{gene_oid}
		}
	});

	if ( scalar @$cycogs ) {
		$gene->{gene_cycog_groups} = $cycogs;
	}

#	log_debug { 'gene object: ' . Dumper $gene };
	return $gene;

}

sub examples {
	return [{
		url => '/details/gene/$img_gene_oid',
		desc => 'metadata for gene <var>$img_gene_oid</var>'
	},{
		url => '/details/gene/640083263',
		desc => 'metadata for gene IMG:640083263, DNA polymerase III, beta subunit (EC 2.7.7.7)'
	}];
}

1;

package ProPortal::Controller::Details::Gene;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Base';

with 'IMG::Model::DataManager';

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

	if ( 'imgsqlite' eq $self->_core->config->{schema}{img_core}{db} ) {
		return $res;
	}

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

	log_debug { 'gene object: ' . Dumper $res };
	return $res;

}

1;

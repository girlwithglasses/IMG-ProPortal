package ProPortal::Controller::List::Gene;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Filtered';

with 'IMG::Model::DataManager';

has '+page_id' => (
	default => 'list/gene'
);

has '+page_wrapper' => (
	default => 'layouts/default_wide.tt'
);

has '+filter_domains' => (
	is => 'ro',
	default => sub {
		return [ qw( pp_subset dataset_type locus_type gene_symbol taxon_oid category ) ];
	}
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
# 			locus_type => {
# 				pattern => '[a-z]RNA'
# 			},
# 			gene_symbol => {
# 				pattern => '\w+'
# 			},
# 			taxon_oid => {
# 				pattern => '\d+'
# 			},
# 			category => {
# 				enum => [ qw(
# 					rnas
# 					proteinCodingGenes
# 					withFunc
# 					withoutFunc
# 					fusedGenes
# 					signalpGeneList
# 					transmembraneGeneList
# 					geneCassette
# 					biosynthetic_genes
# 				)]
# 			},
# 			is_pseudogene => {
# 				enum => [ qw( Yes No ) ]
# 			}
# 		};
# 	}
# );

=head3 render

List of all genes in the ProPortal, filtered in some manner

@param taxon_oid

@param type =>

proteinCodingGenes
withFunc
withoutFunc
fusedGenes
signalpGeneList
transmembraneGeneList
pseudoGenes  -> IS_PSEUDOGENE
geneCassette
biosynthetic_genes

type = rnas
rnas, locus_type => ( rRNA | tRNA | xRNA )
rnas, locus_type => rRNA, gene_symbol => xxx

=cut

sub _render {
	my $self = shift;
	my $args = shift;

	$self->_core->set_filters( $args );

	if ( ! $args ) {
		$self->choke({
			err => 'missing',
			subject => 'taxon_oid'
		});
	}

	# get the genes
	my $count = $self->_core->run_query({
		query => 'gene_list_count',
# 		where => $q_hash
		filters => $self->filters
	});
	my $genes = $self->get_data( $args );

# 	if ( $args->{taxon_oid} ) {
# 		$self->_core->run_query({
# 			query => 'taxon_display_name'
#
# 		});
# 	}
	return { results => { genes => $genes, params => $args, label_data => $self->get_label_data } };

}

sub get_data {
	my $self = shift;
	my $args = shift;

	return $self->_core->run_query({
		query => 'gene_list',
# 		where => $q_hash
		filters => $self->filters
	});

}

1;

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
		return [ qw( pp_subset dataset_type locus_type gene_symbol taxon_oid category is_pseudogene ) ];
	}
);

has '+valid_filters' => (
	default => sub {
		return {
			pp_subset => {
				enum => [ qw( pro pro_phage syn syn_phage other other_phage isolate metagenome all_proportal ) ]
			},
			dataset_type => {
				enum => [ qw( isolate single_cell metagenome transcriptome metatranscriptome ) ]
			},
			locus_type => {
				pattern => '[a-z]RNA'
			},
			gene_symbol => {
				pattern => '\w+'
			},
			taxon_oid => {
				pattern => '\d+'
			},
			category => {
				enum => [ qw(
					proteinCodingGenes
					withFunc
					withoutFunc
					fusedGenes
					signalpGeneList
					transmembraneGeneList
					geneCassette
					biosynthetic_genes
				)]
			},
			is_pseudogene => {
				enum => [ qw( Yes No ) ]
			}
		};
	}
);

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
	my $genes = $self->get_data( $args );

	return { results => { genes => $genes, params => $args, label_data => $self->get_label_data } };

}

sub get_data {
	my $self = shift;
	my $args = shift;

# 	my $q_hash;
# 	for my $d ( @{$self->filter_domains} ) {
# 		if ( defined $args->{$d} ) {
#
# 		}
# 	}
#
# 	if ( $args->{locus_type} && 'xrna' eq lc( $args->{locus_type} ) ) {
# 		$q_hash->{locus_type} = {
# 			like => '%RNA',
# 			not_in => [ qw( rRNA tRNA ) ]
# 		};
# 		delete $args->{locus_type};
# 	}
#
# 	for ( qw ( is_pseudogene locus_type gene_symbol taxon_oid ) ) {
# 		$q_hash->{$_} = $args->{$_} if defined $args->{$_};
# 	}


	return $self->_core->run_query({
		query => 'gene_list',
# 		where => $q_hash
		filters => $self->filters
	});

}

1;

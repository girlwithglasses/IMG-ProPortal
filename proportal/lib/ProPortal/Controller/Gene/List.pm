package ProPortal::Controller::Gene::List;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Base';

with 'IMG::Model::DataManager';

has '+page_id' => (
	default => 'gene/list'
);

has '+page_wrapper' => (
	default => 'layouts/default_wide.tt'
);

=head3 render

List of all genes in the ProPortal, possibly filtered in some manner

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

	if ( ! $args || ! $args->{taxon_oid} ) {
		$self->choke({
			err => 'missing',
			subject => 'taxon_oid'
		});
	}

	# make sure the taxon is public; get basic info
	my $taxon = $self->_core->run_query({
		query => 'taxon_name_public',
		where => {
			taxon_oid => $args->{taxon_oid},
		}
	});

	# get the genes
	my $genes = $self->get_data( $args );

	return { results => { genes => $genes, taxon => $taxon, params => $args, label_data => $self->get_label_data } };

}

sub get_data {
	my $self = shift;
	my $args = shift;

	my $q_hash = {
		taxon => $args->{taxon_oid}
	};

	if ( $args->{locus_type} && 'xrna' eq lc( $args->{locus_type} ) ) {
		$q_hash->{locus_type} = {
			like => '%RNA',
			not_in => [ qw( rRNA tRNA ) ]
		};
		delete $args->{locus_type};
	}

	for ( qw ( is_pseudogene locus_type gene_symbol ) ) {
		$q_hash->{$_} = $args->{$_} if defined $args->{$_};
	}


	return $self->_core->run_query({
		query => 'gene_list',
		where => $q_hash
	});

}

1;

package ProPortal::Controller::Gene::List;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Base';

with 'IMG::Model::DataManager';

has '+page_id' => (
	default => 'gene/list'
);

has '+page_wrapper' => (
	default => 'layouts/default_wide.html.tt'
);

=head3 render

List of all genes in the ProPortal, possibly filtered in some manner

@param taxon_oid

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
	my $genes = $self->_core->run_query({
		query => 'gene_list',
		where => {
			taxon => $args->{taxon_oid}
		}
	});

	return { results => { genes => $genes, taxon => $taxon, label_data => $self->get_label_data } };

}

sub get_data {
	my $self = shift;

# 	my $res = $self->_core->run_query({
# 		query => 'gene_list',
# 		%$args
# 	});

}

1;

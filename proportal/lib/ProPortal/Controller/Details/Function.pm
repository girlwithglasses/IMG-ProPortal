package ProPortal::Controller::Details::Function;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Base';

with 'IMG::Model::DataManager';

has '+page_id' => (
	default => 'details/function'
);

has '+page_wrapper' => (
	default => 'layouts/default_wide.tt'
);

=head3 render

Details page for a CyCOG function

@param function_oid

=cut

sub _render {
	my $self = shift;
	return { results => $self->get_data( @_ ) };
}

sub get_data {
	my $self = shift;
	my $args = shift;

	if ( ! $args || ! $args->{db} || ! $args->{xref} ) {
		$self->choke({
			err => 'missing',
			subject => 'database cross-reference'
		});
	}

	$self->choke({
		err => 'not_implemented'
	}) unless 'cycog' eq $args->{db};

	my $res = $self->_core->run_query({
		query => 'cycog_details',
		where => {
			cycog_oid => $args->{xref}
		}
	});

	if ( scalar @$res != 1 ) {
		$self->choke({
			err => 'no_results',
			subject => 'function ' . join ":", map { $args->{$_} || '' } ( 'db', 'xref' )
		});
	}

#	log_debug { 'function: ' . Dumper $res };

	my $cy = $res->[0];

	my @gene_arr = map { $_->{gene_oid} } @{ $cy->cycog_genes };

	# get the gene list
	my $gene_list = $self->_core->run_query({
		query => 'gene_list',
		where => { gene_oid => \@gene_arr }
	});

#	log_debug { 'results: ' . Dumper $gene_list };

	return { function => $cy, genes => $gene_list };

}

1;

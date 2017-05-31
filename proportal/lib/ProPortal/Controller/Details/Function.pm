package ProPortal::Controller::Details::Function;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Filtered';

with 'IMG::Model::DataManager',
'ProPortal::Controller::Role::TableHelper';

has '+page_id' => (
	default => 'details/function'
);

has '+page_wrapper' => (
	default => 'layouts/default_wide.tt'
);

has '+filter_domains' => (
	default => sub {
		return [ qw( db xref ) ];
	}
);

has '+tmpl_includes' => (
	default => sub {
		return { tt_scripts => qw( datatables ) };
	}
);

=head3 render

Details page for a CyCOG function

@param function_oid

=cut

sub _render {
	my $self = shift;

	my $results = $self->get_data( @_ );

	$results->{table} = $self->get_table('gene');
	$results->{n_genes} = scalar @{$results->{function}{cycog_genes}};

	return { results => $results };
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
		-where => { id => $args->{xref} }
	});

	if ( scalar @$res != 1 ) {
		$self->choke({
			err => 'no_results',
			subject => 'function ' . join ":", map { $args->{$_} || '' } ( 'db', 'xref' )
		});
	}

#	log_debug { 'function: ' . Dumper $res };

	my $cy = $res->[0];

	# get associated genes/taxa
	$cy->expand( 'cycog_genes' );

	my $vers_h;
	my @gene_arr = map { $vers_h->{ $_->{version} }++; $_->{gene_oid} } @{ $cy->cycog_genes };

	# get the gene list
	my $gene_stt = $self->_core->run_query({
		query => 'gene_list',
		-where => { gene_oid => { in => \@gene_arr } },
		result_as => 'statement'
	});
	# get a count of the number of genes

#	log_debug { 'gene stt: ' . Dumper $gene_stt };
	log_debug { 'gene stt row count: ' . Dumper $gene_stt->row_count };
	log_debug { 'n cycog genes: ' . scalar @{$cy->{cycog_genes}} };
	return { function => $cy, genes => $gene_stt->all };

}

sub examples {
	return [{
		url => '/details/function/$db/$xref',
		desc => 'metadata for function <var>$db</var>:<var>$xref</var>'
	},{
		url => '/details/function/cycog/12345',
		desc => 'metadata for CyCOG:12345'
	}];
}

1;

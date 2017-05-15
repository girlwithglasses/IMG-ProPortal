package ProPortal::Controller::Role::Paged;

use IMG::Util::Import 'MooRole';

has 'page_size' => (
	is => 'lazy',
);

sub _build_page_size {
	my $self = shift;
	return $self->_core->config->{page_size} // 100;
}

has 'max_results' => (
	is => 'lazy'
);

sub _build_max_results {
	my $self = shift;
	return $self->_core->config->{max_results} // 5000;
}

has  'page_index' => (
	is => 'lazy'
);

sub _build_page_index {
	my $self = shift;
	return 1;
}

sub page_me {
	my $self = shift;
	my $stt = shift;

	log_debug { 'page index: ' . $self->page_index };

	# query will be paged; just return the first $self->page_size results
#	$stt->refine( -page_size => $self->page_size, -page_index => $self->page_index );

	log_debug { 'n pages: ' . $stt->page_count };
	log_debug { 'n rows: ' . $stt->row_count };

	# do a query count
	return $stt;
}


# has 'result_as' => (
# 	is => 'lazy',
#
# 		tsv
# 		csv
# 		json
#
#
# );



1;

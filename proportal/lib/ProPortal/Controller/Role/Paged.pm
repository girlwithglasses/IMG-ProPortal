package ProPortal::Controller::Role::Paged;

use IMG::Util::Import 'MooRole';

has 'page_size' => (
	is => 'lazy',
);

sub _build_page_size {
	my $self = shift;
	return $self->_core->config->{page_size} // 100;
}

# has 'max_results' => (
# 	is => 'lazy'
# );
#
# sub _build_max_results {
# 	my $self = shift;
# 	return $self->_core->config->{max_results} // 5000;
# }

has  'page_index' => (
	is => 'rwp',
	default => 1
);

sub _build_page_index {
	my $self = shift;
	return 1;
}

has 'page_count' => (
	is => 'rwp'
);

has 'n_results' => (
	is => 'rwp'
);

has 'paging_helper' => (
	is => 'rwp'
);

sub page_me {
	my $self = shift;
	my $stt = shift;

	log_debug { 'page index: ' . $self->page_index };
	my $max = $self->_core->config->{max_results} // 5000;

	my $n_results = $stt->row_count;
	$self->_set_n_results( $n_results );

	my $args = $stt->{args};
	$stt->reset( %$args );

	if ( ! $n_results ) {
		$self->_set_paging_helper({
			n_results   => 0,
		});
		return $stt;
	}

	if ( $self->n_results > 1000 ) {
		# check we will have valid results
		my $n_pages = int(( $self->n_results - 1) / $self->page_size) + 1;

		# if the page index is out of bounds, put it back into bounds
		if ( $n_pages < $self->page_index ) {
			$self->_set_page_index( $n_pages );
		}

		# query will be paged; just return the first $self->page_size results
		$stt->refine(
			-page_size  => $self->page_size,
			-page_index => $self->page_index
		);

		$self->_set_page_count( $stt->page_count );

		# set up the paging helper
		my $page_h = { $self->page_index => 1, $self->page_count => 1 };
		for ( 1, 2 ) {
			$page_h->{ $_ }++;
			$page_h->{ $self->page_index + $_ }++;
			$page_h->{ $self->page_index - $_ }++;
			$page_h->{ $self->page_count - $_ }++;
		}

		$self->_set_paging_helper({
			page_index  => $self->page_index,
			page_count  => $self->page_count,
			n_results   => $self->n_results,
			page_ix_arr => [ sort { $a <=> $b } grep { $_ > 0 && $_ <= $self->page_count } keys %$page_h ],
			page_id     => $self->page_id
		});

	}

	return $stt;
}

1;

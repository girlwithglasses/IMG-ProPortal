package ProPortal::Util::DataStructure;

use IMG::Util::Import 'MooRole';

requires 'choke';

=pod

=encoding UTF-8

=head1 NAME

ProPortal::Util::DataStructure - wrangle data structures!

=head3 make_tree

	my $obj = $self->make_tree( $ds, $path );

@param  $ds     data structure

@return $tree   tree structure in the form

	{	name => $node_name,
		children => [ $node, $node, $node, ... ]
	}

=head3 make_tree_with_path

	my $obj = $self->make_tree_with_path( $ds, $path );

@param  $ds     data structure
@param  $path   string representing the current path to the root of the tree

@return $tree   tree structure in the form

	{	name => $node_name,
		path => $path_to_node . "__" . $node_name,
		children => [ $node, $node, $node, ... ]
	}

=cut


sub make_tree {
	my $self = shift;
	my $ds = shift;
	if ( 'ARRAY' eq ref $ds ) {
		return [ sort { $a->{name} cmp $b->{name} } @$ds ];
	}
	elsif ( 'HASH' eq ref $ds ) {
		my $struct;
		for ( sort keys %$ds ) {
			push @$struct, { name => $_, children => $self->make_tree( $ds->{$_} ) };
		}
		return $struct;
	}
	$self->choke({
		err => 'format_err',
		subject => 'Recursive tree-maker input'
	});
}

sub make_tree_with_path {
	my $self = shift;
	my $ds = shift;
	my $path = shift // '';
	if ( 'ARRAY' eq ref $ds ) {
		return [ sort { $a->{name} cmp $b->{name} } @$ds ];
	}
	elsif ( 'HASH' eq ref $ds ) {
		my $struct;
		my $p;
		for ( sort keys %$ds ) {
			( $p = $_ ) =~ s/\W/_/g;
			push @$struct, {
				name => $_,
				path => $path . "__$p",
				children => $self->make_tree_with_path( $ds->{$_}, $path . "__$p"  )
			};
		}
		return $struct;
	}
	$self->choke({
		err => 'format_err',
		subject => 'Recursive tree-maker input'
	});
}




1;

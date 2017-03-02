package IMG::Model::Filter;

use IMG::Util::Import 'Class';

# the id of the domain to be filtered
has 'id' => (
	is => 'ro',
	isa => Str,
);

# human-friendly label
has 'title' => (
	is => 'ro',
	isa => Str,
);

# has 'type' => (
# 	is => 'ro',
# 	isa => StrMatch[ qr/^(radio|checkbox|slider|minmax|text)$/ ],
# );

has 'is_active' => (
	is => 'ro',
	isa => Bool,
	default => 1
);

# the current value of the filter
has 'current' => (
	is => 'rwp'
);

# the valid values for the filter
has 'valid' => (
	is => 'rwp'
);

1;


# package IMG::Model::FilterValue;
#
# use IMG::Util::Import 'Class';
#
# has 'id' => (
# 	is => 'ro',
# 	isa => Str,
# );
#
# has 'label' => (
# 	is => 'ro',
# 	isa => Str,
# );
#
# has 'sort' => (
# 	is => 'ro',
# 	isa => Int|Str,
# 	predicate => 1,
# );
#
# has 'is_on' => (
# 	is => 'ro',
# 	isa => Bool,
# );
#
# 1;
#
#
# package IMG::Model::ContinuousFilter;
#
# use IMG::Util::Import 'Class';
#
# extends 'IMG::Model::Filter';
#
# my @attrs = qw( min max units );
#
# has $_ => ( is => 'ro', isa => Str ) for @attrs;
#
# 1;
#


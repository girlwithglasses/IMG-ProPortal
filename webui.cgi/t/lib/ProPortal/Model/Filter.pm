package ProPortal::Model::Filter;

use IMG::Util::Base 'Class';

# the id of the domain to be filtered
has 'id' => (
	is => 'ro',
	isa => Str,
);

# human-friendly label
has 'label' => (
	is => 'ro',
	isa => Str,
);

has 'type' => (
	is => 'ro',
	isa => StrMatch[ qr/^(radio|checkbox|slider|minmax|text)$/ ],
);

has 'is_active' => (
	is => 'ro',
	isa => Bool,
);

=head3 execute

Apply the filter

=cut

sub execute {


}

1;


package ProPortal::Model::DiscreteFilter;

use IMG::Util::Base 'Class';

extends 'ProPortal::Model::Filter';

#use Types::Standard qw( InstanceOf );

has 'values' => (
	is => 'rw',
	isa => ArrayRef[ InstanceOf['ProPortal::Model::FilterValue'] ],
);

1;


package ProPortal::Model::FilterValue;

use IMG::Util::Base 'Class';

has 'id' => (
	is => 'ro',
	isa => Str,
);

has 'label' => (
	is => 'ro',
	isa => Str,
);

has 'sort' => (
	is => 'ro',
	isa => Int|Str,
	predicate => 1,
);

has 'is_on' => (
	is => 'ro',
	isa => Bool,
);

1;


package ProPortal::Model::ContinuousFilter;

use IMG::Util::Base 'Class';

extends 'ProPortal::Model::Filter';

my @attrs = qw( min max units );

has $_ => ( is => 'ro', isa => Str ) for @attrs;

=cut
has 'min' => (
	is => 'ro',
	isa => Str,
);

has 'max' => (
	is => 'ro',
	isa => Str,
);

has 'units' => (
	is => 'ro',
	isa => Str,
);
=cut

1;



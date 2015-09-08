package ProPortal::Model::Filter;

use IMG::Util::Base 'Class';
#require 5.010_000;
#use strict;
#use warnings;
#use feature ':5.10';

#use Moo;
#use Types::Standard qw( Int Str Bool StrMatch InstanceOf ArrayRef );
#use Data::Dumper;

# the id of the domain to be filtered
has 'id' => (
	is => 'rw',
	isa => Str,
);

# human-friendly label
has 'label' => (
	is => 'rw',
	isa => Str,
);

has 'type' => (
	is => 'rw',
	isa => StrMatch[ qr/(radio|checkbox|slider|minmax|text)/ ],
);

has 'is_active' => (
	is => 'rw',
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

#require 5.010_000;
#use strict;
#use warnings;
#use feature ':5.10';

#use Moo;
#use Types::Standard qw( Int Str Bool StrMatch HashRef );
#use Data::Dumper;

has 'id' => (
	is => 'rw',
	isa => Str,
);

has 'label' => (
	is => 'rw',
	isa => Str,
);

has 'sort' => (
	is => 'ro',
	isa => Int|Str,
	predicate => 1,
);

has 'is_on' => (
	is => 'rw',
	isa => Bool,
);

1;


package ProPortal::Model::ContinuousFilter;

use IMG::Util::Base 'Class';

extends 'ProPortal::Model::Filter';

has 'min' => (
	is => 'rw',
	isa => Str,
);

has 'max' => (
	is => 'rw',
	isa => Str,
);

has 'units' => (
	is => 'ro',
	isa => Str,
);

1;



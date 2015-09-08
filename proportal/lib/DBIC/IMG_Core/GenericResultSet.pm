package DBIC::IMG_Core::GenericResultSet;

use strict;
use warnings;
use Carp;
use parent 'DBIx::Class::ResultSet';

sub like_fields {
	my $self = shift;
	my $field = shift;
	my (@values) = @_;
	croak "No values supplied for filter!" unless @values;

	$self->search({
		$self->lower( $self->col($field) ) => {
			'like',
			(scalar @values > 1) ? \@values : $values[0]
		}
	});
}


sub col {
	my $self = shift;
	my $this = shift;
	return $self->current_source_alias . '.' . $this;
}

sub lower {
	my $self = shift;
	return 'lower(' . shift . ')';
}

sub not_null {
	my $self = shift;
	my $this = shift;
	$self->search({
		$self->col($this) => { '!=', undef }
	});
}

sub null {
	my $self = shift;
	my $this = shift;
	$self->search({
		$self->col($this) => undef
	});
}
1;

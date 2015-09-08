package DBIC::IMG_Core::ResultSet::GoldSequencingProject;

use strict;
use warnings;
use parent 'DBIC::IMG_Core::GenericResultSet';


sub marine_eco {
	my $self = shift;
	$self->search({
		$self->col('ecosystem_type') => 'Marine'
	});
}

sub eco_specific {
	my $self = shift;
	my (@types) = @_;
	return unless @types;

	$self->search({
		$self->lower( $self->col('specific_ecosystem') ) => {
			'like',
			(scalar @types > 1) ? \@types : $types[0]
		}
	});
}

sub eco_subtype {
	my $self = shift;
	my (@types) = @_;
	return unless @types;

	$self->search({
		$self->lower( $self->col('ecosystem_subtype') ) => {
			'like',
			(scalar @types > 1) ? \@types : $types[0]
		}
	});
}


sub marine_eco_ids {
	my $self = shift;
	$self->search({
		$self->col('ecosystem_type') => 'Marine'
	},{
		columns => [ 'gold_id' ],
	})->as_query;
}


1;

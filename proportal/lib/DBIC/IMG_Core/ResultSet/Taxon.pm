package DBIC::IMG_Core::ResultSet::Taxon;

use strict;
use warnings;
use parent 'DBIC::IMG_Core::GenericResultSet';

=cut

sub all_spp {
	my $self = shift;
	$self->search({
		-or => [
			$self->lower( $self->col('taxon_display_name') ) => { 'like',
				[ '%cyanophage%', '%prochlorococcus phage%', '%synechococcus phage%' ]
			},
			$self->lower( $self->col('genus') ) => { 'like',
				['%prochlorococcus%', '%synechococcus%']
			},
		]
	});
}


sub phage {
	my $self = shift;
	$self->search({

		$self->lower( $self->col('taxon_display_name') ) => { 'like',
		[ '%cyanophage%', '%prochlorococcus phage%', '%synechococcus phage%' ]
		}

	});
}

sub prochloro {
	my $self = shift;
	return $self->genus('prochloro');
}

sub syne {
	my $self = shift;
	return $self->genus('syne');
}

sub genus_like {
	my $self = shift;
	my @taxa = @_;
	return unless @taxa;
	$self->search({
		$self->lower($self->col('genus')) => { 'like', [ @taxa ] }
	});
}

sub genus {
	my $self = shift;
	my $g = shift // die "Must specify a genus!";
	my $str = '';

	if ($g =~ /^prochl/) {
		$str = '%prochlorococcus%';
	}
	elsif ($g =~ /^syne/) {
		$str = '%synechococcus%';
	}
	else {
		warn "Did not understand the genus '$g'";
		return;
	}

	$self->search({
		$self->lower($self->col('genus')) => { 'like', $str }
	});
}

=cut

sub public_extant {
	my $self = shift;
	$self->search({
		$self->col('is_public') => 'Yes',
		$self->col('obsolete_flag') => 'No',
	});
}

sub marine_metagenome {
	my $self = shift;
	$self->search({
		$self->col('genome_type') => 'metagenome',
		$self->col('ir_order') => 'Marine',
		$self->col('combined_sample_flag') => [ undef, 'No' ],
	});
}


1;

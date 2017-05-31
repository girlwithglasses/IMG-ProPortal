package IMG::Model::Taxon;

use IMG::Util::Import 'Class';
use Scalar::Util qw( blessed );
use Acme::Damn;
with 'IMG::App::Role::ErrorMessages';

# Required attributes
my @reqd = qw( taxon_oid );

# optional attributes
my @opt = qw( taxon_display_name is_public );

has $_ => ( is => 'lazy', required => 1 ) for @reqd;

sub _build_taxon_oid {
	my $self = shift;
	$self->choke({
		err => 'missing',
		subject => 'taxon_oid'
	});
}

has $_ => ( is => 'rwp', lazy => 1, predicate => 1 ) for @opt;

1;



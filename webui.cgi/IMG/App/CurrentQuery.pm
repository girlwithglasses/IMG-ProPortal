############################################################################
#	IMG::App::CurrentQuery.pm
#
#	Interface to the current query
#
#	$Id: CurrentQuery.pm 36576 2017-02-24 19:08:01Z aireland $
############################################################################
package IMG::App::CurrentQuery;

use IMG::Util::Import 'Class';

for ( qw( session user request ) ) {
	has $_ => ( is => 'ro' );
}

has 'page_id' => (
	is => 'rwp',
	default => ''
);

has 'menu_group' => (
	is => 'rwp',
	default => ''
);


has '_core' => (
	is => 'ro',
	weak_ref => 1
);

sub _set_page_params {
	my $self = shift;
	my $params = shift;

	for ( qw( page_id menu_group ) ) {
		if ( $params->{$_} ) {
			my $p = '_set_' . $_;
#			say 'running ' . $p;

			$self->$p( $params->{$_} );
		}
	}

#	say 'page_id: ' . Dumper $self->page_id;
#	say 'menu_group: ' . Dumper $self->menu_group;

}

1;

package Routes::Menus;
use IMG::Util::Base;
use parent 'CoreStuff';
use Dancer2 appname => 'ProPortal';
our $VERSION = '0.1';

prefix '/menu';

# render menu pages
any '/*' => sub {
	my $menu_page = request->dispatch_path;

	debug 'menu page: ' . $menu_page;

	my $data;

	# make sure it's a valid page
	if ( IMG::Views::Links::get_link_data( $menu_page ) ) {

		# find the link in the menus
		my $m_struct = IMG::Views::Menu::make_menus();
		debug 'menu structure: ' . Dumper $m_struct;

		my $tree = IMG::Views::Menu::search_menu( $menu_page );
		if ( $tree ) {
			# found it!
			$data = $tree;
		}
	}

	template "pages/menu_page", { content => $data };

};

sub search_menu {
	my $struct = shift;
	my $menu_page = shift;

	if ( ref $struct && 'ARRAY' eq ref $struct ) {
		for ( @$struct ) {
			next unless ref $_;
			if ( $_->{id} && $menu_page eq $_->{id} ) {
				debug 'found the thing I was looking for!';
				return $_;
			}
			my $results = search_menu( $_->{submenu}, $menu_page ) if $_->{submenu};
			return $results if $results;
		}
	}
	return undef;
}

1;

package Routes::MenuPages;
use IMG::Util::Base;
use parent 'CoreStuff';
use Dancer2 appname => 'ProPortal';
our $VERSION = '0.1';

prefix '/menu';

# render menu pages

get '/ANI' => sub {

	# ANI::Home

	# printLandingPage()

	template 'pages/ani_home', { content => $data };

};

get '/*' => sub {
	my $menu_page = request->dispatch_path;
	var page => $menu_page;

	debug 'menu page: ' . $menu_page;

	my $data;
	# make sure it's a valid page
	if ( IMG::Views::Links::get_link_data( $menu_page ) ) {

		# find the link in the menus
		my $m_struct = IMG::Views::Menu::make_menus( config );
		my $tree = IMG::Views::Menu::search_menu( $menu_page );
		if ( $tree ) {
			# found it!
			$data = $tree;
		}
	}

	template "pages/menu_page", { content => $data };

};

1;

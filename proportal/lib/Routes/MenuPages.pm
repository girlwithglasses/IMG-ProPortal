package Routes::MenuPages;
use IMG::Util::Base;
use parent 'CoreStuff';
use Dancer2 appname => 'ProPortal';
our $VERSION = '0.1';

prefix '/menu';

# render menu pages

get qr{
	/ani
	}xi => sub {

	# ANI::Home
	require ANI::Home;

	var page => request->dispatch_path;
	my $content = menu_maker( request->dispatch_path );
	$content->{tmpl_includes}{content_tmpl} = 'pages/ani_home.tt';

	my $data = ANI::Home::render();

	template "pages/menu_page", { content => $content, data => $data };

};

get '/*' => sub {
	my $menu_page = request->dispatch_path;
	var page => $menu_page;
	my $content = menu_maker( $menu_page );



	template "pages/menu_page", { content => $content };
};

sub menu_maker {
	my $page = shift;

	if ( IMG::Views::Links::get_link_data( $page ) ) {
		# find the link in the menus
		my $m_struct = IMG::Views::Menu::make_menus( config );
		return IMG::Views::Menu::search_menu( $page );
	}
	return;
}

1;

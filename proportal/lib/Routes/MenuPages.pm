package Routes::MenuPages;
use IMG::Util::Base;
use Dancer2 appname => 'ProPortal';
use parent 'AppCore';

# render menu pages
=head3 menu_page_subs

Subs to generate menu page contents

@return  $anon_hash with keys
	tmpl -- the name of a template to include in the page
	page -- any data or other contents for populating the template

=cut

my $menu_page_subs = {

	ani => sub {
		require ANI::Home;
		my $page = ANI::Home::render();
		return { tmpl => 'ani_home', page => $page };
	},

};

prefix '/menu' => sub {

	get qr{
		/(?<page> .*? )
		/?
		}xi => sub {

		my $p = captures->{page};
		var page_id => 'menu/' . $p;

		my $content = menu_maker( 'menu/' . $p );
		my $data;

		debug 'p: ' . $p;

		if ( $menu_page_subs->{$p} ) {
			my $rtn = $menu_page_subs->{$p}->();
			$content->{tmpl_includes}{content_tmpl} = $rtn->{tmpl};
			$data = $rtn->{page};
		}

		template "pages/menu_page.tt", { content => $content, data => $data };

	};

};

sub menu_maker {
	my $page = shift;
	my $core = setting("_core");
	if ( $core->link_data( $page ) ) {
		# find the link in the menus
		return $core->search_menu( $page );
	}
	return;
}

1;

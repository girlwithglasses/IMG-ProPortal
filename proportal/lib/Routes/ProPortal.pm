package Routes::ProPortal;
use IMG::Util::Base;
use Dancer2 appname => 'ProPortal';
use parent 'AppCore';
use IMG::Util::Base 'Class';
use ProPortal::Util::Factory;

our $VERSION = '0.1.0';

has 'active_components' => (
	is => 'lazy',
	default => sub {
		return {
			base => [ 'home' ],

			filtered => [ qw(
				big_ugly_taxon_table
				clade
				data_type
				ecosystem
				ecotype
				location
				phylogram
			) ]
		};
	}
);


get '/' => sub {
	forward '/proportal';
};

# any qr{ /.* }x => sub {
any '/offline' => sub {

	var menu_grp => 'proportal';
	var page_id => 'proportal';

	my $pp = AppCore::bootstrap( 'Home' );

	return template "pages/offline", $pp->render();

};

prefix '/proportal' => sub {

	my $group = 'proportal';

	# filterable queries
	get qr{
		/ (?<query> clade | data_type | ecosystem | ecotype | location | phylogram | big_ugly_taxon_table )
		/? (?<subset> \w+.* )?
		}x => sub {

		my $c = captures;
		my $p = $c->{query};

		var menu_grp => $group;
		var page_id  => $group . "/$p";

		my $app = AppCore::create_core();
		$app->add_controller_role( $p );

		if ( $c->{subset} ) {
			$app->set_filters( subset => $c->{subset} );
		}

#		debug 'page: ' . $p
#			. '; subset: ' . ( $c->{subset} || 'none' )
#			. '; template: ' . $app->controller->tmpl;

		return template $app->controller->tmpl, $app->render;

	};

=head3 Home page

The home page.

=cut

	any qr{
		/?
		}x => sub {

		var menu_grp => $group;
		var page_id => $group;

		my $app = AppCore::bootstrap( 'Home' );
		my $rslts = $app->render;
		$rslts->{page_wrapper} = 'layouts/default_wide.html.tt';
		return template $app->controller->tmpl, $rslts;

	};

};

get '/taxon/:taxon_oid' => sub {

	my $pp = AppCore::bootstrap( 'TaxonDetails' );

	my $rslts = $pp->render({ taxon_oid => params->{taxon_oid} });
	$rslts->{page_wrapper} = 'layouts/default_wide.html.tt';
	return template $pp->controller->tmpl, $rslts;

};

prefix '/tools' => sub {

	my $group = 'tools';

	get qr{
		/ (?<query> krona | jbrowse | galaxy )
		/?
		}x => sub {

		my $c = captures;
		my $p = $c->{query};
		var menu_grp => $group;
		var page_id  => $group . "/$p";

		# phyloviewer: gene cart
		# krona:
		# jbrowse: ??? taxon selector?
		# galaxy:  ???
		my $h = {
			krona => 'Krona',
			jbrowse => 'JBrowse',
			phyloviewer => 'PhyloViewer',
			galaxy => 'Galaxy'
		};

		my $app = AppCore::bootstrap( 'Tools::' . $h->{$p} );
#		$app->add_controller_role(  );

		say 'page: ' . $p
			. '; subset: ' . ( $c->{subset} || 'none' )
			. '; template: ' . $app->controller->tmpl;

		return template $app->controller->tmpl, $app->render;
	};

=head3 PhyloViewer

The following pages are all PhyloViewer-related.

GET  /proportal/phylo_viewer(/query)? => Query form for the PhyloViewer

POST /proportal/phylo_viewer/query    => submit form, validate, run analysis

a unique QUERY_ID is generated and assigned

GET  /proportal/phylo_viewer/results/QUERY_ID => get query results


=cut
	prefix '/phyloviewer' => sub {

		# demo cart at phylo_viewer/demo

		get qr{
			/? (?<query> (query|demo) )?
			}x => sub {

			say 'running query code!';
			var menu_grp => $group;
			var page_id  => 'phyloviewer';

			my $c = captures;
			my $p = delete $c->{query};
			my $module = $p && 'demo' eq $p ? 'QueryDemo' : 'Query';

			my $pp = AppCore::bootstrap( 'PhyloViewer::' . $module );

			return template $pp->controller->tmpl, $pp->render();
		};

		post qr{
			/query
			}x => sub {

			var menu_grp => $group;
			var page_id  => $group . '/phyloviewer';

			my $params;
			for my $p ( qw( gp input msa tree ) ) {
				$params->{$p} = [ body_parameters->get_all($p) ];
			}
			my $pp = AppCore::bootstrap( 'PhyloViewer::Submit' );

			return template $pp->controller->tmpl, $pp->render( $params );

		};

		# DEMO results page at phylo_viewer/results/demo
		get qr{
			/results/(?<query_id> ( demo | .*) )
		}x => sub {
			my $c = captures;
			my $p = delete $c->{query_id};
			my $module = $p && 'demo' eq $p ? 'ResultsDemo' : 'Results';

			var menu_grp => $group;
			var page_id  => $group. '/phyloviewer';
			my $tmpl = 'pages/proportal/phylo_viewer/results';

			my $pp = AppCore::bootstrap( 'PhyloViewer::' . $module );

			return template $pp->controller->tmpl, $pp->render();
		};
	};

};

prefix '/support' => sub {

	my $group = 'support';

	get '/news' => sub {
		var menu_grp => 'support';
		var page_id  => 'support/news';

#		return template
	};
	get '/about' => sub {

#	return template
	};

};

prefix '/search' => sub {

	my $group = 'search';

	get qr{
		/ (?<query> advanced_search | blast )
		/?
		}x => sub {

			my $c = captures;
			my $p = $c->{query};
			var menu_grp => $group;
			var page_id  => $group . "/$p";
			return template 'pages/tools/' . $p;
	};
};


1;

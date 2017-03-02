package Routes::ProPortal;
use IMG::Util::Import 'Class';
use Dancer2 appname => 'ProPortal';
use ProPortal::Util::Factory;
use AppCorePlugin;
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

# say 'config: ' . Dumper config;


get '/' => sub {
	forward '/proportal';
};

# any qr{ /.* }x => sub {
any '/offline' => sub {

	return template 'pages/offline';

};

prefix '/proportal' => sub {

	my $prefix = 'proportal';

	# filterable queries
	get qr{
		/ (?<query> clade | data_type | ecosystem | ecotype | location | longhurst | phylogram | big_ugly_taxon_table )
		/?
		(subset=)?
		(?<subset>\w+)?
		/?
		(dataset_type=)?
		(?<dataset_type>\w+)?
		/?
		}x => sub {

#	<= subset=SUBSET
#	<= dataset_type=DST

		my $c = captures;
		my $p = delete $c->{query};

#		say 'captures: ' . Dumper $c;

		bootstrap( $p );

		img_app->set_filters( $c );

		img_app->current_query->_set_page_params({
			page_id => img_app->controller->page_id,
			menu_group => $prefix
		});

		return template img_app->controller->tmpl, img_app->controller->render;

	};

=head3 Home page

The home page.

=cut

	any qr{
		/?
		}x => sub {

		bootstrap( 'Home' );

		img_app->current_query->_set_page_params({
			page_id => img_app->controller->page_id,
			menu_group => $prefix
		});

		return template img_app->controller->tmpl, img_app->controller->render;

	};

};

get '/taxon/:taxon_oid' => sub {

	bootstrap( 'TaxonDetails' );

	img_app->current_query->_set_page_params({
		page_id => img_app->controller->page_id
	});

	return template img_app->controller->tmpl, img_app->controller->render({ taxon_oid => params->{taxon_oid} });

};


prefix '/gene' => sub {

	get '/details/:gene_oid' => sub {

		bootstrap( 'Gene::Details' );

		img_app->current_query->_set_page_params({
			page_id => img_app->controller->page_id
		});

		return template img_app->controller->tmpl, img_app->controller->render({ gene_oid => params->{gene_oid} });

	};

	get qr{
		/list
		/?
		(subset=)?
		(?<subset>\w+)?
		/?
		(dataset_type=)?
		(?<dataset_type>\w+)?
		/?
		(taxon=)?
		(?<taxon_oid>\w+)?
		/?
		}x => sub {

		bootstrap( 'Gene::List' );

		say 'captures: ' . Dumper captures;
		say 'params: ' . Dumper params->{taxon_oid};

#		img_app->set_filters( captures );

		img_app->current_query->_set_page_params({
			page_id => img_app->controller->page_id
		});

		return template img_app->controller->tmpl, img_app->controller->render({ taxon_oid => captures->{taxon_oid} });

	};

};

prefix '/tools' => sub {

	my $prefix = 'tools';

	get qr{
		/ (?<query> krona | jbrowse | galaxy )
		/?
		}x => sub {

		my $c = captures;
		my $p = $c->{query};

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

		bootstrap( 'Tools::' . $h->{$p} );

		img_app->current_query->_set_page_params({
			page_id => $prefix . "/$p",
			menu_group => $prefix
		});

		return template img_app->controller->tmpl, img_app->controller->render;
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

			img_app->current_query->_set_page_params({
				page_id => $prefix . '/phyloviewer',
				menu_group => $prefix
			});

			my $c = captures;
			my $p = delete $c->{query};
			my $module = $p && 'demo' eq $p ? 'QueryDemo' : 'Query';

			bootstrap( 'PhyloViewer::' . $module );

			return template img_app->controller->tmpl, img_app->controller->render();
		};

		post qr{
			/query
			}x => sub {

			img_app->current_query->_set_page_params({
				page_id => $prefix . '/phyloviewer',
				menu_group => $prefix
			});

			my $params;
			for my $p ( qw( gp input msa tree ) ) {
				$params->{$p} = [ body_parameters->get_all($p) ];
			}
			my $pp = bootstrap( 'PhyloViewer::Submit' );

			return template $pp->controller->tmpl, $pp->controller->render( $params );

		};

		# DEMO results page at phylo_viewer/results/demo
		get qr{
			/results/(?<query_id> ( demo | .*) )
		}x => sub {
			my $c = captures;
			my $p = delete $c->{query_id};
			my $module = $p && 'demo' eq $p ? 'ResultsDemo' : 'Results';

			img_app->current_query->_set_page_params({
				page_id => $prefix . '/phyloviewer',
				menu_group => $prefix
			});

			my $tmpl = 'pages/proportal/phylo_viewer/results';

			my $pp = bootstrap( 'PhyloViewer::' . $module );

			return template $pp->controller->tmpl, $pp->controller->render();
		};
	};

};

my $page_h = {
	tools => [ qw( krona jbrowse galaxy phyloviewer ) ],
	search => [ qw( advanced_search blast ) ],
	user_guide => [ qw( api_manual browsing getting_started searching using_tools ) ],
	support => [ qw( news about ) ]
};

for my $prefix ( keys %$page_h ) {

	prefix "/$prefix" => sub {

		my $re = join '|', @{ $page_h->{$prefix} };

		get qr{
			/ (?<query> $re )
		}x => sub {
			my $c = captures;
			my $p = $c->{query};

			img_app->current_query->_set_page_params({
				page_id => $prefix . "/$p",
				menu_group => $prefix
			});

			return template "pages/". $prefix . "/" . captures->{query};
		};
	};
}

prefix '/user_guide' => sub {
	get qr{ /? }x => sub {
		return template "pages/user_guide/index", { pages => $page_h->{user_guide} };
	}
};

1;

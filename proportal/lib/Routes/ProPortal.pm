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

# log_debug { 'config: ' . Dumper config };

get '/' => sub {
	forward '/proportal';
};

# any qr{ /.* }x => sub {
any '/offline' => sub {

	return template 'pages/offline';

};


sub generic_api {
	my $args = shift;
	my $rslt = img_app->controller->get_data( $args->{params} );
	if ( ! $rslt ) {
		$rslt = { 'error' => 001, 'message' => 'No data returned by query' };
	}
	content_type 'application/json';
	return JSON->new->convert_blessed(1)->encode( $rslt );
}

=cut

arguments:

controller:
$args->{cntrl}
OR
$args->{prefix}::$args->{domain}


filters (for list queries)
params  (for details queries)
menu_group

=cut

sub generic {
	my $args = shift;
	my $h = {
		function => 'Function',
		gene => 'Gene',
		taxon => 'Taxon',
		details => 'Details',
		list => 'List',
		file => 'File'
	};

	log_debug { 'args to dispatcher: ' . Dumper $args };

	my $cntrl = $args->{cntrl} || $args->{prefix} . '::' . $args->{domain};

#	$h->{ $args->{prefix} } . '::' . $h->{ $args->{domain} };

	bootstrap( $cntrl );

	if ( $args->{filters} ) {
		img_app->set_filters( $args->{filters} );
	}

	img_app->current_query->_set_page_params({
		page_id => img_app->controller->page_id,
		menu_group => $args->{menu_group} || undef
	});

	# branch off to the API here

	return template img_app->controller->tmpl, img_app->controller->render( $args->{params} || {} );

}

prefix '/proportal' => sub {

	my $prefix = 'proportal';

	any qr{
		/ (?<query> clade | data_type | ecosystem | ecotype | location | longhurst | phylogram | big_ugly_taxon_table )
		}x => sub {
			return generic({
				cntrl => captures->{query},
				menu_group => $prefix,
				filters => query_parameters
			});
		};

# 		log_debug { 'top query_parameters: ' . Dumper query_parameters };
#
# 		bootstrap( captures->{query} );
#
# 		img_app->set_filters( query_parameters );
#
# 		img_app->current_query->_set_page_params({
# 			page_id => img_app->controller->page_id,
# 			menu_group => $prefix
# 		});
#
# 		return template img_app->controller->tmpl, img_app->controller->render;


=head3 Home page

The home page.

=cut

	any qr{
		/?
		}x => sub {
			return generic({
				cntrl => 'Home',
				menu_group => $prefix
			});
		};

# 		bootstrap( 'Home' );
#
# 		img_app->current_query->_set_page_params({
# 			page_id => img_app->controller->page_id,
# 			menu_group => $prefix
# 		});
#
# 		return template img_app->controller->tmpl, img_app->controller->render;

};

any '/taxon/:taxon_oid' => sub {
	return generic({
		prefix => 'details',
		domain => 'taxon',
		params => { taxon_oid => captures->{taxon_oid} }
	});
};

prefix '/list/' => sub {

	for my $domain ( qw( gene taxon function ) ) {
		prefix $domain => sub {
			# standard ? query
			get '?' => sub {
				pass if ! scalar query_parameters->keys;
				return generic({ prefix => 'list', domain => $domain, filters => query_parameters });
			};

			# base query
			any qr{.*}x => sub {
				# Instructions page?
				return generic({ prefix => 'list', domain => $domain });
			};
		};
	}

	prefix 'file' => sub {

		any '/taxon?' => sub {
			log_debug { 'no query params!' } && pass if ! scalar query_parameters->keys;
			return generic({ prefix => 'list', domain => 'file', filters => query_parameters });
		};

		any qr{.*}x => sub {
				return template 'pages/api/details_file_taxon.tt', { schema => { file_type => img_app->filter_schema('file_type') } };
		};
	};


};


prefix '/details/' => sub {

	any qr{
		(?<domain> gene | taxon )
		[\?/]
		(?<oid> .* )
		}x => sub {
			return generic({
				prefix => 'details',
				domain => captures->{domain},
				params => { captures->{domain} . '_oid' => captures->{oid}
			} });
	};

	any 'function/:db/:xref' => sub {
		return generic({
			prefix => 'details',
			domain => 'function',
			params => {
				db => route_parameters->get( 'db' ),
				xref => route_parameters->get( 'xref' )
			}
		});
	};
};


prefix '/tools' => sub {

	my $prefix = 'tools';

	get qr{
		/ (?<query> krona | jbrowse | galaxy )
		/?
		}xi => sub {

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

			log_debug { 'running query code!' };

			my $c = captures;
			my $p = delete $c->{query};
			my $module = $p && 'demo' eq $p ? 'QueryDemo' : 'Query';

			bootstrap( 'PhyloViewer::' . $module );

			img_app->current_query->_set_page_params({
				page_id => $prefix . '/phyloviewer',
				menu_group => $prefix
			});

			return template img_app->controller->tmpl, img_app->controller->render;
		};

		post qr{
			/query
			}x => sub {

			my $params;
			for my $p ( qw( gp input msa tree ) ) {
				$params->{$p} = [ body_parameters->get_all($p) ];
			}
			my $pp = bootstrap( 'PhyloViewer::Submit' );

			img_app->current_query->_set_page_params({
				page_id => $prefix . '/phyloviewer',
				menu_group => $prefix
			});

			return template $pp->controller->tmpl, $pp->controller->render( $params );

		};

		# DEMO results page at phylo_viewer/results/demo
		get qr{
			/results/(?<query_id> ( demo | .*) )
		}x => sub {
			my $c = captures;
			my $p = delete $c->{query_id};
			my $module = $p && 'demo' eq $p ? 'ResultsDemo' : 'Results';

			my $tmpl = 'pages/proportal/phylo_viewer/results';

			my $pp = bootstrap( 'PhyloViewer::' . $module );

			img_app->current_query->_set_page_params({
				page_id => $prefix . '/phyloviewer',
				menu_group => $prefix
			});

			return template $pp->controller->tmpl, $pp->controller->render;
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

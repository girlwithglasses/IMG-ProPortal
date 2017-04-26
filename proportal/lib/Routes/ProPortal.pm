package Routes::ProPortal;
use IMG::Util::Import 'Class';
use Dancer2 appname => 'ProPortal';
use ProPortal::Util::Factory;
use AppCorePlugin;
use IMG::Util::File qw( :all );
use File::Spec::Functions;
use Text::CSV_XS;
use File::Temp qw[ tempfile ];
our $VERSION = '0.1.0';

{
	package MiniContr;
	use IMG::Util::Import 'Class';
	with 'IMG::App::Role::Controller', 'ProPortal::IO::ProPortalFilters';
	1;
}

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

# { status => 'success | warning | error',
#	error => ...
#	n_results =>
#	data => [ ... ]
# }

sub no_data_err {
	return { 'status' => 'error', 'message' => 'No data returned by query' };
}


sub output_json {
	my $type = shift;
	my $output = shift;
	if ( 'list' eq $type ) {
		$output = $output->all;
	}
	log_debug { 'output: ' . Dumper $output };
	send_as JSON => $output;
}

sub output_csv {
	my $format = shift;
	my $rslt_type = shift;
	my $obj = shift;

	my $csv_args = {
		eol => $/,
		binary => 1,
		sep_char => ",",
		always_quote => 1
	};
	if ( 'tab' eq $format ) {
		$csv_args->{sep_char} = "\t";
	}

	my $csv = Text::CSV_XS->new ( $csv_args );

	content_type 'text/plain';
	my ($io, $io_name) = tempfile();

	if ( 'list' eq $rslt_type ) {
		my $first = $obj->next;
		my @cols = grep { '__schema' ne $_ } sort keys %$first;

		$csv->print( $io, \@cols );
		$csv->print( $io, [ map { $first->{$_} } @cols  ] );
		while ( my $row = $obj->next ) {
			$csv->print( $io, [ map { $row->{$_} } @cols ] );
		}
	}
	else {
		my @cols = grep { '__schema' ne $_ } sort keys %$obj;
		$csv->print( $io, \@cols );
		$csv->print( $io, [ map { $obj->{$_} } keys %$obj ] );
	}


	output_file( $io_name );
}


sub output_file {
	send_file(
		shift,
		content_type => 'attachment',
		system_path => 1
	);
}


my $output_sub = {
	tab_list =>  sub { return output_csv( 'tab', 'list', @_ ); },
	tab =>       sub { return output_csv( 'tab', 'obj', @_ ); },
	csv_list =>  sub { return output_csv( 'csv', 'list', @_ ); },
	csv =>       sub { return output_csv( 'csv', 'obj', @_ ); },
	json_list => sub { return output_json( 'list', @_ ); },
	json =>      sub { return output_json( 'obj', @_ ); },
	file =>      sub { return output_file( @_ ); },
};

=cut

arguments:

controller:
$args->{cntrl}
OR
$args->{prefix}::$args->{domain}


filters (for list queries)
params  (for details queries)

output_format => ( html | json | csv | file )

menu_group

=cut

sub dispatch {
	my $args = shift;

	log_debug { 'args to dispatcher: ' . Dumper $args };

	my $cntrl = $args->{cntrl} || $args->{prefix} . '::' . $args->{domain};
	my $mode = $args->{output_format} || 'html';

	log_debug { 'mode: ' . $mode };

#	$h->{ $args->{prefix} } . '::' . $h->{ $args->{domain} };

	bootstrap( $cntrl, { output_format => $mode } );

	if ( $args->{filters} ) {
		img_app->set_filters( $args->{filters} );
	}

	my $output;

	# branch off to the API here
	if ( 'html' eq $mode ) {
		img_app->current_query->_set_page_params({
			page_id => img_app->controller->page_id,
			menu_group => $args->{menu_group} || undef
		});

		return template img_app->controller->tmpl, img_app->controller->render( $args->{params} || {} );
	}

	my $rslts = img_app->controller->get_data( $args->{params} || {} );

	# check that we have results
	if ( $cntrl =~ /list/i && $cntrl !~ /file/i ) {
		if ( 0 == $rslts->row_count ) {
			# do something
			log_debug { 'No results for query!' };
		}
		$mode .= '_list';
	}

	return $output_sub->{ $mode }->( $rslts );

}

=head3 make_mini_apps

Make a hash of mini applications for API / instruction pages

@param      array of app IDs

@return     hashref with keys app ID => values mini app object

=cut

sub make_mini_apps {
	my $app_arr = shift;
	my $app_h;

	for ( @$app_arr ) {
#		log_debug { 'item: ' . $_ };
		$app_h->{$_} = MiniContr->new()->add_controller( $_ );
	}
	log_debug { 'app_h: ' . Dumper $app_h };

	return $app_h;
}


# log_debug { 'config: ' . Dumper config };

get '/' => sub {
	forward '/proportal';
};

# any qr{ /.* }x => sub {
any '/offline' => sub {
	return template 'pages/offline';
};

my $output_fmt = {
	url => {
		'/api'     => 'json',
		'/csv_api' => 'csv',
		'/tab_api' => 'tab',
		''         => 'html'
	},
	fmt => {
		html => '',
		json => '/api',
		csv  => '/csv_api',
		tab  => '/tab_api'
	}
};

my @domains = ( qw( gene taxon function scaffold ) );
my @pp_viz  = ( qw( clade data_type ecosystem ecotype location longhurst phylogram big_ugly_taxon_table ) );

for my $mode ( '', '/api', '/csv_api', '/tab_api' ) {

	any qr{^
		$mode
		/?
		$}x => sub {
		pass if '' eq $mode;

# 		log_debug { 'matched ' . $mode . '; forwarding' };
# 		redirect $mode . '/', 302 if $mode;
		log_debug { 'matched ' . $mode . '/?' };
		return template 'pages/api/home.tt', {
			output_format => $output_fmt->{url}{$mode}
		};
	};

# 	any qr{
# 	^$mode
# 	/proportal
# 	/?
# 	$}x => sub {
# 		pass if '' eq $mode;
# 		# proportal API index page here
# 	};

#	for my $q_type ( qw( list details file proportal ) ) {
#		any $mode . '/' . $q_type => sub {
#			log_debug { 'forwarding to ' . $mode . '/' . $q_type . '/' };
#			forward $mode . '/' . $q_type . '/';
#		};
#	}

	prefix $mode => sub {

		# taxon redirects
		any '/taxon/:taxon_oid' => sub {
			redirect $mode . '/details/taxon/' . route_parameters->get('taxon_oid'), 301;
		};

		prefix '/list' => sub {

			for my $domain ( @domains ) {
				prefix '/' . $domain => sub {
					# standard ? query
					get '?' => sub {
						pass if ! scalar query_parameters->keys;
						return dispatch({
							prefix => 'list',
							domain => $domain,
							filters => query_parameters,
							output_format => $output_fmt->{url}{$mode}
						});
					};

					# base query
					any qr{.*}x => sub {

						log_debug { 'matched ' . $mode . '/list/$domain.*' };

						# Instructions page
						return template 'pages/api/list.tt', {
							schema => img_app->filter_schema(':all'),
							queries => [ 'list::' . $domain ],
							apps => make_mini_apps( [ 'list::' . $domain ] ),
							output_format => $output_fmt->{url}{$mode},
							url_prefix => $mode
						};
					};
				};
			}


	# 		API home page
	# 		create the list of valid queries
	# 		for each query, set the controller
	# 		get the valid_filters
			any qr{(?<rest> .*)}x => sub {
				# Instructions page

				log_debug { 'matched ' . $mode . '/list/' . ( captures->{rest} || '' ) };

				my $ids = [ map { 'list::' . $_ } @domains ];
				return template 'pages/api/list.tt', {
					queries => $ids,
					apps => make_mini_apps( $ids ),
					schema => img_app->filter_schema(':all'),
					output_format => $output_fmt->{url}{$mode},
					url_prefix => $mode
				};
			};
		};

		prefix '/details' => sub {

			get '/cycog_version/:version' => sub {
				return dispatch({
					prefix => 'details',
					domain => 'cycog_version',
					params => {
						version => route_parameters->get( 'version' ),
					},
					output_format => $output_fmt->{url}{$mode}
				});
			};

			get '/function/:db/:xref' => sub {
				return dispatch({
					prefix => 'details',
					domain => 'function',
					params => {
						db => route_parameters->get( 'db' ),
						xref => route_parameters->get( 'xref' )
					},
					output_format => $output_fmt->{url}{$mode}
				});
			};

			for my $domain ( qw( gene taxon scaffold function ) ) {

				get '/' . $domain . '/:oid' => sub {

					log_debug { 'matched ' . $mode . '/' . $domain };

					my $params = { $domain . '_oid' => route_parameters->get('oid') };
					if ( $domain eq 'function' ) {
						my @xrefs = split ":", route_parameters->get('dbxref'), 2;
						if ( 2 == scalar @xrefs ) {
							$params = { db => $xrefs[0], xref => $xrefs[1] };
						}
						else {
							# 500 error
						}
					}

					return dispatch({
						prefix => 'details',
						domain => $domain,
						params => $params,
						output_format => $output_fmt->{url}{$mode}
					});
				};

				get qr{
					/$domain
					/?
					$}x => sub {

					log_debug { 'matched ' . $mode . '/details/' . $domain };

					# Instructions page
					return template 'pages/api/details.tt', {
						queries => [ 'details::' . $domain ],
						apps => make_mini_apps( [ 'details::' . $domain ] ),
						schema => img_app->filter_schema(':all'),
						output_format => $output_fmt->{url}{$mode},
						url_prefix => $mode
					};
				}
			}

			get qr{(?<rest> .*)}x => sub {
				# Instructions page

				log_debug { 'matched ' . $mode . '/details' . ( captures->{rest} || '' ) };

				my $ids = [ map { 'details::' . $_ } @domains ];
				return template 'pages/api/details.tt', {
					queries => $ids,
					apps => make_mini_apps( $ids ),
					schema => img_app->filter_schema(':all'),
					output_format => $output_fmt->{url}{$mode},
					url_prefix => $mode
				};
			};
		};


		prefix '/file' => sub {

			any '?' => sub {
				if ( ! scalar query_parameters->keys ) {
					log_debug { 'no query params!' };
					pass;
				}

				if ( query_parameters->{taxon_oid} ) {
					if ( query_parameters->{file_type} ) {

						return dispatch({
							prefix => 'details',
							domain => 'file',
							params => {
								taxon_oid => query_parameters->{taxon_oid},
								file_type => query_parameters->{file_type}
							},
							mode => 'file'
						});
					}
					else {

						bootstrap( 'List::File', { tmpl => 'pages/details/file.tt' } );
						img_app->set_filters( query_parameters );
						if ( '/api' eq $mode ) {
							return output_json( img_app->controller->get_data );
						}
						return template 'pages/details/file.tt', img_app->controller->render;
	#					return template img_app->controller->tmpl, img_app->controller->render;
					}
				}
				else {

	# 				log_debug { 'incomplete params' };
	# 				bootstrap( 'List::File' );
	# 				img_app->set_filters( query_parameters );
	# 				if ( '/api/' eq $mode ) {
	# 					return output_json( img_app->controller->get_data );
	# 				}
	# 				return template img_app->controller->tmpl, img_app->controller->render;

					return dispatch({
						prefix => 'list',
						domain => 'file',
						filters => query_parameters,
						output_format => $output_fmt->{url}{$mode}
					});
				}
			};

# 			any qr{.*}x => sub {
# 				# documentation
# 				log_debug { 'matched ' . $mode . '/file.*' };
# 				return template 'pages/api/file.tt', {
# 					schema => img_app->filter_schema(':all')
# 				};
# 			};
		};

		get qr{/file
			.*
			}x => sub {

			log_debug { 'matched ' . $mode . '/file' };
			bootstrap( 'List::File', { tmpl => 'pages/api/file.tt' } );

			return template img_app->controller->tmpl, {
				schema => img_app->filter_schema(':all'),
				query => {
					base_url => 'file',
					app => img_app,
				},
				output_format => $output_fmt->{url}{$mode},
				url_prefix => $mode
			};
		};

		my $re = join '|', @pp_viz;
		prefix '/proportal' => sub {
			any qr{
				/ (?<query> $re )
				}x => sub {

				log_debug { 'matched /proportal/<query>' } ;
				return dispatch({
					cntrl => captures->{query},
					menu_group => 'proportal',
					filters => query_parameters,
					output_format => $output_fmt->{url}{$mode}
				});
			};
#			get '/' => sub {
			any qr{^/?$}x => sub {

				log_debug { 'matched $mode/proportal /?' } ;

				if ( ! $mode ) {
					return dispatch({
						cntrl => 'Home',
						menu_group => 'proportal',
						mode => ''
					});
				}
				# API home page
				# create the list of valid queries
				# for each query, set the controller
				# get the valid_filters
				img_app->current_query->_set_page_params({
					page_id => 'proportal',
					menu_group => 'proportal'
				});

				return template 'pages/api/proportal.tt', {
					queries => [ @pp_viz ],
					apps => make_mini_apps( \@pp_viz ),
					output_format => $output_fmt->{url}{$mode},
					url_prefix => $mode
				};
			};
		};

# 		any '/proportal' => sub {
# 			log_debug { 'matched /proportal' } ;
# 			# Home page
# 			if ( ! $mode ) {
# 				return dispatch({
# 					cntrl => 'Home',
# 					menu_group => 'proportal',
# 					mode => ''
# 				});
# 			}
# 			pass;
# 		};

		any qr{
			^
			/proportal
			/?
			$}x => sub {

			log_debug { 'matched /proportal /?' };

			# Home page
			if ( ! $mode ) {
				return dispatch({
					cntrl => 'Home',
					menu_group => 'proportal',
					mode => ''
				});
			}

			# API home page
			# create the list of valid queries
			# for each query, set the controller
			# get the valid_filters
			img_app->current_query->_set_page_params({
				page_id => 'proportal',
				menu_group => 'proportal'
			});

			my $page = '/home';
			if ( captures->{pp} && '/proportal' eq captures->{pp} ) {
				$page = captures->{pp};
			}
			return template 'pages/api ' . $page, {
				queries => [ @pp_viz ],
				apps => make_mini_apps( \@pp_viz ),
				output_format => $output_fmt->{url}{$mode},
				url_prefix => $mode
			};
		};

		# API home page
		any qr{^/?$}x => sub {

			log_debug { 'matched ' . $mode . '/?' };

			return template 'pages/api/home.tt', {
				queries => [ @pp_viz ],
				apps => make_mini_apps( [ @pp_viz ] ),
				output_format => $output_fmt->{url}{$mode},
				url_prefix => $mode
			};
		};



		post '/query_runner' => sub {

			log_debug { 'matching the query runner!' };

			my $b_params = body_parameters;
			my $q_params = query_parameters;

			log_debug { 'query: ' . Dumper $q_params };
			log_debug { 'body: ' . Dumper $b_params };

			my $params = {
				domain => [ qw( function gene scaffold taxon ) ],
				prefix => [ qw( file list details ) ],
			};

			# body: bless( {
			#   domain => "taxon",
			#   prefix => "details",
			#   taxon_oid => 637000212
			# }, 'Hash::MultiValue' )
			for my $reqd ( 'domain', 'prefix' ) {
				if ( ! param $reqd ) {
					# invalid query

				}
				elsif ( ! grep { $_ eq param $reqd } @{$params->{$reqd}} ) {
					# invalid parameter
				}
			}
			# now we have the appropriate args, redirect
	#		forward $mode . param "prefix" . '/' . param "domain" .

	# 		return dispatch({
	# 			prefix => param "prefix",
	# 			domain => param "domain",
	#
	# 			mode => 'file'
	# 		});
		};
#=cut

		any '/query_runner' => sub {
			return 'Not a valid page!';
		};

#=cut
	};
}




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
	user_guide => [ qw( api_manual data_documentation browsing getting_started searching using_tools ) ],
	support => [ qw( news about ) ],
	legacy => [ qw( legacy ) ]
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

prefix '/legacy' => sub {
	get qr{ /? }x => sub {
		return template "pages/legacy", { pages => $page_h->{legacy} };
	}
};

1;

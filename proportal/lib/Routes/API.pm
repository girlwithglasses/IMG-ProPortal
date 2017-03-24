package Routes::API;
use IMG::Util::Import 'Class';
use Dancer2 appname => 'ProPortal';
use AppCorePlugin;
use IMG::Util::File qw( :all );
use File::Spec::Functions;
use Text::CSV_XS;

{
	package MiniContr;
	use IMG::Util::Import 'Class';
	with 'IMG::App::Role::Controller';
	1;
}

sub no_data_err {

	return { 'status' => 'error', 'message' => 'No data returned by query' };

}

sub generic {
	my $args = shift;
	my $h = {
		function => 'Function',
		gene => 'Gene',
		taxon => 'Taxon',
		details => 'Details',
		list => 'List'
	};

	my $cntrl = $args->{cntrl} || $h->{ $args->{prefix} } . '::' . $h->{ $args->{domain} };

	if ( $args->{format} ) {
		bootstrap( $cntrl, { output_format => $args->{format} } );
	}
	else {
		bootstrap( $cntrl );
	}

	if ( $args->{filters} ) {
		img_app->set_filters( $args->{filters} );
	}
# 	if ( $args->{format} ) {
# 		img_app->controller->output_format( 'statement' );
# 	}

# 	img_app->current_query->_set_page_params({
# 		page_id => img_app->controller->page_id,
# 		menu_group => $args->{menu_group} || undef
# 	});

	log_debug { 'args: ' . Dumper $args };

	# branch off to the API here
	my $rslt = img_app->controller->get_data( $args->{params} || {} );

	log_debug { 'rslt: ' . Dumper $rslt };


	if ( ! $rslt || ( 'ARRAY' eq ref $rslt && scalar @$rslt == 0 ) ) {
		$rslt = no_data_err();
	}

	if ( $args->{format} ) {
		return output_as( $args->{format}, $rslt );
	}

	content_type 'application/json';
	return JSON->new->convert_blessed(1)->encode( $rslt );

}

prefix '/api' => sub {

	my @valid_queries = qw( location clade data_type phylogram ecosystem ecotype big_ugly_taxon_table );

	my @pp_subsets = qw( metagenome isolate pro syn other pro_phage syn_phage other_phage );

	my $re = join '|', @valid_queries;

	# filterable queries
	get qr{
		(/proportal)?
		/ (?<query> $re )
		}x => sub {
			return generic({
				cntrl => captures->{query},
				filters => query_parameters
			});
	};

	# ProPortal query access page
	get qr{
		(/proportal)?
		/? }x => sub {
		# for each query, set the controller
		# get the valid_filters
		my $v_q;
		for ( @valid_queries ) {
			$v_q->{$_} = MiniContr->new()->add_controller( $_ );
		}
		img_app->current_query->_set_page_params({
			page_id => 'proportal',
			menu_group => 'proportal'
		});
		return template 'pages/api/home', { queries => [ @valid_queries ], pp_subsets => [ @pp_subsets ], apps => $v_q };
	};

	prefix '/list/' => sub {
		for my $domain ( qw( gene taxon function ) ) {
			prefix $domain => sub {
				# base query
				any qr{
					^/?$
					}x => sub {
					# Instructions page?
					return generic({ prefix => 'list', domain => $domain });
				};

				# standard ? query
				get '?' => sub {
					return generic({
						prefix => 'list',
						domain => $domain,
						filters => query_parameters
					});
				};
			};
		}
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
				params => { captures->{domain} . '_oid' => captures->{oid} }
			});
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

	prefix '/csv_list/' => sub {
		for my $domain ( qw( gene taxon function ) ) {
			prefix $domain => sub {
				# base query
				any qr{
					^/?$
					}x => sub {
					# Instructions page?
					return generic({ prefix => 'list', domain => $domain });
				};

				# standard ? query
				get '?' => sub {
					return generic({
						prefix => 'list',
						domain => $domain,
						filters => query_parameters,
						format => 'csv'
					});
				};
			};
		}
	};

	prefix '/list/file' => sub {



	};

	prefix '/details/file' => sub {

		any '/taxon?' => sub {

			log_debug { 'no query params!' } && pass if ! scalar query_parameters->keys;

			bootstrap( 'Details::File' );
# 			if ( $args->{filters} ) {
# 				img_app->set_filters( $args->{filters} );
# 			}
			my $file = img_app->controller->get_data( query_parameters );

			send_file(
				$file,
				content_type => 'attachment',
				system_path => 1
			);
		};

		any qr{.*}x => sub {
				return template 'pages/api/details_file_taxon.tt', { schema => { file_type => img_app->filter_schema('file_type') } };
		};

	};
};

sub output_as {
	my $format = shift;
	my $sth = shift;

	my $csv = Text::CSV_XS->new ({ binary => 1, eol => "\r\n" });
	content_type 'text/plain';
	log_debug { Dumper $sth->{sth} };
#	$sth->refine( -result_as => 'flat_arrayref' );
	say	$sth->row_count;
	$csv->print( *STDOUT, $sth->{sth}{NAME_lc} );
	while ( my $row = $sth->next ) {
		$csv->print( *STDOUT, $row );
	}
}

1;

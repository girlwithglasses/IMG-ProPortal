package Routes::API;
use IMG::Util::Import 'Class';
use Dancer2 appname => 'ProPortal';
use AppCorePlugin;
use IMG::Util::File qw( :all );
use File::Spec::Functions;

{
	package MiniContr;
	use IMG::Util::Import 'Class';
	with 'IMG::App::Role::Controller';
	1;
}

sub generic {
	my $args = shift;

	my $h = {
		gene => 'Gene',
		taxon => 'Taxon',
		details => 'Details',
		list => 'List'
	};


	bootstrap( $h->{ $args->{prefix} } . '::' . $h->{ $args->{domain} } );

	img_app->current_query->_set_page_params({
		page_id => img_app->controller->page_id
	});

	log_debug { 'args: ' . Dumper $args };

	my $rslt = img_app->controller->get_data( $args->{params} );

	if ( ! $rslt ) {
		$rslt = { 'error' => 001, 'message' => 'No data returned by query' };
	}

	content_type 'application/json';

	return JSON->new->convert_blessed(1)->encode( $rslt );

#	return template img_app->controller->tmpl, img_app->controller->render( $args->{params} );

}

prefix '/api' => sub {

	my @valid_queries = qw( location clade data_type phylogram ecosystem ecotype big_ugly_taxon_table );

	my @pp_subsets = qw( metagenome isolate pro syn pro_phage syn_phage );

	my $re = join '|', @valid_queries;

	# filterable queries
	get qr{
		/ (?<page> $re )
		/? (?<pp_subset> \w+.* )?
		}x => sub {

		my $c = captures;
		my $p = delete $c->{page};

		bootstrap( $p );

		if ( $c->{pp_subset} ) {
			img_app->set_filters({ pp_subset => $c->{pp_subset} });
		}

		my $rslt = img_app->controller->get_data();

		if ( ! $rslt ) {
			$rslt = { 'error' => 001, 'message' => 'No data returned by query' };
		}

		content_type 'application/json';

		return JSON->new->convert_blessed(1)->encode( $rslt );

#		return $json;
	};


	get qr{ /? }x => sub {

		# for each query, set the controller
		# get the valid_filters
		my $v_q;
		for ( @valid_queries ) {
			$v_q->{$_} = MiniContr->new()->add_controller( $_ );
		}

		img_app->current_query->_set_menu_group( 'proportal' );
		img_app->current_query->_set_page_id( 'proportal' );
		return template 'pages/api_home', { queries => [ @valid_queries ], pp_subsets => [ @pp_subsets ], apps => $v_q };

	};

	prefix "/list/" => sub {

		for my $domain ( qw( gene taxon ) ) {

			prefix $domain => sub {
				# base query
				get qr{
					^/?$
					}x => sub {
					return generic({ prefix => 'list', domain => $domain });
				};

				# standard ? query
				get '?:stuff' => sub {

					return generic({ prefix => 'list', domain => $domain, params => query_parameters });
				};
			};
		}
	};


	prefix "/details/" => sub {

		get qr{
			(?<domain> gene | taxon )
			[\?/]
			(?<oid> .* )
			/?
			}x => sub {

				return generic({
					prefix => 'details',
					domain => captures->{domain},
					params => { captures->{domain} . '_oid' => captures->{oid} } });
		};
	};


};



sub return_json {



}

sub return_csv {



}

1;

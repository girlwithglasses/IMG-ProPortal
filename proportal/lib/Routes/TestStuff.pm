package Routes::TestStuff;
use Dancer2 appname => 'ProPortal';
use IMG::Util::Import 'LogErr';
use AppCorePlugin;
use IMG::Util::File qw( :all );
use File::Spec::Functions;
# use JSON::MaybeXS;

prefix '/cart' => sub {
	any '/genomes/add' => sub {

		log_debug { 'body params: ' . Dumper body_parameters };
		my @tax_arr = body_parameters->get_all('taxon_oid[]');

		my $self = img_app;

		return $self->schema('img_core')->table('Gene')
			->select(
				-columns => [ qw( gene_oid gene_symbol gene_display_name product_name locus_tag locus_type scaffold description taxon|taxon_oid obsolete_flag ) ],
				-where   => { gene_oid => [ @tax_arr ] },
				-result_as => [ 'hashref' => ( 'gene_oid' ) ]
			);


		return join "<br>", @tax_arr;
		require GenomeCart;
		GenomeCart::addToGenomeCart( \@tax_arr );
		GenomeCart::dispatch();
	};
};

for my $f ( qw[ demo ] ) {

	prefix "/$f" => sub {

		# get the pages in the directory '/views/pages/$f' (minus the index)
		my @pages = sort map { s/\.tt//; $_ }
			@{ get_dir_contents({ dir => catdir( config->{views}, 'pages', $f ), filter => sub { $_ !~ /index/ && $_ !~ /^\./ && -f catfile( config->{views}, 'pages', $f, $_ ) } }) };

		my $re = join '|', @pages;

		get qr{

			/ (?<page_name> $re )

			}x => sub {

			my $c = captures;
			my $p = delete $c->{page_name};

			return template "pages/$f/$p";
		};

		get qr{ /? }x => sub {

			return template "pages/$f/index", { pages => [ @pages ] };

		}
	};
}

# {
# 	package MiniContr;
# 	use IMG::Util::Import 'Class';
# 	with qw(
# 		IMG::App::Role::Controller
# 		IMG::App::Role::ErrorMessages
# 	);
# 	1;
# }

# prefix '/api/proportal' => sub {
#
# 	my @valid_queries = qw( location clade data_type phylogram ecosystem ecotype big_ugly_taxon_table );
#
# 	my @pp_subsets = qw( metagenome isolate prochlor synech prochlor_phage synech_phage );
#
# 	my $re = join '|', @valid_queries;
#
# 	# filterable queries
# 	get qr{
# 		/ (?<page> $re )
# 		/? (?<pp_subset> \w+.* )?
# 		}x => sub {
#
# 		my $c = captures;
# 		my $p = delete $c->{page};
#
#
# 		bootstrap( $p );
# 		if ( $c->{pp_subset} ) {
# 			img_app->set_filters({ pp_subset => $c->{pp_subset} });
# 		}
#
# 		my $rslt = img_app->get_data();
#
# 		if ( ! $rslt ) {
# 			$rslt = { 'error' => 001, 'message' => 'No data returned by query' };
# 		}
#
# 		log_debug { Dumper $rslt };
#
# 		content_type 'application/json';
#
# 		my $json = JSON->new->convert_blessed(1)->encode( $rslt );
#
# 		return $json;
# 	};
#
#
# 	get qr{ /? }x => sub {
#
# 		var menu_grp => 'proportal';
# 		var page_id => 'proportal';
# 		# for each query, set the controller
# 		# get the valid_filters
# 		my $v_q;
# 		for ( @valid_queries ) {
# 			my $app = MiniContr->new();
# 			$app->add_controller( $_ );
# #			log_debug { $_ . ' controller: ' . Dumper $app->controller };
# 			$v_q->{$_} = $app->controller->valid_filters;
# 		}
#
# 		my $results = {
# 			valid => $v_q,
# 			queries => [ @valid_queries ],
# 			pp_subsets => [ @pp_subsets ]
# 		};
#
# 		log_debug { 'results: ' . Dumper $results };
#
# 		return template 'pages/datamart_stats', $results;
#
# 	}
# };

any '/blastoff' => sub {
	return '3... 2... 1... blast off!';
};


get '/test' => sub {

	img_app->current_query->_set_menu_group( 'proportal' );
	img_app->current_query->_set_page_id( 'proportal/test' );

	return template 'pages/test', {};

};


=cut

#use AnyEvent;
use AE;

get '/delayed' => sub {

	my %timers;
	my $count = 5;
    my $t;

	debug 'starting some async cool stuff!';

	delayed {

		debug "Stretching...\n";

        flush;
#=cut
        use IMG::App::Role::Templater;
        IMG::App::Role::Templater::init_env({ base_dir => '/Users/gwg/webUI/proportal' });

        $t = AnyEvent->timer(after => 5, cb => delayed {
            undef $t;
            content "I said this from within an event loop. Woohoo!";
            done;
        });


        my $output = IMG::App::Role::Templater::render_template({ tmpl => 'any_content.tt' });
        content $output;

#=cut
        debug 'ready to output some more stuff at ' . localtime();
        content 'I wrote this at ' . localtime();

        $timers{'Snare'} = AE::timer 1, 1, delayed {
            $timers{'HiHat'} ||= AE::timer 0, 0.5, delayed {
                debug 'Hi hat is doing its stuff at ' . localtime();
                content "Tss...\n";
            };

            content "Bap!\n";

            if ( $count-- == 0 ) {
                %timers = ();
                content "Tugu tugu tugu dum!\n";

                debug 'we should be finished now';

                done;

                print "<enter sound of applause>\n\n";
                $timers{'Applause'} = AE::timer 3, 0, sub {
                    # the DSL will not available here
                    # because we didn't call the "delayed" keyword
                    debug 'here is some applause';
                    print "<applause dies out>\n";
                };
            }
        };
    };
};

=cut

1;

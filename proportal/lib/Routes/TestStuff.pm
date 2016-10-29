package Routes::TestStuff;
use IMG::Util::Base;
use Dancer2 appname => 'ProPortal';
use parent 'AppCore';
use IMG::Util::File qw( :all );
use File::Spec::Functions;

prefix '/tools' => sub {

	my @tools = qw( krona jbrowse galaxy phyloviewer );
	my $re = join '|', @demo_pages;

	get qr{
		/ (?<tool> $re )
	}x => sub {

		return template "pages/tools/" . captures->{tool};

	};
};

prefix '/cart' => sub {
	any '/genomes/add' => sub {

		say Dumper body_parameters;
		my @tax_arr = body_parameters->get_all('taxon_oid[]');
		return join "<br>", @tax_arr;
		require GenomeCart;
		GenomeCart::addToGenomeCart( \@tax_arr );
		GenomeCart::dispatch();
	};
};

prefix '/demo' => sub {

	# get the demo pages in the directory '/views/pages/demo' (minus the index)
	my @demo_pages = sort map { s/\.tt//; $_ }
		@{ get_dir_contents({ dir => catdir( config->{views}, 'pages/demo' ), filter => sub { $_ !~ /index/ && -f catfile( config->{views}, 'pages/demo', $_ ) } }) };

	my $re = join '|', @demo_pages;

	get qr{

		/ (?<demo> $re )

		}x => sub {

		my $c = captures;
		my $p = delete $c->{demo};

		return template "pages/demo/$p";
	};

	get qr{ /? }x => sub {

		var menu_grp => 'proportal';
		var page_id => 'proportal';
		return template 'pages/demo/index', { pages => [ @demo_pages ] };

	}
};


{
	package MiniContr;
	use IMG::Util::Base 'Class';
	with 'IMG::App::Role::Controller';
	1;
}

prefix '/api/proportal' => sub {

	my @valid_queries = qw( location clade data_type phylogram ecosystem ecotype big_ugly_taxon_table );

	my @subsets = qw( metagenome isolate prochlor synech prochlor_phage synech_phage );

	my $re = join '|', @valid_queries;

	# filterable queries
	get qr{
		/ (?<page> $re )
		/? (?<subset> \w+.* )?
		}x => sub {

		my $c = captures;
		my $p = delete $c->{page};


		my $pp = AppCore::bootstrap( $p );
		if ( $c->{subset} ) {
			$pp->set_filters({ subset => $c->{subset} });
		}

		my $rslt = $pp->get_data();

		if ( ! $rslt ) {
			$rslt = { 'error' => 001, 'message' => 'No data returned by query' };
		}

		say Dumper $rslt;

		content_type 'application/json';

		my $json = JSON->new->convert_blessed(1)->encode( $rslt );

		return $json;
	};


	get qr{ /? }x => sub {

		# for each query, set the controller
		# get the valid_filters
		my $v_q;
		for ( @valid_queries ) {
			my $app = MiniContr->new();
			$app->add_controller_role( $_ );
			say $_ . ' controller: ' . Dumper $app->controller;
			$v_q->{$_} = $app->controller->valid_filters;
		}

		say 'valid filters: ' . Dumper $v_q;

		var menu_grp => 'proportal';
		var page_id => 'proportal';
		return template 'pages/datamart_stats', { queries => [ @valid_queries ], subsets => [ @subsets ] };

	}
};

any '/blastoff' => sub {
	return '3... 2... 1... blast off!';
};


get '/test' => sub {

    var menu_grp => 'proportal';
    var page_id => 'proportal/test';

    template 'pages/test', {};

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

package Routes::TestStuff;
use IMG::Util::Base;
use Dancer2 appname => 'ProPortal';
use parent 'CoreStuff';

#use AnyEvent;
use AE;

any '/blastoff' => sub {
	return '3... 2... 1... blast off!';
};


get '/test' => sub {

    var menu_grp => 'proportal';
    var page_id => 'proportal/test';

    template 'pages/test', {};

};


get '/delayed' => sub {

	my %timers;
	my $count = 5;
    my $t;

	debug 'starting some async cool stuff!';

	delayed {

		debug "Stretching...\n";

        flush;
=cut
        use IMG::App::Role::Templater;
        IMG::App::Role::Templater::init_env({ base_dir => '/Users/gwg/webUI/proportal' });

        $t = AnyEvent->timer(after => 5, cb => delayed {
            undef $t;
            content "I said this from within an event loop. Woohoo!";
            done;
        });


        my $output = IMG::App::Role::Templater::render_template( 'any_content.tt', {} );
        content $output;

=cut
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


1;

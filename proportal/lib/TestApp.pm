package TestApp;
use IMG::Util::Import;

use AE;
use Dancer2;
use Dancer2::Plugin::Ajax;
use AnyEvent;

# ajax '/ajax' => sub {
#
# 	return 'got an ajax query!';
#
# };
#

get '/ajax' => sub {

	return 'called for some AJAX!';

};

get '/delayed' => sub {
    my %timers;
    my $count = 15;
    delayed {
        debug "Stretching...\n";
        flush;

        $timers{'Snare'} = AE::timer 1, 1, delayed {

#            flush;
            content "Bap!\n";
            debug 'Count is ' . $count;

            $timers{'HiHat'} ||= AE::timer 0, 0.5, delayed {
    #            flush;
                content "Tss...\n";
                debug 'That is the hi-hat; count is ' . $count;
            };

            if ( $count-- == 0 ) {
                %timers = ();
    #            flush;
                content "Tugu tugu tugu dum!\n";
                done;

                debug "<enter sound of applause>\n\n";
                $timers{'Applause'} = AE::timer 3, 0, sub {
                    # the DSL will not available here
                    # because we didn't call the "delayed" keyword
                    print "<applause dies out>\n";
                };
            }
        };
    };
};

1;

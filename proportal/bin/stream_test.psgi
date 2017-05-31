#!/usr/bin/env perl
use strict;
use warnings;
use feature ':5.16';
use Dancer2;
use AnyEvent;

my %timers;
my $count = 5;
get '/drums' => sub {

    say "starting...";

    delayed {

        print "Stretching...\n";
        flush;

        $timers{'Snare'} = AE::timer 1, 1, delayed {
            $timers{'HiHat'} ||= AE::timer 0, 0.5, delayed {
                content "Tss...\n";
            };

            content "Bap!\n";

            if ( $count-- == 0 ) {
                %timers = ();
                content "Tugu tugu tugu dum!\n";
                done;

                print "<enter sound of applause>\n\n";
                $timers{'Applause'} = AE::timer 3, 0, sub {
                    # the DSL will not available here
                    # because we didn't call the "delayed" keyword
                    print "<applause dies out>\n";
                };
            }
        };
    };
};

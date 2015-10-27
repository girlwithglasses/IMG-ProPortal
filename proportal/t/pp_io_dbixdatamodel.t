#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";
use IMG::Util::Base 'Test';

use ProPortal::IO::DBIxDataModel;

{
    package TestApp;
    use IMG::Util::Base 'Class';
    has 'schema' => ( is => 'ro' );
    has 'user' => ( is => 'ro' );
    with 'ProPortal::IO::DBIxDataModel';
    1;
}

subtest 'filters' => sub {

    ok( my $test = TestApp->new(), 'new test app' );

    throws_ok { $test->subset_filter() } qr[No filters supplied!];

    throws_ok { $test->subset_filter( 'blob' ) } qr[Filter 'blob' not found];

    my $filters;
    for ( qw( prochlor synech prochlor_phage synech_phage ) ) {
        my $f = $test->subset_filter( $_ );
        push @$filters, $f->{-where};
    }
    is_deeply( $test->subset_filter('isolates'), { -where => $filters }, 'Checking isolate filter' ) or diag explain $test->subset_filter('isolates');

    my $mg = $test->subset_filter('metagenomes');
    push @$filters, $mg->{-where};

    is_deeply( $test->subset_filter('datamart'), { -where => $filters }, 'Checking datamart filter' ) or diag explain $test->subset_filter('datamart');


};

done_testing;

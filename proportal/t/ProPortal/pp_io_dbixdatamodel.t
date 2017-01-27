#!/usr/bin/env perl
my $dir;
my @dir_arr;

BEGIN {
	$ENV{'DANCER_ENVIRONMENT'} = 'testing';
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	$dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib proportal/t/lib );
}

use lib @dir_arr;
use IMG::Util::Import 'Test';
use Dancer2;
use Carp::Always;

{
	package TestApp;
	use IMG::Util::Import 'Class';
	use Dancer2;
	extends 'IMG::App';
	with qw(
		ProPortal::IO::DBIxDataModel
		ProPortal::IO::ProPortalFilters
	);

	1;
}

my $msg;
ok( my $test = TestApp->new( config => config ), 'new test app' );


subtest 'filters' => sub {
	subtest 'error states' => sub {

		$msg = err({
			err => 'missing',
			subject => 'DBIxDataModel statement object'
		});
		throws_ok {
			$test->add_filters({});
		} qr[$msg];

		$msg = err({
			err => 'missing',
			subject => 'filter'
		});
		throws_ok { $test->subset_filter() } qr[$msg];

		$msg = err({
			err => 'invalid',
			subject => 'blob',
			type => 'subset filter'

		});
		throws_ok { $test->subset_filter( 'blob' ) } qr[$msg];

	};

	subtest 'valid' => sub {

		# without a filter, the statement is returned unchanged
		ok(
			'statement' eq $test->add_filters({ statement => 'statement' }),
			'no filters'
		);

		my $filters;
		for ( qw( prochlor synech prochlor_phage synech_phage ) ) {
			my $f = $test->subset_filter( $_ );
			push @$filters, $f->{-where};
		}
		is_deeply(
			$test->subset_filter('isolates'),
			{ -where => $filters },
			'Checking isolate filter'
		) or diag explain $test->subset_filter('isolates');

		my $mg = $test->subset_filter('metagenomes');
		push @$filters, $mg->{-where};

		is_deeply(
			$test->subset_filter('all_proportal'),
			{ -where => $filters },
			'Checking all_proportal filter'
		) or diag explain $test->subset_filter('all_proportal');
	};

};

subtest 'check_results' => sub {
	my $p = prep_results();
	subtest 'error states' => sub {

		$msg = err({
			err => 'missing',
			subject => 'check_results parameter "query"'
		});
		throws_ok {
			$test->check_results({ results => [], param => 'blob' });
		} qr[$msg];

		$msg = err({
			err => 'no_results',
			subject => 'trouble'
		});
		throws_ok {
			$test->check_results({ results => [], query => [], param => 'trouble', subject => 'trouble' });
		} qr[$msg];

		$msg = err({
			err => 'missing_results',
			subject => 'gene_oid',
			ids => [ 666, 911 ]
		});
		throws_ok {
			$test->check_results({
				results => $p->{results},
				query => $p->{bad_query},
				param => 'gene_oid',
				subject => 'gene_oid'
			});
		} qr[$msg];
	};

	subtest 'valid' => sub {
		is_deeply(
			$test->check_results({
				results => $p->{results},
				query => $p->{full_query},
				param => 'gene_oid',
				subject => 'gene_oid'
			}),
			$p->{results},
			'Checking results are returned'
		);
	};
};


sub prep_results {
	return {
		results => [
			{ gene_oid => 637449936, taxon_oid => 637000214 },
			{ gene_oid => 637686988, taxon_oid => 637000212 },
			{ gene_oid => 637686994, taxon_oid => 637000212 },
			{ gene_oid => 640078650, taxon_oid => 640069321 }
		],
		full_query => [ 637686994, 640078650, 637449936, 637686988 ],
		bad_query => [ 637686994, 911, 640078650, 637449936, 637686988, 666 ],
	};
}

done_testing;

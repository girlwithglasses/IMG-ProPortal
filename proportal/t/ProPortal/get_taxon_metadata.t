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

use ProPortal::App::GetTaxonMetadata;

sub new_app {
	my %args = @_;
	return ProPortal::App::GetTaxonMetadata->new( config => config, args => \%args );
}

my $app;
my $msg;

subtest 'instantiation' => sub {

	my ( $fh, $fn ) = tempfile( UNLINK => 1 );

	my @arr = ( 12345, 23456, 34567, 45678, 56789 );
	print { $fh } join "\n", ( @arr, ' ' );
	close $fh;

	my ( $fh1, $fn1 ) = tempfile( UNLINK => 1 );
	my ( $no_data, $no_data_n ) = tempfile( UNLINK => 1 );
	print { $fh1 } join ( "\t", qw( taxon_oid gene_oid pip pap pop ) ) . "\n";
	print { $fh1 } join "\n",
		map {
			join "\t", ( $_, 'pop', '555', $_, 'pip' )
		} ( @arr, ' ' );
	close $fh1;

	print { $no_data } join ( "\t", qw( taxon_oid gene_oid pip pap pop ) ) . "\n\n";

	close $no_data;

	my ( $fh2, $fn2 ) = tempfile( UNLINK => 1 );
	my $file;

	subtest 'error states' => sub {

		$file = test_wo_file();
		$msg = err({
			err => 'not_readable',
			subject => $file
		});
		throws_ok {
			$app = new_app( infile => $file, outfile => $fn2 );
			$app->args->taxon_oid;
		} qr[$msg];

		throws_ok {
			$app = new_app( infile => $file, outfile => $fn2, infile_format => 'arr' );
			$app->args->taxon_oid;
		} qr[$msg];

		throws_ok {
			$app = new_app( infile => $file, outfile => $fn2, infile_format => 'tsv' );
			$app->args->taxon_oid;
		} qr[$msg];

		$file = test_ro_file();
		$msg = err({
			err => 'not_writable',
			subject => $file,
		});
		throws_ok {
			$app = new_app( infile => $fn2, outfile => $file );
		} qr[$msg];

		# empty input file
		$msg = err({
			err => 'not_found_in_file',
			subject => 'taxon_oids',
			file => $file
		});
		throws_ok {
			$app = new_app( infile => $file, outfile => $fn2 );
			$app->args->taxon_oid;
		} qr[$msg];

		throws_ok {
			$app = new_app( infile => $file, outfile => $fn2, infile_format => 'arr' );
			$app->args->taxon_oid;
		} qr[$msg];

		$app = new_app( infile => $file, outfile => $fn2, infile_format => 'tsv' );
		isa_ok( $app, 'ProPortal::App::GetTaxonMetadata' );
		$msg = err({
			err => 'module_err',
			subject => 'Text::CSV_XS',
			msg => "INI - the header is empty"
		});
		throws_ok {
			$app->args->taxon_oid;
		} qr[$msg];


		# no results
		$msg = err({
			err => 'no_results',
			subject => 'taxon_oids'
		});
		throws_ok {
			$app = new_app(
				infile => $file, outfile => $fn2, taxon_oid => [ 1, 2, 3 ]
			)->run();
		} qr[$msg];

		say 'Header line only!';
		$msg = err({
			err => 'not_found_in_file',
			subject => 'taxon_oids',
			file => $no_data_n
		});
		throws_ok {
			new_app(
				infile => $no_data_n, outfile => $fn2, infile_format => 'tsv'
			)->args->taxon_oid;
		} qr[$msg];

		# missing results
		$msg = err({
			err => 'missing_results',
			subject => 'taxon_oids',
			ids => [ 666, 911 ]
		});
		throws_ok {
			$app = new_app( infile => $file, outfile => $fn2, taxon_oid => [ 637000212, 637000214, 640069321, 640069322, 640069323, 640069324, 640753041, 647533199, 2551306553, 2551306560, 666, 911 ] );
			$app->run();
		} qr[$msg];

		# invalid infile format
		$msg = err({
			err => 'invalid_enum',
			subject => 'blob',
			type => 'input format',
			enum => $app->args->valid_infile_formats
		});
		throws_ok {
			$app = new_app( infile => $fn, outfile => $fn2, infile_format => 'blob' );
		} qr[$msg];

		# no taxon_oid header col
		$msg = err({
			err => 'not_found_in_file',
			subject => '"taxon_oid" header',
			file => $fn
		});
		throws_ok {
			new_app( infile => $fn, outfile => $fn2, infile_format => 'tsv' )->args->taxon_oid;
		} qr[$msg];

		$app = new_app( infile => catfile( $dir, 'proportal/t/files/gene_cart.tsv' ), outfile => $fn2, infile_format => 'tsv' );

		is_deeply(
			[ sort @{$app->args->taxon_oid} ],
			[ 637000210, 637000211, 637000212, 637000213 ],
			'Checking taxon IDs set correctly'
		) or diag explain $app->args->taxon_oid;


	};

	subtest 'valid' => sub {
		$app = new_app( infile => $fn, outfile => $fn . '_out' );

		isa_ok( $app->args->outfh, 'GLOB', 'Checking the outfile is OK' );
		is_deeply(
			\@arr,
			$app->args->taxon_oid,
			'Checking taxon array is correct'
		) or diag explain $app->args->taxon_oid;
	};
};


done_testing();


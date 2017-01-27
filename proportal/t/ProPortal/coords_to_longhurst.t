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
use ProPortal::App::CoordsToLonghurst;
my $file_dir = catdir( $dir, 'proportal/t/files' );
my $lh_f = catfile( $dir, 'proportal/t/files/longhurst.xml' );
my $single_lhf = catfile( $dir, 'proportal/t/files/single-longhurst.xml' );

sub new_app {
	if ( $_[0] && 'auto' eq $_[0] ) {
		my ( $fh, $fn ) = tempfile( UNLINK => 1 );
		my %args = (
			outfile => $fn,
			infile  => $fn
		);
		shift @_;
		%args = ( %args, @_ );
		return ProPortal::App::CoordsToLonghurst->new( args => \%args );
	}
	return ProPortal::App::CoordsToLonghurst->new( args => \@_ );
}

my $app;
my $msg;

subtest 'instantiation' => sub {

	subtest 'errors' => sub {

		$msg = 'coercion for "args" failed';
		throws_ok {
			new_app( longhurst_file => 'this_file' );
		} qr[$msg];

	};

	subtest 'valid' => sub {

		isa_ok(
			new_app( 'auto', longhurst_file => $lh_f )->args->outfh,
			'GLOB'
		);

		my ( $fh, $fn ) = tempfile( UNLINK => 1 );
		ok( $fn eq new_app( 'auto', longhurst_file => $lh_f, infile => $fn )->args->infile, 'Checking the file name is correct' );


	};

};

my $tests = {
error => [
{
	err => { err => 'missing', subject => 'region' },
	args => {},
	desc => 'missing region'
},
{
	err => { err => 'missing', subject => 'fid' },
	args => { region => []},
	desc => 'missing fid'
}
]};



subtest 'make polygons' => sub {

	subtest 'errors' => sub {

		for my $t ( @{$tests->{error}} ) {
			$msg = err($t->{err});
			my $app;
			throws_ok {
				$app = new_app( 'auto', longhurst_file => $lh_f );
				$app->make_polygons( $t->{args} )
			} qr[$msg], $t->{desc};

		}


	};

	subtest 'valid' => sub {



	};

};

subtest 'read longhurst file' => sub {

# 	subtest 'errors' => sub {
#
#
# 	};

	subtest 'valid' => sub {

		# check that the splitting works
		my $str = '-86.49999958,-55.49999956 -69.49999957,0.50000049';

		my @b_arr = map { [ split ',', $_ ] } split ' ', $str;

		is_deeply(
			[ [-86.49999958 , -55.49999956], [-69.49999957,0.50000049] ],
			\@b_arr,
			'checking coord parsing'
		);


		$app = new_app( 'auto', 'longhurst_file' => $single_lhf );
		my $h = $app->read_longhurst_file;
		my $rslt = $h->{'longhurst.1'};
		# check the bounding box
		is_deeply(
			$app->map_bb,
			{	x1 => -180,
				y1 => -79,
				x2 => 180,
				y2 => 90
			},
			'checking bounding box read correctly') or diag explain $app->map_bb;

		say Dumper $rslt;

		ok( 'FKLD' eq $rslt->{code} && 'Coastal - SW Atlantic Shelves Province' eq $rslt->{name}, 'Checking name and code' );
		my $coords = $rslt->{x1} . ',' . $rslt->{y1}
		. ' ' . $rslt->{x2} . ',' . $rslt->{y2};
		ok( '-70.49999957,-55.49999956 -51.49999955,-38.49999954' eq $coords, 'Checking coords' ) or diag explain $coords;


	};

};

done_testing();

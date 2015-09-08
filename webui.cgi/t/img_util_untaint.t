#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib ( "$Bin/..", "$Bin/../../proportal/lib", "$Bin/lib" );
use IMG::Util::Base 'Test';
use IMG::Util::Untaint;
use File::Spec::Functions qw( splitpath catdir catfile );
use File::Temp qw/tempfile/;

use Test::Taint;

subtest 'test of no return' => sub {

	throws_ok { IMG::Util::Untaint::check_path() } qr[No path specified];
	throws_ok { IMG::Util::Untaint::check_file() } qr[No file specified];
	throws_ok { IMG::Util::Untaint::_check_file_name() } qr[No file name specified];

	my ($fh, $fname) = tempfile();
	throws_ok { IMG::Util::Untaint::check_path( $fh ) } qr[No path specified];
	throws_ok { IMG::Util::Untaint::check_file( $fh ) } qr[No file specified];
	throws_ok { IMG::Util::Untaint::_check_file_name( $fh ) } qr[No file name specified];

	ok( '0' eq IMG::Util::Untaint::check_path( 0 ) );
	ok( '0' eq IMG::Util::Untaint::check_file( 0 ) );
	ok( '0' eq IMG::Util::Untaint::_check_file_name( 0 ) );

	ok( '' eq IMG::Util::Untaint::check_path('') );
	ok( '' eq IMG::Util::Untaint::check_file('') );
	ok( '' eq IMG::Util::Untaint::_check_file_name('') );

};

my @server = split ':', '/usr/common/usg/languages/perl/5.16.0/bin:/usr/common/usg/languages/gcc/4.6.3_1/bin:/global/common/genepool/usg/languages/R/3.0.1/bin:/usr/common/usg/utilities/curl/7.26.0/bin:/usr/common/usg/languages/java/jdk/oracle/1.7.0_51_x86_64/bin:/usr/common/jgi/aligners/clustal-omega/1.1.0/bin:/usr/common/jgi/aligners/clustalw/2.1/bin:/usr/common/usg/languages/python/2.7.4/bin:/usr/common/usg/utilities/mysql/5.0.96_1/bin:/usr/common/jgi/frameworks/EMBOSS/6.4.0/bin:/global/homes/a/aireland/perl5/bin:/usr/common/usg/languages/python/2.7.4/bin:/usr/common/usg/languages/perl/5.16.0/bin:/usr/common/usg/utilities/mysql/5.0.96_1/bin:/usr/common/usg/languages/gcc/4.6.3_1/bin:/usr/common/jgi/oracle_client/11.2.0.3.0/client_1/bin:/usr/common/usg/languages/java/jdk/oracle/1.7.0_51_x86_64/bin:/usr/common/usg/bin:/usr/common/mss/bin:/usr/common/nsg/bin:/opt/uge/genepool/uge/bin/lx-amd64:/usr/syscom/nsg/bin:/usr/syscom/nsg/opt/Modules/3.2.10/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games';

my %paths = (
	invalid => [
		'not\ a\ valid\ path',
		'/files/html/*/0',
		'files/../html',
		'opt[local]lib',
		'this path is not valid',
	],
	valid => [
		'',
		'/',
		'~/files/html/',
		'/opt/local/files.html',
		'/opt/dir-name-with-hyphens/dot.com/',
		@server
	],
);

my %f_names = (
	invalid => [
		'my_favourite_kitten:pics.pdf',
		'what\ next?',
		'not,a,valid,filename',
		'also;invalid',
		'+=#$%'
	],
	valid => [
		'cscan',
		'123456.789',
		'holy-guacamole',
		'this..one..is..ok',
		'0',
	],
);

subtest 'invalid paths' => sub {

	taint_deeply( @{$paths{invalid}} );

	for my $p ( @{$paths{invalid}} ) {
		#simulate taint
		taint( $p );
	#	tainted_ok( $p, 'Checking path is tainted' );
		throws_ok { IMG::Util::Untaint::check_path( $p ) }
			qr/check_path: invalid path/,
			"Invalid path via check_path: '$p'";

#		tainted_ok( $p, 'Checking path is tainted' );
		my $err_msg = 'check_path: invalid path';
		if ( $p !~ m!/! ) {
			$err_msg = '_check_file_name: invalid name';
		}
		throws_ok { IMG::Util::Untaint::check_file( $p ) }
			qr[$err_msg],
			"Invalid path/file via check_file: '$p'";
	}
};

subtest 'valid paths' => sub {
	taint( @{$paths{valid}} );
	for my $p2 ( @{$paths{valid}} ) {
		my $res = IMG::Util::Untaint::check_path( $p2 );
		ok( $p2 eq $res && ! tainted( $res ), "valid untainted path via check_path: '$p2'" );

#		tainted_ok( $p2, 'Checking path is tainted' );
		ok( $p2 eq IMG::Util::Untaint::check_file( $p2 ), "valid path via check_file: '$p2'" );
	}
};

subtest 'invalid file names' => sub {
	taint( @{$f_names{invalid}} );
	for my $f1 ( @{$f_names{invalid}} ) {

		throws_ok { IMG::Util::Untaint::_check_file_name( $f1 ) }
			qr[_check_file_name: invalid name:],
			"Invalid file name via _check_file_name: '$f1'";

		throws_ok { IMG::Util::Untaint::check_file( $f1 ) }
			qr[_check_file_name: invalid name:],
			"Invalid file name via check_file: '$f1'";
#		tainted_ok( $f1, 'checking file name is tainted' );
		for my $p ( @{$paths{invalid}} ) {
			my $fn = catfile($p, $f1);
			throws_ok { IMG::Util::Untaint::check_file( $fn ) }
				qr[check_path: invalid path],
				"Invalid path via check_file: '$fn'";
		}

		for my $p2 ( @{$paths{valid}} ) {
			my $fn = catfile($p2, $f1);
			throws_ok { IMG::Util::Untaint::check_file( $fn ) }
				qr[_check_file_name: invalid name:],
				"Invalid file name via check_file: '$fn'";

		}
	}
};

subtest 'valid file names' => sub {
	taint( @{$f_names{valid}} );
	for my $f2 ( @{$f_names{valid}} ) {

		ok( $f2 eq IMG::Util::Untaint::_check_file_name( $f2 ), "valid file name via _check_file_name: '$f2'" );

		for my $p ( @{$paths{invalid}} ) {
			my $fn = catfile( $p, $f2 );
			throws_ok { IMG::Util::Untaint::check_file( $fn ) }
				qr[check_path: invalid path],
				"invalid path via check_file: '$fn'";
		}

		for my $p2 ( @{$paths{valid}} ) {
			my $fn = catfile( $p2, $f2 );
			if ( substr( $p2, 0, 1) eq '~' ) {
				next;
			}
			ok( $fn eq IMG::Util::Untaint::check_file( $fn ), "valid path and file name: '$fn'" );
		}
#		tainted_ok( $f2, "'$f2': file name tainted" );
	}
};

subtest 'unset environment' => sub {

	IMG::Util::Untaint::unset_env();

	delete $ENV{qw( BASH_ENV CDPATH ENV IFS PATH )};

	for my $e ( qw( BASH_ENV CDPATH ENV IFS PATH ) ) {
		is( $ENV{$e}, undef, "$e is not defined" );
	}
};



done_testing();

=cut
sub get_args {
	my $env = shift;

#	say 'env: ' . Dumper $env;

	my $args = {
		title => 'Abundance Profile Search',
		current => "CompareGenomes",
		help => "userGuide_m.pdf#page="
	};
	$args->{help} .=
	( $env->{include_metagenomes} )
	?  "19"
	:  "51";

	return $args;
}

my $cfg = { include_metagenomes => 1, pip => 1 };

my $arg_h = get_args( $cfg );

#say 'arg_h: ' . Dumper $arg_h;

ok( $arg_h->{help} eq 'userGuide_m.pdf#page=19' );

my $arg_h2 = get_args( { pop => 1, pip => 2 } );

ok( $arg_h2->{help} eq 'userGuide_m.pdf#page=51' );
=cut


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
use ProPortal::App::JBrowseGalaxyPrep;

my $args = get_test_data('jbrowse', '*');
# test app
my $config = config;
my $scratch = tempdir( CLEANUP => 1 );
$config->{scratch_dir} = $scratch;
$config->{web_data_dir} = catdir( $dir, 'proportal/t/files/img_web_data' );
my $acc = 0;

sub test {
	return ProPortal::App::JBrowseGalaxyPrep->new( config => $config, @_ );
}

sub add_extras {
	my $args = shift // {};
	$args->{sequence} = catfile( $scratch, "file" . $acc++ );
	$args->{gff} = catfile( $scratch, "file" . $acc++ );
	return $args;
}

sub test_with_files {
	return test( args => add_extras(@_) );
}

my $msg;
my $temp = IMG::App->new( config => $config );

subtest 'instantiation' => sub {

	subtest 'error states' => sub {

	#	required arguments:
	#	sequence, gff, taxon_oid

		$msg = 'missing required arguments:';
		throws_ok {
			test( args => {} )->run();
		} qr[$msg gff, sequence, taxon_oid]i;

		throws_ok {
			test( args => { taxon_oid => 12345 } )->run();
		} qr[$msg gff, sequence]i;

		throws_ok {
			test_with_files()->run();
		} qr[$msg taxon_oid]i;


	};

	subtest 'valid' => sub {
		my $app;
		lives_ok {
			$app = test( args => {
				taxon_oid => 12345,
				sequence => 'blob',
				gff => 'blib'
			} );
		};
		ok( $app->args->taxon_oid == 12345, 'checking taxon oid' );


	};

};

my $tests = {
	error => [
{	# invalid taxon ID
	args => { taxon_oid => 'abcdefg' },
	err =>  { err => 'invalid', subject => 'abcdefg', type => 'taxon_oid' },
	desc => 'Invalid taxon ID'
},
{	# no user, taxon is private
	args => { taxon_oid => $args->{private_taxon_oid} },
	err  => { err => 'private_data' },
	desc => 'Taxon private, no user',
},
{	# user present, no access to taxon
	args => { email => $args->{galaxy_user}, taxon_oid => $args->{private_taxon_oid} },
	err  => { err => 'private_data' },
	desc => 'Taxon private, user does not have permission',
},
{	# no sequence file
	args => { email => $args->{galaxy_user}, taxon_oid => $args->{private_ok} },
	err  => { err => 'action_err', action => 'Sequence file symlinking', msg => 'No such file' },
	desc => 'no DNA sequence file',
},
{	# no gff
	args => { taxon_oid => $args->{no_gff} },
	err  => { err => 'action_err', action => 'GFF file symlinking', msg => 'No such file' },
	desc => 'no GFF file',
},
	],
	valid => [
{
	args => { taxon_oid => $args->{valid_taxon_oid} },
	desc => 'No user, taxon is valid'
},
{	args => { email => $args->{galaxy_user}, taxon_oid => $args->{valid_taxon_oid} },
	desc => 'User, public taxon'
},
# {	args => { email => $args->{galaxy_user}, taxon_oid => $args->{private_ok} },
# 	desc => 'User with permission for private taxon'
# }
	]
};

subtest 'run' => sub {

	subtest 'error states' => sub {

		for my $t ( @{$tests->{error}} ) {
			$msg = err($t->{err});
			my $app;
			throws_ok {
				$app = test_with_files( $t->{args} );
				$app->run;
			} qr[$msg], $t->{desc};
			if ( $t->{args}{email} ) {
				ok( 6660003 == $app->user->contact_oid, 'checking contact ID' );
			}
			else {
				ok( ! $app->has_user, 'No user found' );
			}
		}

	};


	subtest 'valid' => sub {

		for my $t ( @{$tests->{valid}} ) {
			lives_ok {
				test_with_files( $t->{args} )->run;
			} $t->{desc};
		}

	};
};

subtest 'script tests' => sub {

	my $script = catfile( $dir, 'proportal/script/jbrowse_fetch_files.pl' );
	my $path = File::Spec->abs2rel( $script );
	say 'script: ' . $script;
	say 'path: ' . $path;

	subtest 'error states' => sub {

		for my $t ( @{$tests->{error}} ) {
			$msg = err($t->{err});
			my @str = map { ( '--' . $_ , '"'. $t->{args}{$_} . '"' ) } keys %{$t->{args}};
			say 'str now: ' . Dumper \@str;

# 			while( my ($k,$v) = each %{$t->{args}} ) {
# 				print "$key=$value\n";
# 			}

# 	"taxon_oid|t=s",
# 	"sequence|s=s",
# 	"gff|g=s",
# 	"email|e=s",
#
# args => { sequence => catfile( $scratch, "file" . $acc++ ), gff => catfile( $scratch, "file" . $acc++ ), %$args }
#
			script_runs([ $path, @str ], { exit => 255 }, $t->{desc} );
			script_stderr_like qr[$msg], $t->{desc};
#

		}


		# no user, taxon is private

		# user present, no access to taxon

		# no sequence file

		# no GFF file


	};

	subtest 'valid' => sub {

		# no user, public taxon

		# user, public taxon

		# user, private taxon (with access)

	};




};


done_testing();


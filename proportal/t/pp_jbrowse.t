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
	@dir_arr = map { catdir( $dir, $_ ) } qw(
		webui.cgi
		proportal/lib
		proportal/t/lib
		jbrowse/extlib/lib/perl5
		jbrowse/src/perl5
	);
#	push @dir_arr, "/Users/gwg/code/promises-perl/lib";

}

use lib @dir_arr;
use IMG::Util::Import 'NetTest';
use Dancer2;
use File::Copy;
use Test::MockModule;
use File::Spec::Functions;

{
	package CoreApp;
	use IMG::Util::Import 'Class';
	extends 'IMG::App';
	with qw(
		ProPortal::Views::ProPortalMenu
		IMG::App::Role::MenuManager
	);
	1;
}

{
	package TestApp;
	use IMG::Util::Import 'Class';
	extends 'IMG::App';
	with qw(
		ProPortal::Util::JBrowseFilePrep
		ProPortal::IO::DBIxDataModel
	);
	1;
}

my $args = get_test_data('jbrowse', '*');
# test app
my $scratch = tempdir( CLEANUP => 1 );
my $config = config;
$config->{scratch_dir} = $scratch;
$config->{web_data_dir} = catdir( $dir, 'proportal/t/files/img_web_data' );

sub test {
	return TestApp->new( config => $config, @_ );
}

sub core {
	return CoreApp->new( config => $config, @_ );

}
say 'scratch dir: ' . config->{scratch_dir};

# messages
my $msg;
my $temp;

sub make_jbrowse {
	my $pp = core(@_);
	my @roles = qw(
		ProPortal::IO::DBIxDataModel
		ProPortal::Util::JBrowseFilePrep
	);
	Role::Tiny->apply_roles_to_object( $pp, @roles );
	return $pp;
}

subtest 'composition' => sub {

	my $app;
	subtest 'error states' => sub {

		$app = make_jbrowse();
		$msg = err({
			err => 'missing',
			subject => 'taxon_oid',
		});
		throws_ok {
			$app->run();
		} qr[$msg];
		throws_ok {
			$app->taxon_oid;
		} qr[$msg];

	};

	subtest 'valid' => sub {

		lives_ok {
			$app = make_jbrowse();
		};
		$app->_set_taxon_oid( 12345 );
		ok( 12345 == $app->taxon_oid, 'Checking taxon ID' );
		ok( $app->can('_build_jbrowse_tracklist'), 'checking for build jbrowse tracklist' );
		ok( $app->can('get_taxon_data'), 'checking for get taxon data' );

	};
};



subtest 'class attributes' => sub {

	my $temp = TestApp->new( config => {}, taxon_oid => 12345 );
	subtest 'error states' => sub {

		# no scratch dir
		$msg = err({
			err => 'cfg_missing',
			subject => 'scratch_dir',
		});
		throws_ok {
			$temp->jbrowse_taxon_dir;
		} qr[$msg];

		throws_ok {
			$temp->jbrowse_tracklist;
		} qr[$msg];


		$temp = test();
		$msg = err({
			err => 'missing',
			subject => 'taxon_oid',
		});
		throws_ok {
			$temp->taxon_oid;
		} qr[$msg];

		throws_ok {
			$temp->jbrowse_timestamp_file;
		} qr[$msg];
	};

	subtest 'valid' => sub {
		$temp = test( taxon_oid => 12345 );

		ok( catdir( $scratch, '12345' ) eq $temp->jbrowse_taxon_dir, 'checking set_jbrowse_taxon_dir' );

		ok( catfile( $scratch, '12345', 'trackList.json' ) eq $temp->jbrowse_tracklist, 'tracklist file' );
		ok( catfile( $scratch, '12345', 'jbrowse_data_gen.txt' ) eq $temp->jbrowse_timestamp_file, 'timestamp file' );

	};
};

$temp = test( taxon_oid => $args->{valid_taxon_oid} );
my $ts_dir = $temp->jbrowse_taxon_dir;
my $ts_file = $temp->jbrowse_timestamp_file;

subtest 'create timestamp file' => sub {

	subtest 'error states' => sub {

		$temp->create_scratch_dir;
		ok( -d $ts_dir );
		chmod 0200, $ts_dir;
		$msg = err({
			err => 'not_writable',
			subject => $ts_file
		});
		throws_ok {
			$temp->create_jbrowse_timestamp_file;
		} qr[$msg];
		chmod 0755, $ts_dir;
	};

	subtest 'valid' => sub {
		lives_ok {
			$temp->create_jbrowse_timestamp_file;
		};
		ok( -r $ts_file, 'checking timestamp file exists and is readable');
		ok( IMG::Util::File::file_slurp( $ts_file ) =~ /Generated \d+/, 'Checking file contents');
	};

};

subtest 'remove timestamp file' => sub {

	subtest 'error states' => sub {
		# make the file undeletable
		$msg = err({
			err => 'not_removable',
			subject => $temp->jbrowse_timestamp_file
		});
		chmod 0500, $ts_dir;
		ok( -e $ts_file, 'file exists' );
		throws_ok {
			$temp->remove_jbrowse_timestamp_file;
		} qr[$msg];
		chmod 0755, $ts_dir;
		ok( -e $ts_file, 'file exists' );

	};

	subtest 'valid' => sub {
		ok( -e $ts_file, 'file exists' );
		lives_ok {
			$temp->remove_jbrowse_timestamp_file;
		};
		ok ( ! -e $ts_file, 'checking file does not exist' );
	};
};



subtest 'check taxon permissions' => sub {
	subtest 'error states' => sub {

		$msg = err({ err => 'private_data' });
		throws_ok {
			test( taxon_oid => $args->{private_taxon_oid} )->check_taxon_permissions;
		} qr[$msg], 'Taxon private, no user';

		throws_ok {
			test( user => $args->{user}, taxon_oid => $args->{private_taxon_oid} )
				->check_taxon_permissions;
		} qr[$msg], 'Taxon private, user does not have permission';
	};

	subtest 'valid' => sub {
		# taxon_oid = 10101010
		# contact_oid = 909
		lives_ok {
			test( user => $args->{user}, taxon_oid => $args->{private_ok} )
				->check_taxon_permissions;
		}, 'User has permission for taxon';
	};
};

subtest 'get_taxon_data' => sub {

	subtest 'error states' => sub {
		$msg = err({
			err => 'invalid',
			subject => $args->{invalid_taxon_oid},
			type => 'taxon_oid'
		});
		throws_ok {
			test( taxon_oid => $args->{invalid_taxon_oid} )->get_taxon_data;
		} qr[$msg], 'Invalid taxon ID';

		$msg = err({ err => 'private_data' });
		throws_ok {
			test( taxon_oid => $args->{private_taxon_oid} )->get_taxon_data;
		} qr[$msg], 'Taxon is not public, user not logged in';

		# add user
		throws_ok {
			test( user => $args->{user}, taxon_oid => $args->{private_taxon_oid} )
				->get_taxon_data;
		} qr[$msg], 'Taxon is not public, user not permitted access';
	};

	subtest 'valid' => sub {
		$temp = test( user => $args->{user}, taxon_oid => $args->{private_ok} );
		my $got = clean_db_output( $temp->get_taxon_data );
		# restricted taxon access
		is_deeply(
			$got,
		{	taxon_oid => $args->{private_ok},
			taxon_display_name => 'Fake Taxon Name',
			is_public => 'No' },
			'valid restricted-access taxon permissions') or diag explain $got;

		# standard public taxon
		$temp = test( user => $args->{user}, taxon_oid => $args->{valid_taxon_oid} );

		is_deeply(
			undef,
			$temp->taxon_display_name,
			'checking taxon name' );

		$got = clean_db_output( $temp->get_taxon_data );

		is_deeply(
			$got,
		{	taxon_oid => 637000214,
			taxon_display_name => 'Prochlorococcus marinus pastoris CCMP 1986',
			is_public => 'Yes' },
			'valid public taxon'
		) or diag explain $got;

#		ok( 'Prochlorococcus marinus pastoris CCMP 1986' eq $temp->taxon_display_name, 'checking display name' );

	};

};


subtest 'create_ref_seq' => sub {

	subtest 'error states' => sub {

		my $f = $temp->get_taxon_file({ type => 'dna_seq', taxon_oid => 123456 });
		$msg = err({ err => 'not_readable', subject => $f });
		throws_ok {
			$temp = test( taxon_oid => 123456 );
			$temp->create_ref_seq;
		} qr[$msg], 'file not found';

		$f = $temp->get_taxon_file({ type => 'dna_seq', taxon_oid => 666 });
		chmod 0200, $f;
		$msg = err({ err => 'not_readable', subject => $f });
		throws_ok {
			$temp = test( taxon_oid => 666 );
			$temp->create_ref_seq;
		} qr[$msg], 'file not readable';
		chmod 0644, $f;

		# TODO!
		# this doesn't work
# 		throws_ok {
# 			$temp = test( taxon_oid => 666 );
#			$temp->create_ref_seq;
# 		} qr[$msg], 'wrong type of file; chaos ensues';

	};

	subtest 'valid' => sub {

		lives_ok {
			$temp = test( taxon_oid => $args->{valid_taxon_oid} );
			$temp->create_ref_seq;
		};

	};
};

my $gff_data;
subtest 'get_gene_oids_from_gff' => sub {

	subtest 'error states' => sub {

		my $f = $temp->get_taxon_file({ type => 'gff', taxon_oid => 12345 });
		$msg = err({
			err => 'not_found',
			subject => $f
		});
		throws_ok {
			$temp = test( taxon_oid => 12345 );
			$temp->get_gene_oids_from_gff;
		} qr[$msg], 'file not found';

		$f = $temp->get_taxon_file({ type => 'gff', taxon_oid => 666 });
		chmod 0200, $f;
		$msg = err({ err => 'not_readable', subject => $f });

		throws_ok {
			test( taxon_oid => 666 )->get_gene_oids_from_gff;
		} qr[$msg], 'file not readable';

		throws_ok {
			test( taxon_oid => 666 )->create_gff_track;
		} qr[$msg], 'file not readable';

		chmod 0644, $f;

		$msg = err({ err => 'not_found_in_file', subject => 'GFF header', file => $f });
		throws_ok {
			test( taxon_oid => 666 )->get_gene_oids_from_gff;
		} qr[$msg], 'wrong type of file; chaos ensues';

	};

	subtest 'valid' => sub {
		$gff_data = test( taxon_oid => 999 )->get_gene_oids_from_gff;
		ok( $gff_data->{seqid} eq 'NC_005072', 'Checking sequence ID' );
		is_deeply(
			[ sort keys %{$gff_data->{gff_data}} ],
			[ qw(
				637448992
				637448993
				637448994
				637448995
				637448996
				637448997
				637448998
				637448999
				637449000
				637449001
			) ],
			'Checking GFF data'
		) or diag explain $gff_data;

	};
};

subtest 'create_gff_track' => sub {

	subtest 'error states' => sub {

		$msg = err({
			err => 'not_readable',
			subject => 'img_web_data/tab.files/gff/12345.gff'
		});
		throws_ok {
			test( taxon_oid => 12345 )->create_gff_track;
		} qr[$msg], 'file not found';

#		test for unreadable file
#		moved to section above

		# TODO!
		# this doesn't work
# 		throws_ok {
# 			$temp = test( taxon_oid => 666 );
#			$temp->create_gff_track;
# 		} qr[$msg], 'wrong type of file; chaos ensues';

	};

	subtest 'valid' => sub {
		lives_ok {
			test( taxon_oid => $args->{valid_taxon_oid} )->create_gff_track;
		};
	};
};

subtest 'index_names' => sub {

	subtest 'error states' => sub {
		throws_ok {
			test( taxon_oid => 12345 )->index_names;
		} qr[output directory .*? does not exist]i;
	};

	subtest 'valid' => sub {
		lives_ok {
			test( taxon_oid => $args->{valid_taxon_oid} )->index_names;
		};
	};
};



subtest 'tab_delimited_to_gff' => sub {

	subtest 'error states' => sub {
		$temp = test( taxon_oid => 12345 );
		$msg = err({
			err => 'missing',
			subject => 'file to load'
		});
		throws_ok {
			$temp->tab_delimited_to_gff;
		} qr[$msg];

		$msg = err({
			err => 'missing',
			subject => 'GFF data'
		});
		throws_ok {
			$temp->tab_delimited_to_gff( 'cog' );
		} qr[$msg];



	};

	subtest 'valid' => sub {
		$temp = test( taxon_oid => $args->{valid_taxon_oid} );
		$gff_data = $temp->get_gene_oids_from_gff;
		lives_ok {
			$temp->tab_delimited_to_gff('pfam', $gff_data );
		};
	};

};

subtest 'run' => sub {

	subtest 'error states' => sub {

		my $temp;

		$msg = err({
			err => 'invalid',
			subject => 'blob',
			type => 'JBrowse file prep method'
		});
		throws_ok {
			test( taxon_oid => 12345 )->run({ steps => 'blob' });
		} qr[$msg], 'wrong args';

		# check taxon permissions
		# private taxon, no user
		$msg = err({ err => 'private_data' });
		$temp = test( taxon_oid => $args->{private_taxon_oid} );
		throws_ok {
			$temp->run;
		} qr[$msg], 'Taxon private, no user';

		# user logged in, no permissions
		throws_ok {
			test( user => $args->{user}, taxon_oid => $args->{private_taxon_oid} )->run;
		} qr[$msg], 'Taxon private, user does not have permission';
		ok ( ! -e $temp->jbrowse_taxon_dir, 'checking directory has been removed' );

		# get taxon data
		$temp = test( taxon_oid => $args->{invalid_taxon_oid} );
		$msg = err({
			err => 'invalid',
			subject => $args->{invalid_taxon_oid},
			type => 'taxon_oid'
		});
		throws_ok {
			$temp->run;
		} qr[$msg], 'Invalid taxon ID';
		ok ( ! -e $temp->jbrowse_taxon_dir, 'checking directory has been removed' );

		# CREATE SCRATCH DIR!!


		# create_ref_seq
		$temp = test( taxon_oid => $args->{no_dna_seq} );
		my $f = $temp->get_taxon_file({ type => 'dna_seq', taxon_oid => $args->{no_dna_seq} });
		$msg = err({ err => 'not_readable', subject => $f });
		throws_ok {
			$temp->run;
		} qr[$msg], 'file not found';
		ok ( ! -e $temp->jbrowse_taxon_dir, 'checking directory has been removed' );

		$f = $temp->get_taxon_file({ type => 'dna_seq', taxon_oid => $args->{valid_taxon_oid} });
		chmod 0200, $f;
		$msg = err({ err => 'not_readable', subject => $f });
		throws_ok {
			test( taxon_oid => $args->{valid_taxon_oid} )->run;
		} qr[$msg], 'file not readable';
		ok ( ! -e $temp->jbrowse_taxon_dir, 'checking directory has been removed' );
		chmod 0644, $f;

		# create gff track
		$temp = test( taxon_oid => $args->{no_gff} );
		$msg = err({
			err => 'not_readable',
			subject => 'img_web_data/tab.files/gff/' . $args->{no_gff} .'.gff'
		});
		throws_ok {
			$temp->run;
		} qr[$msg], 'file not found';
		ok ( ! -e $temp->jbrowse_taxon_dir, 'checking directory has been removed' );

		# mappings tracks!

# 		get gene oids from gff
# 		throws_ok {
# 			$temp = test( taxon_oid => 12345 );
# 			$temp->get_gene_oids_from_gff;
# 		} qr[$msg], 'file not found';
#
# 		my $f = $temp->get_taxon_file({ type => 'gff', taxon_oid => 666 });
# 		chmod 0200, $f;
# 		$msg = err({ err => 'not_readable', subject => $f });
#
# 		throws_ok {
# 			test( taxon_oid => 666 )->get_gene_oids_from_gff;
# 		} qr[$msg], 'file not readable';
#
# 		throws_ok {
# 			test( taxon_oid => 666 )->create_gff_track;
# 		} qr[$msg], 'file not readable';
#
# 		chmod 0644, $f;
#
# 		$msg = err({ err => 'not_found_in_file', subject => 'GFF header', file => $f });
# 		throws_ok {
# 			test( taxon_oid => 666 )->get_gene_oids_from_gff;
# 		} qr[$msg], 'wrong type of file; chaos ensues';

		# tab-delimited to GFF


		# index names
# 		throws_ok {
# 			test( taxon_oid => 12345 )->index_names;
# 		} qr[output directory .*? does not exist]i;


		# create/remove timestamp file



	};

	subtest 'valid' => sub {

		$temp = test( taxon_oid => $args->{valid_taxon_oid} );

		lives_ok { $temp->run; };

		ok( -e $temp->jbrowse_taxon_dir && -r $temp->jbrowse_timestamp_file && -r $temp->jbrowse_tracklist );

		say 'standard steps';
		$temp->run({ steps => 'std', force_regeneration => 1 });
		ok( -e $temp->jbrowse_taxon_dir && -r $temp->jbrowse_timestamp_file && -r $temp->jbrowse_tracklist );



	};

};


=cut
my $taxid = '637000214';
my $alttaxid = '214637000';

my $jb_mock = Test::MockModule->new('Routes::JBrowse');

$jb_mock->mock('get_taxon_name', sub { return 'pretend species name' } );

my $count = 5;
my $config->{web_data_dir} = '/Users/gwg/webUI/proportal/t/files/img_web_data/';

my $t2 = timeit($count, sub { Routes::JBrowse::generate_jbrowse_data_async( $taxid ) } );

my $t = timeit($count, sub { Routes::JBrowse::generate_jbrowse_data( $alttaxid ) } );
print "$count loops of sync code took ", timestr($t),"\n";
print "$count loops of async code took ", timestr($t2),"\n";

# check that the two subs create the same files



# create an application
my $app = Routes::JBrowse->to_app;
isa_ok( $app, 'CODE' );

# create a testing object
my $test = Plack::Test->create($app);

$Plack::Test::Impl = "Server";

# "GET" from HTTP::Request::Common creates an HTTP::Request object
my $r = $test->request( GET '/jbrowse/637000214' );
ok( $r->is_success, 'Successful request' );
is( $r->content, 'OK', 'Correct response content' );

my $r2 = $test->request( GET '/jbrowse/async/214637000' );


# same as:
# my $response = $test->request( HTTP::Request->new( GET => '/' ) );

# my $server = Test::TCP->new(
#     code => sub {
#         my ( $port ) = @_;
#
#         my $server = Plack::Loader->load('Twiggy', port => $port, host => '127.0.0.1');
#         $server->run($app);
#         exit;
#     },
# );

=cut

done_testing();

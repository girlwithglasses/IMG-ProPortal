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
use IMG::Util::Base 'Test';
use Dancer2;

use IMG::App::Core;
use IMG::App::Role::Schema;
use IMG::App::Role::DbConnection;
use IMG::Util::DBIxConnector;
use DataModel::IMG_Test;

{
	package TestApp;
	use IMG::Util::Base 'Class';
	extends 'IMG::App::Core';
	with qw( IMG::App::Role::DbConnection IMG::App::Role::Schema );
}

my $app = TestApp->new();
my $schema;
my $msg;

subtest 'initialisation' => sub {
	subtest 'error states' => sub {

		$msg = err({ err => 'missing', subject => 'schema' });
		throws_ok { $app->schema() } qr[$msg];

		$msg = err({ err => 'cfg_missing', subject => 'schema' });
		throws_ok { $app->schema('blob') } qr[$msg];

		$app = TestApp->new( config => test_config() );

		$msg = err({
			err => 'invalid',
			subject => 'nonsense',
			type => 'schema'
		});
		throws_ok { $app->schema('nonsense') } qr[$msg];

		$msg = err({
			err => 'invalid',
			subject => 'absent',
			type => 'db_conf'
		});
		throws_ok { $app->schema('absent') } qr[$msg];

		# check we have a dbh
		$msg = err({
			err => 'module_load',
			subject => 'I::Made::This::Up',
			msg => '.*'
		});

		throws_ok { $app->schema('missing') } qr[$msg];

	};

	subtest 'valid' => sub {

		$schema = $app->schema('img_core');

		isa_ok ( $schema, 'DataModel::IMG_Test', 'Checking schema type' );

		$app = TestApp->new( config => test_config() );
		my $no_dbh = $app->schema('img_gold', { no_connection => 1 } )->dbh;
		ok( ! $no_dbh, 'No dbh created' );

	};
};

sub test_config {
	return {
		# schema and db connection required
		schema => {
			img_core => { module => 'DataModel::IMG_Test', db => 'test' },
			img_gold => { module => 'DataModel::IMG_Test', db => 'test' },
			missing  => { module => 'I::Made::This::Up', db => 'test' },
			absent   => { module => 'DataModel::IMG_Test', db => 'absent' },
		},
		db => {
			# config details
			test => {
				driver => 'SQLite',
				database => 't/lib/test.db',
				dbi_params => {
					RaiseError => 1,
					FetchHashKeyName => 'NAME_lc',
				},
		#		log_queries => 1,
			},
		}
	};
}


done_testing();



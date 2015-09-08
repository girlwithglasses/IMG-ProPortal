#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib ( "$Bin/../lib", "$Bin/../t/lib", "$Bin/../../webui.cgi" );
use IMG::Util::Base 'Test';

$ENV{TESTING} = 1;

use IMG::App::Core;
use IMG::Schema;
use IMG::IO::DbConnection;
use IMG::Util::DBIxConnector;
use DataModel::IMG_Test;

{
	package TestApp;
	use IMG::Util::Base 'Class';
	extends 'IMG::App::Core';
	with qw( IMG::IO::DbConnection IMG::Schema );
}

my $app = TestApp->new();

throws_ok { $app->schema() } qr[No schema specified];

throws_ok { $app->schema('blob') } qr[No config];

$app = TestApp->new( config => test_config() );

throws_ok { $app->schema('nonsense') } qr[DB schema configuration for nonsense not found!];

my $schema = $app->schema('img_core');

isa_ok ( $schema, 'DataModel::IMG_Test', 'Checking schema type' );

# check we have a dbh
throws_ok { $app->schema('missing') } qr[Unable to load class I::Made::This::Up];

throws_ok { $app->schema('absent') } qr[No db conf found for absent];

$app = TestApp->new( config => test_config() );
my $no_dbh = $app->schema('img_gold', { no_connection => 1 } )->dbh;

ok( ! $no_dbh, 'No dbh created' );


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



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
#use Dancer2;

{
	package TestApp;
	use IMG::Util::Base 'Class';
	extends 'IMG::App::Core';
	with qw(
		IMG::App::Role::DbConnection
		IMG::App::Role::Schema
		ProPortal::IO::DBIxDataModel
		IMG::App::Role::User
	);
}

use IMG::App;
use IMG::App::Role::User;
use IMG::App::Core;
use IMG::App::Role::DbConnection;
use IMG::Util::DBIxConnector;
use IMG::App::Role::HttpClient;
use JSON;
use Test::MockModule;
use Test::MockObject::Extends;
use DataModel::IMG_Test;


sub create_database {

# load an in-memory database and deploy the required tables
	my $dbh = DBI->connect('dbi:SQLite:dbname=:memory:', undef, undef, { RaiseError => 1 });
	$dbh->do('CREATE TABLE CONTACT (
		contact_oid numeric PRIMARY KEY NOT NULL,
		username varchar2,
		password varchar2,
		name varchar2,
		title varchar2,
		department varchar2,
		email varchar2,
		phone varchar2,
		organization varchar2,
		address varchar2,
		city varchar2,
		state varchar2,
		country varchar2,
		comments varchar2,
		add_date datetime,
		super_user varchar2,
		img_editor varchar2,
		img_group numeric,
		jgi_user varchar2,
		img_editing_level varchar2,
		caliban_id integer,
		caliban_user_name varchar2 );' );

	$dbh->do("CREATE TABLE CANCELLED_USER (
id varchar2 PRIMARY KEY NOT NULL,
username varchar2,
email varchar2,
comments varchar2,
modified_by integer,
mod_date datetime )");

	DataModel::IMG_Test->dbh( $dbh );

	# add cancelled users
	DataModel::IMG_Test->table("CancelledUser")
	->insert(
	# headers
		[ 'id', 'email', 'username' ],
	# data
		[ 'evil_001', 'EVIL@ACME.ORG' , 'Dr. Evil' ],
		[ 'evil_002', 'carmen@broderbund.org', 'carmen sandiego' ],
	);


	# insert valid and invalid users
	DataModel::IMG_Test->table('Contact')
	->insert({
    'caliban_id' => 1,
    'contact_oid' => '10',
    'email' => 'NNIvanova@lbl.gov',
    'img_editing_level' => undef,
    'img_editor' => 'Yes',
    'img_group' => '400',
    'name' => 'Natalia Ivanova',
    'super_user' => 'Yes',
    'username' => 'natalia'
  }, {
    'caliban_id' => 1,
    'contact_oid' => '11',
    'email' => 'NCKyrpides@lbl.gov',
    'img_editing_level' => undef,
    'img_editor' => 'Yes',
    'img_group' => '400',
    'name' => 'Nikos Kyrpides',
    'super_user' => 'Yes',
    'username' => 'nikos'
  }, {
    'caliban_id' => 1,
    'contact_oid' => '12',
    'email' => 'ALykidis@lbl.gov',
    'img_editing_level' => undef,
    'img_editor' => 'No',
    'img_group' => '400',
    'name' => 'Thanos Lykidis',
    'super_user' => 'No',
    'username' => 'thanos'
  }, {
    'caliban_id' => 4,
    'contact_oid' => '14',
    'email' => 'phugenholtz@lbl.gov',
    'img_editing_level' => undef,
    'img_editor' => 'Yes',
    'img_group' => undef,
    'name' => 'Phil Hugenholtz',
    'super_user' => 'No',
    'username' => 'MISSING username!!'
  }, {
    'caliban_id' => 5,
    'contact_oid' => '100053',
    'email' => 'diy@aber.ac.uk',
    'img_editing_level' => 'gene-term img-pathway',
    'img_editor' => 'No',
    'img_group' => '100033',
    'name' => 'Danielle Young',
    'super_user' => 'No',
    'username' => 'diy'
  }, {
    'caliban_id' => 6,
    'contact_oid' => '100054',
    'email' => 'keith.chater@bbsrc.ac.uk',
    'img_editing_level' => 'gene-term img-pathway',
    'img_editor' => 'No',
    'img_group' => '100033',
    'name' => 'Keith Chater',
    'super_user' => 'No',
    'username' => 'keith.chater'
  }, {
    'caliban_id' => 7,
    'contact_oid' => '100055',
    'email' => 'maggie.smith@abdn.ac.uk',
    'img_editing_level' => 'gene-term img-pathway',
    'img_editor' => 'No',
    'img_group' => '100033',
    'name' => 'Margaret Smith',
    'super_user' => 'No',
    'username' => 'maggie.smith'
  },
);
	# save the db
	$dbh->sqlite_backup_to_file('t/lib/test.db');
}


my $obj;
#create_database();
# first make sure the module loaded OK
use_ok('IMG::App::Role::User');    # test 1

# tests for get_db_contact_data()

my $app = TestApp->new( config => no_core_config() );
my $msg;

# oo tests
subtest 'get_contact_data' => sub {

	subtest 'error states' => sub {

		# no args
		$msg = err({ err => 'missing', subject => "identifier for contact" });
		throws_ok {
			$app->get_db_contact_data;
		} qr[$msg];

		throws_ok {
			$app->get_db_contact_data({});
		} qr[$msg];

		$msg = err({
			err => 'invalid_enum',
			type => 'identifier for contact',
			subject => 'user_id',
			enum => [ qw( caliban_id contact_oid email ) ]
		});
		throws_ok {
			$app->get_db_contact_data({ user_id => 5});
		} qr[$msg];

		$msg = err({
			err => 'invalid',
			subject => 'img_core',
			type => 'schema'
		});

		# no db config
		throws_ok {
			$app->get_db_contact_data({ caliban_id => 0 });
		} qr[$msg];

		# load the test db
		$app = TestApp->new( config => test_config() );

		$msg = err({
			err => 'no_results',
			subject => 'users',
		});
		# ID not in database
		throws_ok {
			$app->get_db_contact_data({ caliban_id => 25 });
		} qr[$msg];

		# too many results!
		$msg = err({
			subject => 'users with matching user IDs',
			err => 'unexpected',
			msg => 'expected one result, but got 3'
		});

		Test::MockObject::Extends->new($app);
		$app->mock( 'run_query', sub {
			return [
		bless( {
			__schema => 1,
			contact_oid => 11,
			email => "NCKyrpides\@lbl.gov",
			img_editing_level => undef,
			img_editor => "Yes",
			img_group => 400,
			name => "Nikos Kyrpides",
			super_user => "Yes",
			username => "nikos"
		}, 'DataModel::IMG_Test::Contact' ),
		bless( {
			__schema => 1,
			contact_oid => 12,
			email => "ALykidis\@lbl.gov",
			img_editing_level => undef,
			img_editor => "No",
			img_group => 400,
			name => "Thanos Lykidis",
			super_user => "No",
			username => "thanos"
		}, 'DataModel::IMG_Test::Contact' ),
		bless( {
			__schema => 1,
			contact_oid => 14,
			email => "phugenholtz\@lbl.gov",
			img_editing_level => undef,
			img_editor => "Yes",
			img_group => undef,
			name => "Phil Hugenholtz",
			super_user => "No",
			username => "MISSING username!!"
		}, 'DataModel::IMG_Test::Contact' )
			];
		} );

# 		my $results = $obj->run_query({
# 			query => 'user_data',
# 			where => {}
# 		});
# 		say 'results: ' . Dumper $results;


		throws_ok {
			$app->get_db_contact_data({ caliban_id => 1 });
		} qr[$msg];
	};

	subtest 'valid' => sub {
		# load the test db
		$app = TestApp->new( config => test_config() );

		# working result
		my $user = $app->get_db_contact_data({ caliban_id => 4 });
		ok( $user->{contact_oid} == 14 && ! defined $user->{img_group} && $user->{super_user} eq 'No', 'Checking user details' );
	};

};


# tests for check_banned_users()
#
# subtest 'check_banned_users' => sub {
#
# 	$app = TestApp->new( config => test_config() );
#
# 	subtest 'error states' => sub {
#
# 		$msg = err({
# 			err => 'missing',
# 			subject => 'user names or emails'
# 		});
#
# 		throws_ok {
# 			$app->check_banned_users();
# 		} qr[$msg];
#
# 		throws_ok {
# 			$app->check_banned_users({ test => [ undef, undef, undef ] });
# 		} qr[$msg];
#
# 		$app = TestApp->new( config => test_config() );
#
# 		username / email match: die with 403 error
# 		{	local $@;
#
# 		[ 'EVIL@ACME.ORG' , 'Dr. Evil' ],
# 		[ 'carmen@broderbund.org', 'carmen sandiego' ],
#
# 			my $err = eval { $app->check_banned_users({
# 				test => [ 'dodgy@villain.com', 'carmen sandiego' ]
# 			}) };
#
# 			if ( $@ ) {
# 				is_deeply(
# 				$@,
# 				{	status  => 403,
# 					title   => 'Access denied',
# 					message => err({ err => 'acc_locked' }),
# 				},
# 				'Checking error returned by banned user' );
# 			}
# 			else {
# 				ok( undef, 'Did not find banned user!' );
# 			}
# 		}
#
# 		make sure that we're getting the correct query constructed
# 		Test::MockObject::Extends->new($app);
# 		$app->mock( 'run_query', sub {
# 			my $self = shift;
# 			my $args = shift;
#
# 			die $args->{where}[1];
# 		});
#
# 		{	local $@;
# 			my $err = eval { $app->check_banned_users({
# 				test => [ 'dodgy@villain.com', 'carmen sandiego', 'dodgy@villain.com', 'dodgy@villain.com' ]
# 			}) };
#
# 			if ( $@ ) {
# 				is_deeply(
# 				[ sort @{$@} ],
# 				[ 'carmen sandiego', 'dodgy@villain.com' ],
# 				'Checking database query' ) or diag explain $@;
# 			}
# 			else {
# 				ok( undef, 'database query incorrectly formed' );
# 			}
# 		}
#
#
# 	};
#
# 	subtest 'valid' => sub {
#
# 		$app = TestApp->new( config => test_config() );
#
# 		user is OK
# 		lives_ok { $app->check_banned_users({ test => [ qw(pip pap pop) ] } ) };
#
# 	};
# };
#

# tests for run_user_checks()
=cut
subtest 'run_user_checks' => sub {

	$obj = TestApp->new();

	throws_ok { $obj->run_user_checks() } qr[No user ID supplied];
	# no config
	throws_ok { $obj->run_user_checks( 12345 ) } qr[No config found!];


#ok( $obj->run_user_checks(0), '' );
#ok( $obj->run_user_checks(''), '' );
#ok( $obj->run_user_checks('some','args'), '' );

# direct calls in case you want them....
#ok( IMG::App::Role::User::run_user_checks(undef), '' );
#ok( IMG::App::Role::User::run_user_checks(0), '' );
#ok( IMG::App::Role::User::run_user_checks(''), '' );
#ok( IMG::App::Role::User::run_user_checks('some','args'), '' );
};
=cut

done_testing();

# oo tests
=cut
my $obj = Test::MockModule('IMG::App::Role::UserObj');
$obj->mock( get_jgi_user_json => sub {  } );
$obj->mock( get_imgcore_contact_data => sub {  } );
$obj->mock( check_banned_users => sub {  } );

throws_ok { $obj->run_user_checks(undef) } qr!No user ID supplied!;
        my $mock = Test::MockModule('Foo');
        $mock->mock(foo => sub { print "Foo!\n"; });

        my $foo = Foo->new();
        $foo->foo(); # prints "Foo!\n"
}
=cut

sub test_config {
	return {
		dev_site => 1,
		# schema and db connection required
		schema => {
			img_core => { db => 'test', module => 'DataModel::IMG_Test' },
			img_gold => { db => 'test', module => 'DataModel::IMG_Test' },
		},
		db => {
			test => {
				driver => 'SQLite',
				database => 't/files/test.db',
				dbi_params => {
					RaiseError => 1,
					FetchHashKeyName => 'NAME_lc',
				},
		#		log_queries => 1,
			},
		}
	};
}

sub no_core_config {

	return {
		dev_site => 1,
		# schema and db connection required
		schema => {
			img_gold => { db => 'img_gold', module => 'DataModel::IMG_Gold' },
			nonsense => { db => 'complete_rubbish', module => 'Absolute::Bunkum' },
		},
		db => {
			# config details
			imgsqlite => {
				driver => 'SQLite',
				database => 'memory',
				dbi_params => {
					RaiseError => 1,
					FetchHashKeyName => 'NAME_lc',
				},
		#		log_queries => 1,
			},
			omglite => {
				driver => 'SQLite',
				database => 'memory',
			},
			complete_rubbish => {
				foo => 'bar',
				pip => 'pap',
				pop => 'pup'
			},
		}
	};
}


sub config {

	return {
		dev_site => 1,
		# schema and db connection required
		schema => {
			img_core => { db => 'img_core', module => 'DataModel::IMG_Core' },
			img_gold => { db => 'img_gold', module => 'DataModel::IMG_Gold' },
			nonsense => { db => 'complete_rubbish', module => 'Absolute::Bunkum' },
		},
		db => {
			# config details
			imgsqlite => {
				driver => 'SQLite',
				database => 'memory',
				dbi_params => {
					RaiseError => 1,
					FetchHashKeyName => 'NAME_lc',
				},
		#		log_queries => 1,
			},
			omglite => {
				driver => 'SQLite',
				database => 'memory',
			},
			complete_rubbish => {
				foo => 'bar',
				pip => 'pap',
				pop => 'pup'
			},
		}
	};
}

sub valid_response {
	return {
		'ip' => '24.23.163.18',
		'user' => {
			'email' => 'fatman@blobby.com',
			'contact_id' => 999,
			'id' => 666,
			'email_address' => 'fatman@blobby.com',
			'login' => 'mr_blobby',
		},
		'id' => '164204433980c73e76e55c7add829d51'
	};
}

sub invalid_response {
	return {
		'ip' => '24.23.163.18',
		'user' => {
			'email' => 'fatman@blobby.com',
			'contact_id' => 999,
			'id' => 666,
		},
		'id' => '164204433980c73e76e55c7add829d51'
	};
}


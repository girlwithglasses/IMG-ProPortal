#!/usr/bin/env perl

BEGIN {
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	my $dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	our @dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib webui.cgi/t/lib );
}
use lib @dir_arr;
use IMG::Util::Base 'Test';

$ENV{TESTING} = 1;

use IMG::Model::Contact;

use_ok( 'IMG::Model::Contact' );

subtest 'Model building' => sub {

	throws_ok { IMG::Model::Contact->new() } qr[Missing required arguments];

	my $contact = IMG::Model::Contact->new( %{ user() } );
	ok( 0 == $contact->is_editor, 'Contact is not an editor' );
	ok( 0 == $contact->is_super_user, 'Contact is not a super user' );
	ok( 'carmensandy' eq $contact->username, 'Contact username correct' );
	ok( 12345 == $contact->caliban_id, 'Checking contact Caliban ID' );
	ok( ! $contact->can_edit('peanuts'), 'Contact has no edit privileges' );

	throws_ok { $contact->can_edit() } qr[No edit level specified];

	my $c2 = IMG::Model::Contact->new( %{ user_two() } );
	ok( ! $c2->has_username, 'No username given' );
	$c2->set_username('Dr. Evil');
	ok( $c2->has_username && 'Dr. Evil' eq $c2->username, 'Adding params after object creation is OK' );


};

{
	package TestApp;
	use IMG::Util::Base 'Class';
	extends 'IMG::App::Core';
	with qw( IMG::App::Role::DbConnection IMG::App::Role::Schema );
}


subtest 'Models with DB info' => sub {

	my $app = TestApp->new( config => test_config() );

	my $users = $app->schema('img_core')->table('Contact')
		->select(
			-columns  => [ qw( * ) ],
		);

	my $user_h;
	for my $u ( @$users ) {
		delete $u->{__schema};
		my $c = IMG::Model::Contact->new( $u );
		$user_h->{ $c->contact_oid } = $c;
	}

	ok( 0 == $user_h->{100053}->is_superuser, 'user 100053 is not a super user' );
	ok( $user_h->{10}->is_super_user, 'user 10 is a super user' );
	ok( $user_h->{11}->is_editor, 'user 11 is an IMG editor' );
	ok( $user_h->{100053}->can_edit('gene-term'), 'user 100053 can edit gene terms' );
	ok( 0 == $user_h->{100055}->can_edit('peanuts'), 'user 100055 cannot edit peanuts' );
	ok( ! $user_h->{14}->has_jgi_session_id, 'No JGI session ID to be found!' );

};


done_testing();

sub user {
	return {
		user_data => {
			'id' => 'a35c2c1cc01b3cf49c12d4e21c3ff47f',
			'ip' => '24.23.163.18',
			'user' => {
				'contact_id' => 12345,
				'email' => 'carmensandiego@broderbund.org',
				'email_address' => 'carmensandiego@broderbund.org',
				'first_name' => 'Carmen',
				'id' => 666,
				'last_name' => 'Sandiego',
				'login' => 'carmens',
			}
		},
		db_data => bless( {
			'contact_oid' => '999',
			'email' => 'carmensandiego@broderbund.org',
			'img_editing_level' => undef,
			'img_editor' => undef,
			'img_group' => undef,
			'name' => 'Carmen Sandiego',
			'super_user' => 'No',
			'username' => 'carmensandy'
		}, 'DataModel::IMG_Core::Contact' )
	};
}

sub user_two {
	return {
		db_data => bless( {
			'contact_oid' => '999',
			'email' => 'carmensandiego@broderbund.org',
			'name' => 'Carmen Sandiego',
		}, 'DataModel::IMG_Core::Contact' )
	};
}


sub test_config {
	return {
		dev_site => 1,
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

#!/usr/bin/env perl

BEGIN {
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	my $dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	our @dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib proportal/t/lib );
}
use lib @dir_arr;
use IMG::Util::Base 'Test';

use File::Basename;
use Config::Any;
use IMG::Util::DB;
use IMG::Util::File;
use File::Temp qw/tempfile tempdir/;
use JSON;

my $data = {

	h1 => {
		ora_host => 'foo',
		ora_port => 1234,
		ora_sid  => 'bar'
	},
	str1 => 'dbi:Oracle:host=foo;port=1234;sid=bar',
	r1 => {
		dsn => 'dbi:Oracle:host=foo;port=1234;sid=bar',
		options => { RaiseError => 1 }
	},

	h2 => {
		ora_sid => 'blob'
	},
	str2 => 'dbi:Oracle:sid=blob',

	h3 => {
		ora_dbi_dsn => 'blob'
	},
	str3 => 'dbi:Oracle:blob',
	r3 => {
		dsn => 'dbi:Oracle:blob',
		options => { RaiseError => 1 }
	},

	h4 => {
		dsn => 'blob'
	},

	h5 => {
		ora_dbi_dsn => 'dbi:Oracle:dbname',
		ora_user => 'Mr. Blobby',
		ora_password => 'secret',
	},

	r5 => {
		dsn => 'dbi:Oracle:dbname',
		username => 'Mr. Blobby',
		password => 'secret',
		options => { RaiseError => 1 }
	}

};


sub write_env_file {

	my $params = shift;
	my ($fh, $fname) = tempfile();

	for my $p ( keys %$params ) {
		print { $fh } sprintf '$ENV{ %s } = "%s";' . "\n", uc($p), $params->{$p};
	}
	return $fname;
}

subtest 'get_oracle_cfg_files' => sub {

	my $conf = IMG::Util::DB::get_oracle_cfg_files;

	ok( scalar values %$conf == scalar grep { m#/global/u1/i/img/img_rdbms/config/#i } values %$conf, 'Making sure the directory paths all start with /global/ etc' );

};

subtest 'make_dsn_str' => sub {

	for my $n ( 1, 2, 3 ) {

		is( IMG::Util::DB::make_dsn_str( $data->{"h$n"} ), $data->{"str$n"}, 'Valid DSN info' );

	}

	# should croak
	like(
		exception { IMG::Util::DB::make_dsn_str() },
		qr{No parameters specified},
		'testing error handling'
	);

	like(
		exception { IMG::Util::DB::make_dsn_str( 'a', 'b', 'c' ) },
		qr{make_dsn_str expects a hash ref as input},
		'error handling'
	);

	like(
		exception { IMG::Util::DB::make_dsn_str( $data->{h4} ) },
		qr{No appropriate DSN information found},
		'No DSN info'
	);

};

subtest 'decode_pass' => sub {

	is( IMG::Util::DB::decode_pass( 'not_encoded:password' ),
	'not_encoded:password');

	is( IMG::Util::DB::decode_pass( 'encoded:aW1nc2dfMTczNQ==' ),
	'imgsg_1735' );

	is( undef, IMG::Util::DB::decode_pass() );

};

subtest 'clean_oracle_params' => sub {

	for my $n (3, 5) {

#		say "test input: " . Dumper $data->{"h$n"};
		is_deeply( IMG::Util::DB::clean_oracle_params( $data->{"h$n"} ),
		$data->{"r$n"} );


		is_deeply( IMG::Util::DB::clean_oracle_params( $data->{"r$n"} ),
		$data->{"r$n"} );
	}
	# should croak
	like(
		exception { IMG::Util::DB::clean_oracle_params },
		qr{No database connection parameters specified},
		'testing error handling'
	);

	like(
		exception { IMG::Util::DB::clean_oracle_params( 'a', 'b', 'c' ) },
		qr{clean_oracle_params expects a hash ref as input},
		'error handling'
	);
};

subtest 'read_oracle_connection_file' => sub {

	for my $n (1, 5) {
		my $fname = write_env_file( $data->{"h$n"} );
		my $contents = IMG::Util::File::file_slurp($fname);

		my $env = IMG::Util::DB::_read_oracle_connection_file( { file => $fname } );
		is_deeply(
			$env,
			{ file => $fname, %{$data->{"h$n"}} },
		);
	}
	# should croak
	like(
		exception { IMG::Util::DB::_read_oracle_connection_file },
		qr{No database specified},
		'testing error handling'
	);

	like(
		exception { IMG::Util::DB::_read_oracle_connection_file( 'a', 'b', 'c' ) },
		qr{_read_oracle_connection_file expects a hash ref},
		'error handling'
	);

	like(
		exception { IMG::Util::DB::_read_oracle_connection_file({ 'a' => 'b', 'c' => 'd' }) },
		qr{_read_oracle_connection_file expects a hash ref},
		'error handling'
	);

	like(
		exception { IMG::Util::DB::_read_oracle_connection_file({ database => 'flopsy' }) },
		qr{No config file for flopsy},
		'error handling'
	);

};

subtest 'get_oracle_connection_params' => sub {

	for my $n (1, 3, 5) {
		my $fname = write_env_file( $data->{"h$n"} );
		my $contents = IMG::Util::File::file_slurp($fname);

		my $env = IMG::Util::DB::get_oracle_connection_params( { file => $fname } );

		is_deeply(
			$env,
			$data->{"r$n"},
		);
	}

	like(
		exception { IMG::Util::DB::get_oracle_connection_params },
		qr{No database or file specified},
		'testing error handling'
	);

};

subtest 'write_oracle_connection_params' => sub {

	for my $n (1, 3, 5) {
		my($fh, $fname) = tempfile();

		IMG::Util::DB::write_oracle_connection_params($fname, $data->{"h$n"});
		my $contents = IMG::Util::File::file_slurp($fname);
		is_deeply(
			decode_json($contents),
			$data->{"r$n"},
			"Checking data round-tripping" );
	}

};

subtest 'read_and_write' => sub {

	for my $n (1, 5) {
		# create a config file; read it in, and use it to create a JSON conf file
		my $fname = write_env_file( $data->{"h$n"} );
		my $contents = IMG::Util::File::file_slurp($fname);
		my $cfg = { file => $fname };
		IMG::Util::DB::get_oracle_connection_params($cfg);

		my ($nfh, $nfname) = tempfile( SUFFIX => '.json' );
		IMG::Util::DB::write_oracle_connection_params($nfname, $cfg);

		# read the JSON file and check the params are correct
		my $conf = Config::Any->load_files({files => [ $nfname ], use_ext => 1, flatten_to_hash => 1 });
		#
		is_deeply( $conf->{ $nfname }, $data->{"r$n"} );
	}
};

subtest 'dbh' => sub {

    #    TODO: write tests for DBH creation!
    ok( 1 );

};

done_testing();

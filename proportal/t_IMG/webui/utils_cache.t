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
use File::Temp qw/tempfile tempdir/;
use WebConfig ();
use Test::MockModule;
use Test::Output;
use WebUtil ();
use_ok('Utils::Cache');

# create a fake WebConfig
my $webconfig = Test::MockModule->new('WebConfig');
my $webutil = Test::MockModule->new('WebUtil');

my $session = {
	genePageDefaultHomologs => 1,
	hideGFragment => 2,
	hideObsoleteTaxon => 3,
	hidePlasmids => 4,
	hideViruses => 5,
	hideZeroStats => 6,
	maxGeneListResults => 7,
	maxHomologResults => 8,
	maxNeighborhoods => 9,
	maxOrthologGroups => 10,
	maxParalogGroups => 11,
	maxProfileCandidateTaxons => 12,
	maxProfileRows => 13,
	minHomologAlignPercent => 14,
	minHomologPercentIdentity => 15,
	newGenePageDefault => 16,
	topHomologHideMetag => 17,
};

{
	package FakeCgi;
	use Moo;
	has data => ( is => 'ro' );
	sub Vars {
		my $self = shift;
		return $self->data;
	}
}

my $fake_cgi = FakeCgi->new( data => { cat => 'mat', dog => 'bog' } );
my $faker_cgi = FakeCgi->new( data => { frog => 'bog' } );
# 	cgi_cache_enable
# 	user_restricted_site
# 	cgi_cache_dir
# 	cgi_cache_default_expires_in
# 	cgi_cache_size

# my $cgi_cache_dir                = $env->{cgi_cache_dir};
# my $cgi_cache_default_expires_in = $env->{cgi_cache_default_expires_in} // 3600;
# my $cgi_cache_size               = $env->{cgi_cache_size} // 20 * 1024 * 1024;



#Module::Name::subroutine(@args); # mocked




# test various different combinations of environment and user configs






subtest 'cache_enabled' => sub {

	Utils::Cache::module_reset();
	$webconfig->mock('getEnv', sub { return { cgi_cache_enable => 0 }; } );

	ok( 0 == Utils::Cache::cache_enabled(), 'config: caching off, session: n/a' );

	Utils::Cache::module_reset();
	$webutil->mock('getSessionParam', sub { return 'Yes' } );

	ok( 0 == Utils::Cache::cache_enabled(), 'config: off, session: on' );

	Utils::Cache::module_reset();
	$webconfig->mock('getEnv', sub { return { cgi_cache_enable => 1 }; } );
	$webutil->mock('getSessionParam', sub { return 'No' } );
	ok( 0 == Utils::Cache::cache_enabled(), 'config: on, session: off' );

	Utils::Cache::module_reset();
	$webutil->mock('getSessionParam', sub { return 'Yes' } );
	ok( 1 == Utils::Cache::cache_enabled(), 'config: on, session: on' );

	Utils::Cache::module_reset();
	$webconfig->mock('getEnv', sub { return {} } );
	ok( 1 == Utils::Cache::cache_enabled(), 'config: absent, session: on' );

	Utils::Cache::module_reset();
	$webutil->mock('getSessionParam', sub { return 'No' } );
	ok( 0 == Utils::Cache::cache_enabled(), 'config: absent, session: off' );

	Utils::Cache::module_reset();
	$webutil->mock('getSessionParam', sub { return undef } );
	ok( 1 == Utils::Cache::cache_enabled(), 'config: absent, session: absent' );

};

subtest 'create cache options' => sub {

	my $d = File::Temp->newdir();
	my $default = {
		directory_umask => 002, # same as 755
		cache_root => $d,
		namespace => '_0',
		max_size => 20*1024*1024,
		default_expires_in => 3600,
	};
	my $env = {};

	Utils::Cache::module_reset();
	$webconfig->mock('getEnv', sub { return $env } );
	$webutil->mock('getSessionParam', sub { return undef } );
	ok( 1 == Utils::Cache::cache_enabled(), 'Caching is on' );

	throws_ok { Utils::Cache::_create_cache_options() } qr[No CGI cache dir configured];

	# test R/W of cache dir
	Utils::Cache::module_reset();
	$env = { cgi_cache_dir => $d };
	ok( 1 == Utils::Cache::cache_enabled(), 'Caching is on' );

	chmod 0400, $d;
	throws_ok { Utils::Cache::_create_cache_options() } qr[CGI cache dir .*? must be a writable directory], 'cache dir permissions: 0400';

	chmod 0200, $d;
	throws_ok { Utils::Cache::_create_cache_options() } qr[CGI cache dir .*? must be a writable directory], 'cache dir permissions: 0200';

	chmod 0755, $d;
	is_deeply( Utils::Cache::_create_cache_options(), $default, 'chmod 755, checking options with no arguments' );

	$default->{namespace} = 'blob_0';
	is_deeply( Utils::Cache::_create_cache_options('blob'), $default, 'Adding a namespace' );

	$default->{max_size} = 1024;
	is_deeply( Utils::Cache::_create_cache_options('blob', $default->{max_size}), $default, 'Namespace, size');

	$default->{default_expires_in} = 120;
	is_deeply( Utils::Cache::_create_cache_options('blob', $default->{max_size}, $default->{default_expires_in}), $default, 'Setting namespace, size, expiry');

	Utils::Cache::module_reset();
	$env->{cgi_cache_size} = 10;
	$env->{cgi_cache_default_expires_in} = 60;
	$default->{max_size} = 10;
	is_deeply( Utils::Cache::_create_cache_options('blob', undef, 120), $default, 'Namespace, size');

	Utils::Cache::module_reset();
	$default->{default_expires_in} = 60;
	is_deeply( Utils::Cache::_create_cache_options('blob'), $default, 'Setting namespace, size, expiry');


	Utils::Cache::module_reset();
	$env->{cgi_cache_enable} = 1;
	$env->{user_restricted_site} = 1;
	$webutil->mock('getSessionId', sub { return 12345; } );
	$default->{namespace} = 'blob_12345';
	is_deeply( Utils::Cache::_create_cache_options('blob'), $default, 'namespace with session ID');

	Utils::Cache::module_reset();
	$webutil->mock('getSessionId', sub {} );
	$default->{namespace} = 'blob_session_id';
	is_deeply( Utils::Cache::_create_cache_options('blob'), $default, 'namespace without session ID');

	Utils::Cache::module_reset();
	$env->{user_restricted_site} = 0;
	$webutil->mock('getSessionId', sub { return 12345; } );
	$default->{namespace} = '_0';
	is_deeply( Utils::Cache::_create_cache_options(), $default, 'namespace without session ID');

};

subtest 'get edited prefs' => sub {

	Utils::Cache::module_reset();
	my $params = Utils::Cache::relevant_prefs();
	my %undef_prefs;
	@undef_prefs{ @$params } = ('') x scalar( @$params );

	$webutil->mock('getSessionParam', sub { my $arg = shift; return $session->{ $arg } // undef; } );

	is_deeply( Utils::Cache::get_edited_prefs(), $session, 'Checking a fully-populated session hash' );

	$webutil->mock('getSessionParam', sub { return undef; } );
	is_deeply( Utils::Cache::get_edited_prefs(), \%undef_prefs, 'Checking that undef prefs work' );

};


subtest 'create cache key' => sub {

	# uses edited prefs
	# CGI query vars

	$webutil->mock('getCgi', sub { return $fake_cgi; } );
	$webutil->mock('getSessionParam', sub { my $arg = shift; return $session->{ $arg } // undef; } );

	my $k = Utils::Cache::_create_cache_key();
	is_deeply( { query => { cat => 'mat', dog => 'bog' }, prefs => $session }, $k, 'Checking key creation' );


};


subtest 'cache init' => sub {

	my $d = File::Temp->newdir();
	my $env = { cgi_cache_dir => $d };
	$webconfig->mock('getEnv', sub { return $env } );
	$webutil->mock('getSessionParam', sub { return undef } );

	my $cgi = $fake_cgi;
	$webutil->mock('getCgi', sub { return $cgi; } );

	is_deeply( WebUtil::getCgi()->Vars(), { cat => 'mat', dog => 'bog' }, 'Checking Vars works' );
	ok( 1 == Utils::Cache::cache_enabled(), 'Caching is on' );

	Utils::Cache::module_reset();
	Utils::Cache::cache_init('trapeze');

#	stdout_is {
	Utils::Cache::cgiCacheStart() or die 'There should be no cached data';
#	} '', 'There should be no cached query';
	print 'The cat is on the mat.';
	print "\n";
	print 'The dog is in the bog.';
	print "\n";
	Utils::Cache::cgiCacheStop();

	Utils::Cache::module_reset();
	Utils::Cache::cgiCacheInitialize('trapeze');

	{
#	stdout_is {
		Utils::Cache::cgiCacheStart() or ok( 1, 'There should be cached data' );

#	} "The cat is on the mat.\nThe dog is in the bog.\n", 'Found cached data!';
		Utils::Cache::cgiCacheStop();
	}

	Utils::Cache::module_reset();
	$cgi = $faker_cgi;
	Utils::Cache::cache_init('trapeze');
#	stdout_is {
	Utils::Cache::cgiCacheStart() or die 'There should be no cached query';
#	} '', 'New, uncached query';
	Utils::Cache::stop_caching();

};







done_testing();

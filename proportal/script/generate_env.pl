#!/usr/bin/env perl

use strict;
use warnings;
use feature ':5.16';
use Data::Dumper;

use FindBin qw/ $Bin /;
use lib ( "$Bin/../lib", "$Bin/../../webui.cgi" );
use File::Basename;

use WebConfig qw(getEnv);
use IMG::Util::DB;

$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent = 1;

my $env = getEnv();
my $config;

# read in the basic config file
sub _read_base_config {

	# read in file...
	$config = ...;

}

=head2 generate_env.pl

generate the environment file

=cut


# 'ssl_enabled' => 1,
# 'sso_api_url' => 'https://signon.jgi-psf.org/api/sessions/',
# 'sso_cookie_name' => 'jgi_return',
# 'sso_domain' => '.jgi-psf.org',
# 'sso_enabled' => 0,
# 'sso_session_cookie_name' => 'jgi_session',
# 'sso_url' => 'https://signon.jgi-psf.org',
# 'sso_user_info_url' => 'https://signon.jgi-psf.org/api/users/',

sub _generate_sso_info {

	if ( $env->{sso_enabled} ) {
		$config->{sso} = {
			enabled => 1,
			domain => $env->{sso_domain},
			url_prefix => 'https://signon',
		};
	}
}

sub _generate_db_data {

	# read in the db config files
use Util::DB;
my $base = dirname( $Bin );

my $cfg = Util::DB::get_oracle_cfg_files;

for my $d (keys %$cfg) {
	# read in the env files
	my $p = Util::DB::get_oracle_connection_params({ database => $d });


	db => {
		# config details
		imgsqlite => {
			driver => 'SQLite',
			database => 'share/dbschema-img_core.db',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
			},
	#		log_queries => 1,
		},
		img_gold => { # this is GOLD
			driver => 'Oracle',
			database => 'imgiprd',
			user => 'imgsg_dev',
			password => 'Tuesday',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
			},
		},


}

sub _generate_session {

	if ( $env->{sessions_enabled} ) {
		$config->{session} = 'CGISession';
	}

	$config->{engines}{session}{CGISession} = {
		cookie_name => 'CGISESSID_proportal',
		cookie_duration => '1.5 hours',
		driver_params => $env->{cgi_tmp_dir} // '/tmp',
	};
}


############################################################################
#	Cache interface
#
# $Id: Cache.pm 34276 2015-09-17 22:02:39Z aireland $
############################################################################
package Utils::Cache;

use strict;
use warnings;
use feature ':5.16';
use WebConfig ();
use WebUtil ();
use CGI::Cache;
use Data::Dumper::Concise;

# Force flush
$| = 1;

my $env;

my $cache_enabled;

# Is cgi cache enabled
#
# All tools / files should call this method for find out if to use cache.
# Never get cache flag from the WebConfig directly since
# users can override cache flag in their prefs.
# MyIMG.pm is only file that should use the WebConfig cache flag to setup prefs correctly
# - ken
#

=head3 cache_enabled

Is the cache enabled or not? Initialise the value if it has not yet been set.

=cut

sub cache_enabled {

	return $cache_enabled if defined $cache_enabled;
	$env = WebConfig::getEnv() unless defined $env;

	$cache_enabled = $env->{cgi_cache_enable} // 1;
	if ( $cache_enabled ) {
		# defaults to being enabled
		my $user_cache = WebUtil::getSessionParam('userCacheEnable') // 'Yes';
		$cache_enabled = ( 'Yes' eq $user_cache ) ? 1 : 0;
	}
	return $cache_enabled;
}
*isCgiCacheEnable = \&cache_enabled;

#
# intialize cache
# namespace - name the cache file
#
sub cache_init {

	return unless cache_enabled();

	CGI::Cache::setup({
		cache_options => _create_cache_options( @_ ),
	});

	my $key = _create_cache_key();
	# cache key can be a data structure, so let's use the params/prefs hashref
	CGI::Cache::set_key( $key );
#	CGI::Cache::invalidate_cache_entry() if $query->param('force_regenerate') eq 'true';
}
*cgiCacheInitialize = \&cache_init;

=head3 set_key

Alias for CGI::Cache's set_key

=cut

sub set_key {
	return unless cache_enabled();
	my $key = shift;
	CGI::Cache::set_key( $key );
}

=head3 _create_cache_options

Set up the options hash for the cache.

Default values are used for the cache size and expiry time if not specified in $env or in the arguments.

@param  $namespace - namespace for the cache
@param  $override_cache_size -   if specified, will override the cache size parameter
                                 specifed in $env->{cgi_cache_size}
@param  $override_expires_time - if specified, overrides the cache expiry time, set
                                 in $env->{cgi_cache_default_expires_in}

@return $hash of options

dies if the CGI cache directory is not configured ($env->{cgi_cache_dir}) or if the directory cannot be written.

=cut

sub _create_cache_options {
	return unless cache_enabled();
	my ( $namespace, $override_cache_size, $override_expires_time ) = @_;
	# make sure the cache directory is configured and that it exists
	die 'No CGI cache dir configured' unless exists $env->{cgi_cache_dir} && defined $env->{cgi_cache_dir};

    if ( ! -e $env->{cgi_cache_dir} || ! -d _ ) {
        die 'CGI cache dir ' . $env->{cgi_cache_dir} . ' does not exist';
    }
    elsif ( ! -r _ || ! -w _ ) {
    	die 'CGI cache dir ' . $env->{cgi_cache_dir} . ' must be a writable directory';
    }

	my $opt_h = {
		directory_umask => 002, # same as 755
		cache_root => $env->{cgi_cache_dir},
		namespace => $namespace || '',
	};

	if ( $env->{user_restricted_site} ) {
		# session-based cache
		$opt_h->{namespace} .= '_' . ( WebUtil::getSessionId() || 'session_id' );
	}
	else {
		# public system shared cache
		$opt_h->{namespace} .= '_0';
	}

	$opt_h->{max_size} = $override_cache_size // $env->{cgi_cache_size} // 20 * 1024 * 1024;

	$opt_h->{default_expires_in} = $override_expires_time //  $env->{cgi_cache_default_expires_in} // 3600;

	return $opt_h;

}

=head3 _create_cache_key

Use the query parameters and the session prefs to create a cache key

TODO: not all queries are affected by the prefs setting; only use relevant prefs
as cache keys.

@return  $params -- parameter hash ref

=cut

sub _create_cache_key {

	return unless cache_enabled();
	# user can change preferences so let's hack into
	# cgi params and set the hide prefs
	# the cgi cache system can decide to use cache or not - Ken

	my $query = WebUtil::getCgi();
	my $params = $query->Vars;
	my $prefs_href = get_edited_prefs();

	return { query => $params, prefs => $prefs_href };

}

#
# return is 0 - use cache pages
# return is 1 continue running the program as usual
# usage
#   HtmlUtil::cgiCacheStart() or return;
#
sub start_caching {
	return 1 unless cache_enabled();
	return CGI::Cache::start();
}

*cgiCacheStart = \&start_caching;

# stop caching pages
#The stop() routine tells us to stop capturing output. The argument
# "cache_output" tells us whether or not to store the captured output in the
#cache. By default this argument is 1, since this is usually what we want to
#do. In an error condition, however, we may not want to cache the output.
# A cache_output argument of 0 is used in this case.
# http://search.cpan.org/~dcoppit/CGI-Cache-1.4200/lib/CGI/Cache.pm
sub stop_caching {
	return unless cache_enabled();
	my $cache_output = shift;
	if ( $cache_output ) {
		return CGI::Cache::stop( cache_enabled() );
	} else {
		return CGI::Cache::stop();
	}
}
*cgiCacheStop = \&stop_caching;

# pause caching
sub pause_caching {
	return CGI::Cache::pause() if cache_enabled();
}
*cgiCachePause = \&pause_caching;

# continue caching from a pause
sub continue_caching {
	return CGI::Cache::continue() if cache_enabled();
}
*cgiCacheContinue = \&continue_caching;

=head3 relevant_prefs

Preferences relevant to caching. Possibly.

@return  $arrayref of preference ID strings

=cut

sub relevant_prefs {

	# params to omit:
	# genomeListColPrefs
	# userCacheEnable
	return [ qw(
		genePageDefaultHomologs
		hideGFragment
		hideObsoleteTaxon
		hidePlasmids
		hideViruses
		hideZeroStats
		maxGeneListResults
		maxHomologResults
		maxNeighborhoods
		maxOrthologGroups
		maxParalogGroups
		maxProfileCandidateTaxons
		maxProfileRows
		minHomologAlignPercent
		minHomologPercentIdentity
		newGenePageDefault
		topHomologHideMetag
	) ];

}

=head3 get_edited_prefs

Get the relevant preferences from the session

@return  hashref of preferences

TODO: switch to reading prefs file?

=cut

sub get_edited_prefs {

	my $prefs = relevant_prefs();

	my %sess_h;

	@sess_h{ @$prefs } = map { WebUtil::getSessionParam($_) // '' } @$prefs;

	return \%sess_h;

}

=head3 module_reset

Undefine $env and $cache_enabled for testing purposes

=cut

sub module_reset {

	undef $env;
	undef $cache_enabled;

}

1;

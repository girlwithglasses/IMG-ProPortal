############################################################################
#   Cache functionality
#
# $Id: CacheUtil.pm 33804 2015-07-24 20:07:15Z jinghuahuang $
############################################################################
package CacheUtil;

use strict;
use warnings;
use feature ':5.16';
use Time::localtime;
use WebConfig ();
use WebUtil ();
use CGI::Cache;

# Force flush
$| = 1;

my $env = WebConfig::getEnv();

=cut

my $cgi_dir              = $env->{cgi_dir};
my $cgi_url              = $env->{cgi_url};
my $main_cgi             = $env->{main_cgi};
my $inner_cgi            = $env->{inner_cgi};
my $tmp_url              = $env->{tmp_url};
my $tmp_dir              = $env->{tmp_dir};
my $verbose              = $env->{verbose};
my $include_metagenomes  = $env->{include_metagenomes};
my $web_data_dir         = $env->{web_data_dir};
my $img_internal         = $env->{img_internal};
my $user_restricted_site = $env->{user_restricted_site};
my $cgi_tmp_dir          = $env->{cgi_tmp_dir};
my $base_url             = $env->{base_url};
my $img_ken              = $env->{img_ken};
my $kegg_brite_tree_file = $env->{kegg_brite_tree_file};
my $preferences_url      = "$main_cgi?section=MyIMG&page=preferences";

my $maxGeneListResults = 1000;

=cut

my $cgi_cache_enable = $env->{cgi_cache_enable} // 1;

my $cgi_cache_dir                = $env->{cgi_cache_dir};
my $cgi_cache_default_expires_in = $env->{cgi_cache_default_expires_in} // 3600;
my $cgi_cache_size               = $env->{cgi_cache_size} // 20 * 1024 * 1024;


#$cgi_cache_size = 20 * 1024 * 1024 if ( $cgi_cache_size eq "" );

#	check whether the cache is enabled or not
if ( $cgi_cache_enable ) {
	# defaults to being enabled
    my $userCacheEnable = getSessionParam("userCacheEnable") || 'Yes';
	$cgi_cache_enable = ( 'Yes' eq $userCacheEnable ) ? 1 : 0;
}

#
# Is cgi cache enabled
#
# All tools / files should call this method for find out if to use cache.
# Never get cache flag from the WebConfig directly since
# users can override cache flag in their prefs.
# MyIMG.pm is only file that should use the WebConfig cache flag to setup prefs correctly
# - ken
#
sub isCgiCacheEnable {

    return $cgi_cache_enable;

}

#
# intialize cache
# namespace - name the cache file
#
sub cgiCacheInitialize {

    my ( $namespace, $override_cache_size, $override_expires_time ) = @_;

    if( $env->{user_restricted_site} ) {
        # session cache
        my $sid = WebUtil::getSessionId();
        $namespace .= '_' . $sid;
    } else {
        # public system shared cache
        $namespace .= '_0';
    }
    WebUtil::webLog("cache file namespace ====== $namespace \n");


    if ($cgi_cache_enable) {

        my $query = WebUtil::getCgi();
        require MyIMG;
        my $prefs_href = MyIMG::getSessionParamHash();

        # user can change preferences so let's hack into
        # cgi params and set the hide prefs
        # the cgi cache system can decide to use cache or not - Ken
        my $params = $query->Vars;
        foreach my $key (keys %$prefs_href) {
            $params->{$key} = $prefs_href->{$key};
            #print "$key ".  $prefs_href->{$key} . " <br/>\n";
        }

        # Set up a cache in /tmp/CGI_Cache/demo_cgi, with publicly
        # unreadable cache entries, a maximum size of 20 megabytes,
        # and a time-to-live of 6 hours.
        #
        # default_expires_in in seconds can use
        # 10 minutes or 1 hours
        # http://search.cpan.org/dist/Cache-Cache/lib/Cache/Cache.pm
        # umask 022 == chmod 755
        # 002 == 775
        my $tmp_size = $override_cache_size // $cgi_cache_size;
#        $tmp_size = $override_cache_size if ( $override_cache_size ne "" );
        my $tmp_time = $override_expires_time // $cgi_cache_default_expires_in;
#        $tmp_time = $override_expires_time if ( $override_expires_time ne "" );
        CGI::Cache::setup({
			cache_options => {
				cache_root         => $cgi_cache_dir,
				namespace          => $namespace,
				directory_umask    => 002,
				max_size           => $tmp_size,
				default_expires_in => $tmp_time,
			}
		});

        my $myhashkey;
        my $params = $query->Vars;
        foreach my $key ( sort keys %$params ) {
            my $val = $params->{$key};
            #webLog("$key ==> $val \n") if ($img_ken);
            $myhashkey .= $key . $val;
        }

        # CGI::Vars requires CGI version 2.50 or better
        #CGI::Cache::set_key( $query->Vars );
        CGI::Cache::set_key( $myhashkey );
        CGI::Cache::invalidate_cache_entry() if $query->param('force_regenerate') eq 'true';

        #CGI::Cache::start() or return;
    }
}

#
# return is 0 - use cache pages
# return is 1 continue running the program as usual
# usage
#   HtmlUtil::cgiCacheStart() or return;
#
sub cgiCacheStart {
    if ( $cgi_cache_enable ) {
        return CGI::Cache::start();
    } else {
        return 1;
    }
}

# stop caching pages
#The stop() routine tells us to stop capturing output. The argument
# "cache_output" tells us whether or not to store the captured output in the
#cache. By default this argument is 1, since this is usually what we want to
#do. In an error condition, however, we may not want to cache the output.
# A cache_output argument of 0 is used in this case.
# http://search.cpan.org/~dcoppit/CGI-Cache-1.4200/lib/CGI/Cache.pm
sub cgiCacheStop {
    my ( $cache_output ) = @_;
    if ( $cgi_cache_enable ) {
        if ( $cache_output ne "" ) {
            return CGI::Cache::stop( $cgi_cache_enable );
        } else {
            return CGI::Cache::stop();
        }
    }
}

# pause caching
sub cgiCachePause {
    if ( $cgi_cache_enable ) {
        return CGI::Cache::pause();
    }
}

# continue caching from a pause
sub cgiCacheContinue {
    if ( $cgi_cache_enable ) {
        return CGI::Cache::continue();
    }
}


1;

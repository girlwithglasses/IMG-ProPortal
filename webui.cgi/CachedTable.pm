############################################################################
# CachedTable.pm - Wrapper that selectively loads Yahoo! tables
#
# In WebConfig.pm, set
#              $e->{ yui_tables } = 1;  #for Yahoo! tables
#    OR
#              $e->{ yui_tables } = 0;  #for HTML tables
#
# $Id: CachedTable.pm 36990 2017-04-25 17:08:44Z klchu $
############################################################################
use WebUtil;
use WebConfig;

# =======================================================================
#
# OLD ----- use InnerTable instead - ken
#
# =======================================================================  

my $env        = getEnv( );
my $yui_tables = $env->{ yui_tables };
my $ext_tables = $env->{ ext_tables };

if ($yui_tables) {
    require CachedTable_yui;
} elsif ($ext_tables) {
    require CachedTable_yui;
} else {
    require CachedTable_old;
}

1;


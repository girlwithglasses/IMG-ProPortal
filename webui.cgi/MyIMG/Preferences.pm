package UserPreferences;

use IMG::Util::Base 'Class';

my $prefs = {
	maxParalogGroups => {
		label   => 'Maximum paralog groups',
		values  => [ 500, 1000, 2000, 10000 ],
		default => 500,
	},
	maxGeneListResults => {
		label   => 'Maximum gene, scaffold list results',
		values  => [ 100, 200, 1000, 2000, 5000, 10000, 20000 ],
		default => 1000,
	},
	maxHomologResults => {
		label   => 'Maximum homolog results',
		values  => [ 100, 200, 1000, 2000, 5000, 10000, 20000 ],
		default => 200,
	},
	maxNeighborhoods => {
		label   => 'Maximum taxon gene neighborhoods',
		values  => [ 3, 5, 10, 15, 20, 40 ],
		default => 5,
	},
	minHomologPercentIdentity => {
		label   => 'Minimum homolog percent identity',
		values  => [ 10, 20, 30, 40, 50, 60, 70, 80, 90 ],
		default => 30,
	},
	hideViruses => {
		label   => 'Hide viruses from genome lists',
		values  => [ 'Yes', 'No' ],
		default => 'Yes',
	},
	hidePlasmids => {
		label   => 'Hide plasmids from genome lists',
		values  => [ 'Yes', 'No' ],
		default => 'Yes',
		condition => sub { return $env->{include_plasmids}; },
	},
	hideGFragment => {
		label   => 'Hide GFragment from genome lists',
		values  => [ 'Yes', 'No' ],
		default => 'Yes'
	},
	hideObsoleteTaxon => {
		label   => 'Hide obsolete genomes',
		values  => [ 'Yes', 'No' ],
		default => 'Yes',
		condition => sub { return $env->{img_taxon_edit}; },
	},
	hideZeroStats => {
		label   => 'Hide zeroes in genome statistics',
		values  => [ 'Yes', 'No' ],
		default => 'Yes'
	},
    # hide metagenomes in top homolog results
	topHomologHideMetag => {
		label   => 'Hide metagenomes in top homolog results',
		values  => [ 'Yes', 'No' ],
		default => 'No',
		condition => sub { return $env->{include_metagenomes} && $env->{img_internal}; },
	},
    # let user turn off caching (if enabled in config file)
	userCacheEnable => {
		label   => 'Use session cache (recommended)',
		values  => [ 'Yes', 'No' ],
		default => 'Yes',
		condition => sub { return $env->{cgi_cache_enable}; },
	},
	genomeListColPrefs => {
		label   => 'Save genome list column preferences',
		values  => [ 'Yes', 'No' ],
		default => 'No',
		condition => sub { return $env->{user_restricted_site}; },
	},
};



    my $maxOrthologGroups         = getSessionParam("maxOrthologGroups");
    my $maxParalogGroups          = getSessionParam("maxParalogGroups") // 500;

    my $maxProfileCandidateTaxons = getSessionParam("maxProfileCandidateTaxons");
    my $genePageDefaultHomologs   = getSessionParam("genePageDefaultHomologs");

    my $maxGeneListResults        = getSessionParam("maxGeneListResults") // 1000;
    my $maxHomologResults         = getSessionParam("maxHomologResults") // 200;
    my $maxNeighborhoods          = getSessionParam("maxNeighborhoods") // 5;
    my $maxProfileRows            = getSessionParam("maxProfileRows") // 1000;
    my $minHomologPercentIdentity = getSessionParam("minHomologPercentIdentity") // 30;
    my $minHomologAlignPercent    = getSessionParam("minHomologAlignPercent") // 10;


    my $hideViruses               = getSessionParam("hideViruses") // 'Yes';
    my $hidePlasmids              = getSessionParam("hidePlasmids") // 'Yes';
    my $hideGFragment             = getSessionParam("hideGFragment") // 'Yes';
    my $newGenePageDefault        = getSessionParam("newGenePageDefault") // 'No';

    # for taxon editor
    my $hideObsoleteTaxon = getSessionParam("hideObsoleteTaxon") // 'Yes';

    # Hide rows with zeroes in Genome browser > Genome Statistics
    my $hideZeroStats = getSessionParam("hideZeroStats") // 'Yes';

    # cgi cache a preferenc to turn off iff on
    # users cannot turn it on if off in config - ken
    my $userCacheEnable;
    if ($cgi_cache_enable) {
        $userCacheEnable = getSessionParam("userCacheEnable") // 'Yes';
        $userCacheEnable = "Yes" if ( $userCacheEnable eq "" );    # it was never set
    }

    my $genomeListColPrefs;
    if ($user_restricted_site) {
        $genomeListColPrefs = getSessionParam("genomeListColPrefs") // 'No';
        $genomeListColPrefs = "No" if ( $genomeListColPrefs eq "" );
    }

    my $topHomologHideMetag;
    if ( $include_metagenomes && $img_internal ) {
        $topHomologHideMetag = getSessionParam("topHomologHideMetag") // 'No';
        $topHomologHideMetag = "No" if ( $topHomologHideMetag eq "" );    # it was never set
    }




package MyIMG::Preferences;

use IMG::Util::Base;





############################################################################
# Remember cgi cache uses session params for caching see HtmlUtil.pm - ken
# gets hash of session param: sesison param => value,
############################################################################
sub getSessionParamHash {

    my $genePageDefaultHomologs   = getSessionParam("genePageDefaultHomologs");

    my $hideGFragment             = getSessionParam("hideGFragment") // 'Yes'
    my $hideObsoleteTaxon         = getSessionParam("hideObsoleteTaxon") // 'Yes';
    my $hidePlasmids              = getSessionParam("hidePlasmids") // 'Yes'
    my $hideViruses               = getSessionParam("hideViruses") // 'Yes';
    my $hideZeroStats             = getSessionParam("hideZeroStats") // 'Yes'

    my $maxGeneListResults        = getSessionParam("maxGeneListResults") // 1000;
    my $maxHomologResults         = getSessionParam("maxHomologResults") // 200;
    my $maxNeighborhoods          = getSessionParam("maxNeighborhoods") // 15;

    my $maxOrthologGroups         = getSessionParam("maxOrthologGroups");
    my $maxParalogGroups          = getSessionParam("maxParalogGroups");
    my $maxProfileCandidateTaxons = getSessionParam("maxProfileCandidateTaxons");

    my $maxProfileRows            = getSessionParam("maxProfileRows") // 1000;
    my $minHomologAlignPercent    = getSessionParam("minHomologAlignPercent") // 10;
    my $minHomologPercentIdentity = getSessionParam("minHomologPercentIdentity") // 30;
    my $newGenePageDefault        = getSessionParam("newGenePageDefault") // 'No';
    my $topHomologHideMetag       = getSessionParam("topHomologHideMetag") // 'No';

    # userCacheEnable param was skipped on purpose - ken
    # genomeListColPrefs param was skipped on purpose - ken

	my @prefs = qw( hideViruses hidePlasmids hideGFragment hideZeroStats maxOrthologGroups maxParalogGroups maxGeneListResults maxHomologResults maxNeighborhoods maxProfileCandidateTaxons maxProfileRows minHomologPercentIdentity minHomologAlignPercent genePageDefaultHomologs newGenePageDefault hideObsoleteTaxon topHomologHideMetag );

	my %sess_h;

	@sess_h{ @prefs } = map { getSessionParam($_) || '' } @prefs;

	return \%sess_h;

    my %sessionParamHash = (
        "hideViruses"               => $hideViruses,
        "hidePlasmids"              => $hidePlasmids,
        "hideGFragment"             => $hideGFragment,
        "hideZeroStats"             => $hideZeroStats,
        "maxOrthologGroups"         => $maxOrthologGroups,
        "maxParalogGroups"          => $maxParalogGroups,
        "maxGeneListResults"        => $maxGeneListResults,
        "maxHomologResults"         => $maxHomologResults,
        "maxNeighborhoods"          => $maxNeighborhoods,
        "maxProfileCandidateTaxons" => $maxProfileCandidateTaxons,
        "maxProfileRows"            => $maxProfileRows,
        "minHomologPercentIdentity" => $minHomologPercentIdentity,
        "minHomologAlignPercent"    => $minHomologAlignPercent,
        "genePageDefaultHomologs"   => $genePageDefaultHomologs,
        "newGenePageDefault"        => $newGenePageDefault,
        "hideObsoleteTaxon"         => $hideObsoleteTaxon,
        "topHomologHideMetag"       => $topHomologHideMetag,
    );
    return \%sessionParamHash;
}

############################################################################
# printPreferences - Show preferences form.
############################################################################
sub printPreferences {
    my $maxOrthologGroups         = getSessionParam("maxOrthologGroups");
    my $maxParalogGroups          = getSessionParam("maxParalogGroups") // 500;

    my $maxGeneListResults        = getSessionParam("maxGeneListResults") // 1000;
    my $maxHomologResults         = getSessionParam("maxHomologResults") // 200;
    my $maxNeighborhoods          = getSessionParam("maxNeighborhoods") // 5;
    my $maxProfileRows            = getSessionParam("maxProfileRows") // 1000;
    my $minHomologPercentIdentity = getSessionParam("minHomologPercentIdentity") // 30;
    my $minHomologAlignPercent    = getSessionParam("minHomologAlignPercent") // 10;
    my $hideViruses               = getSessionParam("hideViruses") // 'Yes';
    my $hidePlasmids              = getSessionParam("hidePlasmids") // 'Yes';
    my $hideGFragment             = getSessionParam("hideGFragment") // 'Yes';
    my $newGenePageDefault        = getSessionParam("newGenePageDefault") // 'No';

    my $maxProfileCandidateTaxons = getSessionParam("maxProfileCandidateTaxons");
    my $genePageDefaultHomologs   = getSessionParam("genePageDefaultHomologs");

    # for taxon editor
    my $hideObsoleteTaxon = getSessionParam("hideObsoleteTaxon") // 'Yes';

    # Hide rows with zeroes in Genome browser > Genome Statistics
    my $hideZeroStats = getSessionParam("hideZeroStats") // 'Yes';

    # cgi cache a preferenc to turn off iff on
    # users cannot turn it on if off in config - ken
    my $userCacheEnable;
    if ($cgi_cache_enable) {
        $userCacheEnable = getSessionParam("userCacheEnable") // 'Yes';
        $userCacheEnable = "Yes" if ( $userCacheEnable eq "" );    # it was never set
    }

    my $genomeListColPrefs;
    if ($user_restricted_site) {
        $genomeListColPrefs = getSessionParam("genomeListColPrefs") // 'No';
        $genomeListColPrefs = "No" if ( $genomeListColPrefs eq "" );
    }

    my $topHomologHideMetag;
    if ( $include_metagenomes && $img_internal ) {
        $topHomologHideMetag = getSessionParam("topHomologHideMetag") // 'No';
        $topHomologHideMetag = "No" if ( $topHomologHideMetag eq "" );    # it was never set
    }

    print pageAnchor("Preferences");
    print start_form( -name => "preferencesForm", -action => "$section_cgi" );
    print "<h2>Preferences</h2>\n";
    if ($user_restricted_site) {
        print qq{
            <p>
            Your preferences will be saved in the Workspace and will be used the next time you login.
            </p>
        };
    }

		label => 'Max. Paralog Groups',
        -name    => "maxParalogGroups",
        -values  => [ 500, 1000, 2000, 10000 ],
        -default => "$maxParalogGroups"
    );

		label => 'Max. Gene / Scaffold List Results',
        -name    => "maxGeneListResults",
        -values  => [ 100, 200, 1000, 2000, 5000, 10000, 20000 ],
        -default => "$maxGeneListResults"
    );

		label => 'Max. Homolog Results',
        -name    => "maxHomologResults",
        -values  => [ 100, 200, 1000, 2000, 5000, 10000, 20000 ],
        -default => "$maxHomologResults"
    );

		label => 'Max. Taxon Gene Neighborhoods',
        -name    => "maxNeighborhoods",
        -values  => [ 3, 5, 10, 15, 20, 40 ],
        -default => "$maxNeighborhoods"
    );
		label => 'Min. Homolog Percent Identity',
        -name    => "minHomologPercentIdentity",
        -values  => [ 10, 20, 30, 40, 50, 60, 70, 80, 90 ],
        -default => "$minHomologPercentIdentity"
    );
		label => 'Hide Viruses From Genome Lists',
        -name    => "hideViruses",
        -values  => [ 'Yes', 'No' ],
        -default => "$hideViruses"
    );

    if ($include_plasmids) {
		label => 'Hide Plasmids From Genome Lists',
            -name    => "hidePlasmids",
            -values  => [ 'Yes', 'No' ],
            -default => "$hidePlasmids"
        );
    }

		label => 'Hide GFragment From Genome Lists',
        -name    => "hideGFragment",
        -values  => [ 'Yes', 'No' ],
        -default => "$hideGFragment"
    );

    if ($img_taxon_edit) {
		label => 'Hide Obsolete Genomes',
            -name    => "hideObsoleteTaxon",
            -values  => [ 'Yes', 'No' ],
            -default => "$hideObsoleteTaxon"
        );
    }


		label => 'Hide Zeroes in Genome Statistics',
        -name    => "hideZeroStats",
        -values  => [ 'Yes', 'No' ],
        -default => "$hideZeroStats"
    );

    # hide metagenomes in top homolog results
    if ( $include_metagenomes && $img_internal ) {
		label => 'Hide Metagenomes in Top Homologs Results',
            -name    => "topHomologHideMetag",
            -values  => [ 'Yes', 'No' ],
            -default => "$topHomologHideMetag"
        );
    }

    # let user turn off cache if enable in config file
    if ($cgi_cache_enable) {
		label => 'Session Cache On (Yes recommended)',
            -name    => "userCacheEnable",
            -values  => [ 'Yes', 'No' ],
            -default => "$userCacheEnable"
        );
    }

    if ($user_restricted_site) {
			label => 'Save Genome List Column Prefs',
            name    => "genomeListColPrefs",
            values  => [ 'Yes', 'No' ],
            default => "$genomeListColPrefs"
        );
    }

    #print WebUtil::hiddenVar( "page", "preferencesForm" );
    #print WebUtil::hiddenVar( "page", "message" );
    print WebUtil::hiddenVar( "message",       "Preferences saved." );
    print WebUtil::hiddenVar( "menuSelection", "Preferences" );
    my $name = "_section_${section}_setPreferences";
    print submit(
        -name  => $name,
        -value => "Save Preferences",
        -class => 'smdefbutton'
    );

    # js code in header.js
    print "<input type='button' value='Default Settings' " . "onClick='resetPreferences()' class='smbutton' />\n";
    print "<p>\n";

    my $s = "For faster processing, adjust to lower numbers.\n";
    $s .= "For more complete result lists, adjust to higher numbers.\n";
    $s .= "The default settings should work well for most users.\n";
    printHint($s);

}

############################################################################
# doSetPreferences - Handle settting of preferences after submission.
############################################################################
sub doSetPreferences {
    my $maxOrthologGroups         = param("maxOrthologGroups");
    my $maxParalogGroups          = param("maxParalogGroups");
    my $maxGeneSearchResults      = param("maxGeneSearchResults");
    my $maxGeneListResults        = param("maxGeneListResults");
    my $maxHomologResults         = param("maxHomologResults");
    my $maxNeighborhoods          = param("maxNeighborhoods");
    my $maxProfileCandidateTaxons = param("maxProfileCandidateTaxons");
    my $maxProfileRows            = param("maxProfileRows");
    my $minHomologPercentIdentity = param("minHomologPercentIdentity");
    my $minHomologAlignPercent    = param("minHomologAlignPercent");
    my $genePageDefaultHomologs   = param("genePageDefaultHomologs");
    my $hideViruses               = param("hideViruses");
    my $hidePlasmids              = param("hidePlasmids");
    my $hideGFragment             = param("hideGFragment");
    my $hideObsoleteTaxon         = param("hideObsoleteTaxon");
    my $newGenePageDefault        = param("newGenePageDefault");
    my $hideZeroStats             = param("hideZeroStats");

    #my $includeObsoleteGenes = param( "includeObsoleteGenes" );
    setSessionParam( "maxOrthologGroups",         $maxOrthologGroups );
    setSessionParam( "maxParalogGroups",          $maxParalogGroups );
    setSessionParam( "maxGeneSearchResults",      $maxGeneSearchResults );
    setSessionParam( "maxGeneListResults",        $maxGeneListResults );
    setSessionParam( "maxHomologResults",         $maxHomologResults );
    setSessionParam( "maxNeighborhoods",          $maxNeighborhoods );
    setSessionParam( "maxProfileCandidateTaxons", $maxProfileCandidateTaxons );
    setSessionParam( "maxProfileRows",            $maxProfileRows );
    setSessionParam( "minHomologPercentIdentity", $minHomologPercentIdentity );
    setSessionParam( "minHomologAlignPercent",    $minHomologAlignPercent );
    setSessionParam( "genePageDefaultHomologs",   $genePageDefaultHomologs );
    setSessionParam( "hideViruses",               $hideViruses );
    setSessionParam( "hidePlasmids",              $hidePlasmids );
    setSessionParam( "hideGFragment",             $hideGFragment );
    setSessionParam( "hideObsoleteTaxon",         $hideObsoleteTaxon );
    setSessionParam( "newGenePageDefault",        $newGenePageDefault );
    setSessionParam( "hideZeroStats",             $hideZeroStats );

    my $hashPrefs = getSessionParamHash();

    if ($cgi_cache_enable) {
        my $userCacheEnable = param("userCacheEnable");
        setSessionParam( "userCacheEnable", $userCacheEnable );
        $hashPrefs->{"userCacheEnable"} = $userCacheEnable;
    }

    if ($user_restricted_site) {
        my $genomeListColPrefs = param("genomeListColPrefs");
        setSessionParam( "genomeListColPrefs", $genomeListColPrefs );
        $hashPrefs->{"genomeListColPrefs"} = $genomeListColPrefs;
    }

    if ( $include_metagenomes && $img_internal ) {
        my $topHomologHideMetag = param("topHomologHideMetag");
        setSessionParam( "topHomologHideMetag", $topHomologHideMetag );
        $hashPrefs->{"topHomologHideMetag"} = $topHomologHideMetag;
    }

    if ( $env->{user_restricted_site} ) {
        require Workspace;
        Workspace::saveUserPreferences($hashPrefs);
    }

    #setSessionParam( "includeObsoleteGenes", $includeObsoleteGenes );

    print "<div id='message'>\n";
    print "<p>\n";
    print "Preferences set. <span style='color:red'>Reload relevant " . "pages for new settings to take effect.</span>\n";
    print "</p>\n";
    print "</div>\n";

    printPreferences();
}

# load user prefs from workspace
sub loadUserPreferences {
    if ( $env->{user_restricted_site} ) {
        require Workspace;
        my $href = Workspace::loadUserPreferences();
        foreach my $key ( keys %$href ) {
            my $value = $href->{$key};
            setSessionParam( $key, $value );
        }
    }
}

############################################################################
# printMyIMGPreferences - MyIMG preference
#                         (for gene product name display)
############################################################################
sub printMyIMGPreferences {
    if ( !$show_myimg_login ) {
        return;
    }

    my $contact_oid = WebUtil::getContactOid();
    if ( DataEntryUtil::db_isPublicUser($contact_oid) ) {
        return;
    }

    print "<h2>MyIMG Preference</h2>\n";

    # get preference from database
    my $dbh      = WebUtil::dbLogin();
    my $userPref = WebUtil::getMyIMGPref( $dbh, "MYIMG_PROD_NAME" );

    #$dbh->disconnect();

    print "<p>\n";

    # select
    print "<input type='checkbox' ";
    print "name='MYIMG_PROD_NAME' value='MYIMG_PROD_NAME' ";
    if ( blankStr($userPref) || lc($userPref) eq 'yes' ) {
        print "checked ";
    }
    print "/>\n";
    print nbsp(1);
    print "Display my annotated Product Name as Gene Product Name (if applicable).\n";
    print "<br/>\n";

    print "</p>\n";
    my $name = "_section_${section}_saveMyIMGPref";
    print submit(
        -name  => $name,
        -value => "Save MyIMG Preference to Database",
        -class => 'lgdefbutton'
    );

}

1;

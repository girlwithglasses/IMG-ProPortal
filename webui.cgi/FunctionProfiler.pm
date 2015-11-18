############################################################################
# FunctionProfiler.pm allows to select and view functions e.g. COGs
# against genomes
#
# $Id: FunctionProfiler.pm 34543 2015-10-20 21:04:12Z klchu $
############################################################################
package FunctionProfiler;
my $section = "FunctionProfiler";

use strict;
use CGI qw( :standard );
use FuncCartStor;
use WebUtil;
use WebConfig;
use MetaUtil;
use GenomeListJSON;
use HTML::Template;

my $env                 = getEnv();
my $cgi_url             = $env->{cgi_url};
my $base_dir               = $env->{base_dir};
my $base_url               = $env->{base_url};
my $YUI                    = $env->{yui_dir_28};
my $include_metagenomes = $env->{include_metagenomes};

$| = 1;

sub getPageTitle {
    return 'Function Profile';
}

sub getAppHeaderData {
    my ($self) = @_;
        require GenomeListJSON;
        my $template = HTML::Template->new( filename => "$base_dir/genomeHeaderJson.html" );
        $template->param( base_url => $base_url );
        $template->param( YUI      => $YUI );
        my $js = $template->output;
    
    
    
    my @a = ( "CompareGenomes", "", "", $js);
    return @a;
}

############################################################################
# dispatch - Dispatch loop.
############################################################################
sub dispatch {
    my ( $self, $numTaxon ) = @_;
    
    my $page = param("page");

    if ( $page eq "profiler" ) {
        printStatusLine( "Loading ...", 1 );

        my $description =
            "The Function Profiler is used to display the count (abundance) "
          . "of genes associated with a given function and a given genome. ";
        WebUtil::printHeaderWithInfo(
            "Function Profile",
            $description,
            "show description for this tool",
            "Function Profile Info",
            0, "releaseNotes2-7.pdf#page=6"
        );

        printMainForm();

        print "<p>You may view the profile of selected genomes accross selected function(s).</p>";

        print "<h2>Genome List</h2>";

        printForm();
        my $fc        = new FuncCartStor();
        my $recs      = $fc->{recs};
        my @cart_keys = keys(%$recs);

        $fc->printFunctionTable();

        if ( scalar @cart_keys > 0 ) {

            # print only one hidden page var; onclick will set it later:
            GenomeListJSON::printHiddenInputType( $section, 'runProfile_s' );

            my $name   = "_section_FunctionProfiler_runProfile_s";
            my $button = GenomeListJSON::printMySubmitButtonXDiv( 'profile_s', $name, 'View Functions vs. Genomes',
                '', $section, 'runProfile_s', 'meddefbutton', 'selectedGenome1', 1 );
            print $button;

            print nbsp(1);
            my $name   = "_section_FunctionProfiler_runProfile_t";
            my $button = GenomeListJSON::printMySubmitButtonXDiv( 'profile_t', $name, 'View Genomes vs. Functions',
                '', $section, 'runProfile_t', 'meddefbutton', 'selectedGenome1', 1 );
            print $button;

            print nbsp(1);
            print reset( -class => 'smbutton', -value => "Reset All" );
        }

        GenomeListJSON::showGenomeCart($numTaxon);
        print end_form();

    } elsif ( $page eq "runProfile_s" ) {
        runProfile("s");
    } elsif ( $page eq "runProfile_t" ) {
        runProfile("t");
    }
}

############################################################################
# printForm - genome loader used for selecting genomes
############################################################################
sub printForm {
    my $hideViruses = getSessionParam("hideViruses");
    $hideViruses = ( $hideViruses eq "" || $hideViruses eq "Yes" ) ? 0 : 1;
    my $hidePlasmids = getSessionParam("hidePlasmids");
    $hidePlasmids = ( $hidePlasmids eq "" || $hidePlasmids eq "Yes" ) ? 0 : 1;
    my $hideGFragment = getSessionParam("hideGFragment");
    $hideGFragment = ( $hideGFragment eq "" || $hideGFragment eq "Yes" ) ? 0 : 1;

    my $xml_cgi  = $cgi_url . '/xml.cgi';
    my $template = HTML::Template->new( filename => "$base_dir/genomeJsonOneDiv.html" );

    $template->param( gfr                  => $hideGFragment );
    $template->param( pla                  => $hidePlasmids );
    $template->param( vir                  => $hideViruses );
    $template->param( isolate              => 1 );
    $template->param( all                  => 1 );
    $template->param( cart                 => 1 );
    $template->param( xml_cgi              => $xml_cgi );
    $template->param( prefix               => '' );
    $template->param( maxSelected1         => -1 );
    $template->param( selectedGenome1Title => 'Please select genomes:' );

    if ($include_metagenomes) {
        $template->param( include_metagenomes => 1 );
        $template->param( selectedAssembled1  => 1 );
    }

    my $s = "";
    $template->param( mySubmitButton => $s );
    print $template->output;
}

############################################################################
# runProfile - called when 'View Functions vs. Genomes' or
#    'View Genomes vs. Functions' button is clicked
############################################################################
sub runProfile {
    my ($type) = @_;

    printStatusLine( "Loading ...", 1 );

    my $fc           = new FuncCartStor();
    my @find_toi_ref = param("selectedGenome1");
    if ( $type eq "s" ) {
        $fc->printFuncCartProfile_s( "func", "", "", "", "", \@find_toi_ref );
    } elsif ( $type eq "t" ) {
        $fc->printFuncCartProfile_t( "func", "", "", "", "", \@find_toi_ref );
    }

    printStatusLine( "Loaded.", 2 );
}

1;

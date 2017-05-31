############################################################################
#	IMG::App::Role::Dispatcher.pm
#
#	Parse query params and run the appropriate code
#
#	$Id: Dispatcher.pm 37114 2017-05-30 14:14:14Z aireland $
############################################################################
package IMG::App::Role::Dispatcher;

use IMG::Util::Import 'MooRole';
use IMG::Util::Factory;
use Sub::Override;
use Carp;

=head3 prepare_dispatch

Parse the parameters, load the module, and get ready to dispatch the code!

@return hashref with keys

		sub    - subroutine to run
		module - module to load
		tmpl   - outer page template to use (defaults to 'default')
		tmpl_args  - template arguments
		sub_to_run - reference to the subroutine to run

=cut

sub prepare_dispatch {
	my $self = shift;
	my $args = shift;

	my $prep_args = $self->parse_params( $args->{request} );

	my $sub_to_run = $self->prepare_dispatch_coderef( $prep_args );

	my @app_arg_arr = ( qw( current noMenu gwtModule yui_js scripts help redirect_url ) );
	my %arg_h;
	@arg_h{ qw( current noMenu gwtModule yui_js scripts help redirect_url ) } = $prep_args->{module}->getAppHeaderData();

#	my @appArgs = $prep_args->{module}->getAppHeaderData();
	log_debug { 'appArgs: ' . Dumper \%arg_h };

	my $tmpl_inc;

	for my $x ( 'yui_js', 'scripts' ) {
		if ( $arg_h{ $x } ) {
			$tmpl_inc->{extra_javascript} .= $arg_h{$x};
#			push @{$tmpl_inc->{scripts}}, $arg_h{ $x };
		}
	}

	if ( $arg_h{help} ) {
		$tmpl_inc->{help} = $arg_h{help};
	}

	$tmpl_inc->{title} = $prep_args->{module}->getPageTitle();

# 	my $numTaxons = printAppHeader(@appArgs) if $#appArgs > -1;
#	returns number of taxons

# sub printHTMLHead {
#     my ( $current, $title, $gwt, $content_js, $yahoo_js, $numTaxons ) = @_;
#
#     my $str = 0;
#     if ( $numTaxons ne '' ) {
#         my $url = "$main_cgi?section=GenomeCart&page=genomeCart";
#         $url = alink( $url, $numTaxons );
#         $str = "$url";
#     }
#
#     if ( $current eq "logout" || $current eq "login" ) {
#         $str = "";
#     }
#
#     my $enable_google_analytics = $env->{enable_google_analytics};
#     my $googleStr;
#     if ($enable_google_analytics) {
#         my ( $server, $google_key ) = WebUtil::getGoogleAnalyticsKey();
#         $googleStr = googleAnalyticsJavaScript2( $server, $google_key );
#         $googleStr = "" if ( $google_key eq "" );
#     }
#
#     my $template;
#
#     #if($img_ken) {
#     $template = HTML::Template->new( filename => "$base_dir/header-v41.html" );
#
#     #} else {
#     #    $template = HTML::Template->new( filename => "$base_dir/header-v40.html" );
#     #}
#     $template->param( title        => $title );
#     $template->param( gwt          => $gwt );
#     $template->param( base_url     => $base_url );
#     $template->param( YUI          => $YUI );
#     $template->param( content_js   => $content_js );
#     $template->param( yahoo_js     => $yahoo_js );
#     $template->param( googleStr    => $googleStr );
#     $template->param( top_base_url => $top_base_url );
#     print $template->output;
#
#         # if ( $current ne "logout" && $current ne "login" ) {
#         my $enable_autocomplete = $env->{enable_autocomplete};
#         if ($enable_autocomplete) {
#             print qq{
#         <div id="quicksearch">
#         <form name="taxonSearchForm" enctype="application/x-www-form-urlencoded" action="main.cgi" method="post">
#             <input type="hidden" value="orgsearch" name="page">
#             <input type="hidden" value="TaxonSearch" name="section">
#
#             <a style="color: black;" href="$base_url/orgsearch.html">
#             <font style="color: black;"> Quick Genome Search: </font>
#             </a><br/>
#             <div id="myAutoComplete" >
#             <input id="myInput" type="text" style="width: 110px; height: 20px;" name="taxonTerm" size="12" maxlength="256">
#             <input type="submit" alt="Go" value='Go' name="_section_TaxonSearch_x" style="vertical-align: middle; margin-left: 125px;">
#             <div id="myContainer"></div>
#             </div>
#         </form>
#         </div>
#             };
#
#             # https://localhost/~kchu/preComputedData/autocompleteAll.php
#             my $autocomplete_url = "$top_base_url" . "api/";
#
#             #my $autocomplete_url = "https://localhost/~kchu/api/";
#
#             if ($include_metagenomes) {
#                 $autocomplete_url .= 'autocompleteAll.php';
#             } elsif ($img_nr) {
#                 $autocomplete_url .= 'autocompleteNR.php';
#             } else {
#                 $autocomplete_url .= 'autocompleteIsolate.php';
#             }
#
#             print <<EOF;
# <script type="text/javascript">
# YAHOO.example.BasicRemote = function() {
#     // Use an XHRDataSource
#     var oDS = new YAHOO.util.XHRDataSource("$autocomplete_url");
#     // Set the responseType
#     oDS.responseType = YAHOO.util.XHRDataSource.TYPE_TEXT;
#     // Define the schema of the delimited results
#     oDS.responseSchema = {
#         recordDelim: "\\n",
#         fieldDelim: "\\t"
#     };
#     // Enable caching
#     oDS.maxCacheEntries = 5;
#
#     // Instantiate the AutoComplete
#     var oAC = new YAHOO.widget.AutoComplete("myInput", "myContainer", oDS);
#
#     return {
#         oDS: oDS,
#         oAC: oAC
#     };
# }();
# </script>
#
# EOF
#         }
#
#         #}
#
#         if ($enable_carts) {
#
#             require ScaffoldCart;
#             my $ssize = ScaffoldCart::getSize();
#             if ( $ssize > 0 ) {
#                 $ssize = alink( 'main.cgi?section=ScaffoldCart&page=index', $ssize );
#             }
#
#             require FuncCartStor;
#             my $c     = new FuncCartStor();
#             my $fsize = $c->getSize();
#             if ( $fsize > 0 ) {
#                 $fsize = alink( 'main.cgi?section=FuncCartStor&page=funcCart', $fsize );
#             }
#
#             require GeneCartStor;
#             my $gsize = GeneCartStor::getSize();
#             if ( $gsize > 0 ) {
#                 $gsize = alink( 'main.cgi?section=GeneCartStor&page=geneCart', $gsize );
#             }
#
#             my $genomeUrl    = alink( 'main.cgi?section=GenomeCart&page=genomeCart', 'Genomes' );
#             my $scaffoldUrl  = alink( 'main.cgi?section=ScaffoldCart&page=index',    'Scaffolds' );
#             my $functionsUrl = alink( 'main.cgi?section=FuncCartStor&page=funcCart', 'Functions' );
#             my $genesUrl     = alink( 'main.cgi?section=GeneCartStor&page=geneCart', 'Genes' );
#
#             my $isEditor = 0;
#             my $cursize  = 0;
#             if ($user_restricted_site) {
#                 $isEditor = WebUtil::isImgEditorWrap();
#             }
#             if ($isEditor) {
#                 require CuraCartStor;
#                 my $c = new CuraCartStor();
#                 $cursize = $c->getSize();
#                 if ( $cursize > 0 ) {
#                     $cursize = alink( 'main.cgi?section=CuraCartStor&page=curaCart', $cursize );
#                 }
#             }
#             my $bcCartSize = 0;
#             if ( $abc || $img_ken ) {
#                 require WorkspaceBcSet;
#                 $bcCartSize = WorkspaceBcSet::getSize();
#             }
#
#             print qq{
# <div id="cart">
#  &nbsp;&nbsp; <span title="Carts are unsaved sets and sets are lost during session logouts">My Analysis Carts**:</span>
#  &nbsp;&nbsp; <span id='genome_cart'>$str</span> $genomeUrl &nbsp;&nbsp;
# |&nbsp;&nbsp; <span id='scaffold_cart'>$ssize</span> $scaffoldUrl &nbsp;&nbsp;
# |&nbsp;&nbsp; <span id='function_cart'>$fsize</span> $functionsUrl &nbsp;&nbsp;
# |&nbsp;&nbsp; <span id='gene_cart'>$gsize</span> $genesUrl
#         };
#
#             if ($isEditor) {
#                 my $curationUrl = alink( 'main.cgi?section=CuraCartStor&page=curaCart', 'Curation' );
#                 print qq{
#   &nbsp;&nbsp; |&nbsp;&nbsp; <span id='curation_cart'>$cursize</span> $curationUrl
#           };
#             }
#
#             if ( $abc || $img_ken ) {
#                 my $bcurl = alink( 'main.cgi?section=WorkspaceBcSet&page=viewCart', 'BC' );
#                 print qq{
#   &nbsp;&nbsp; |&nbsp;&nbsp; <span id='bc_cart'>$bcCartSize</span> $bcurl
#           };
#             }
#
#             print "</div>";
#         } # end if ($enable_carts)
#
#     } # end if ( $current eq "logout" || $current eq "login" ) "else" section
#
#     print qq{
#     <div id="myclear"></div>
#     };
# }

# 	$module->dispatch($numTaxons);

	return { tmpl_args => $tmpl_inc, %$prep_args, sub_to_run => $sub_to_run };

};

=head3 parse_params

Parse the input query params and find the appropriate module, subroutine,
template, and template arguments to use.

@return hashref with keys

		module  - module to load
		sub     - subroutine to run
		page_id - the ID of the page
=cut

sub parse_params {
	my $self = shift;
	my $req = shift;

	coerce_section( $req );
#	my $self = $dsl->app;

	my $module;           # the module to load

	my $page = $req->param('page') || "";
	my $section = $req->param('section');

	log_debug { "page: $page; section: $section" };

	if ( $module = is_valid_module( $section ) ) {
		if ( $req->param("exportGenes") || $req->param("exportGeneData") ) {
			$module = 'Export';
		} elsif ( $req->param("setTaxonFilter") ) {
			$module = 'GenomeList';
		}
	}
	else {
		$self->choke({
			msg => 'Could not parse request params'
		});
	}

	my $page_id = ( defined $page && lc( $page ) ne 'home')
		? $module . '/' . $page
		: $module;
	log_debug { 'page_id: ' . $page_id };

	return {
		module => $module,
		sub => 'dispatch',
		page_id => $page_id
	};
}

=head3 prepare_dispatch_coderef

Load the module and prepare a coderef for dispatch

@param  arg_h   with keys
          module    - module to load
          sub       - function to execute

@return  $to_do  coderef to execute

=cut

sub prepare_dispatch_coderef {
	my $self = shift;
	my $arg_h = shift;

	my $module = $arg_h->{module} || $self->choke({ err => 'missing', subject => 'module' });
	my $sub = $arg_h->{sub} || $self->choke({ err => 'missing', subject => 'sub' });

	# initialise IMG session, dbhs, etc.
	IMG::Util::Factory::require_module( 'WebUtil' );

#	log_debug { 'Loaded WebUtil' };
	WebUtil::init_from_proportal( $self );

# 	my $errs;
# 	my $mods = $self->valid_modules;
# 	for my $m ( sort keys %$mods ) {
# 		local $@;
# 		log_debug { 'loading ' . $mods->{$m} };
# 		eval {
# 			IMG::Util::Factory::require_module( $mods->{$m} );
# 		};
# 		$errs->{$m} = $@ if $@;
# 	}
# 	if ( $errs ) {
# 		for ( sort keys %$errs ) {
# 			log_debug { $_ };
# 			log_debug { $errs->{$_} };
# 		}
# 	}

	my $override = Sub::Override->new;

	my $sub_h = {
		webError => sub {
	#		log_debug { 'running WebUtil::WebError' };
			confess $_[0];
		},
		webDie => sub {
	#		log_debug { 'running WebUtil::webDie' };
			confess $_[0];
		},
		webErrorHeader => sub {
	#		log_debug { 'running WebUtil::webErrorHeader' };
			return WebUtil::webError( @_ );
		},
		webExit => sub {
	#		log_debug { 'running WebUtil::webExit' };
			return;
		},
		webLog => sub {
			warn $_[0];
			return;
		},
		webErrLog => sub {
			carp $_[0];
			return;
		},
		loginLog => sub {
			warn $_[0];
			return;
		},
		getSessionParam => sub {
			return WebUtil::getSession()->read( @_ );
		},
		setSessionParam => sub {
			return WebUtil::getSession()->write( @_ );
		},
	};

# 	my $module = Test::MockModule->new('WebUtil');
# 	Module::Name::subroutine(@args); # mocked
# 	$mock->mock(foo => sub { print "Foo!\n"; });

	for my $sub ( keys %$sub_h ) {
		for my $prefix ( 'WebUtil' ) { #, 'WebPrint' ) {
			if ( $prefix ) {
				$override->replace( "$prefix::$sub", $sub_h->{$sub} );
			}
			else {
				$override->replace( $sub, $sub_h->{$sub} );
			}
		}
	}

	IMG::Util::Factory::require_module( $module );

	# make sure that we can run the sub:
	if ( ! $module->can( $sub ) ) {
		$self->choke({
			err => 'module_err',
			subject => $module,
			msg => "module does not have $sub implemented!"
		});
	}

	log_debug { 'Loaded ' . $module };


	my $to_do;
	if (! ref $sub ) {
		warn "Setting to_do to " . $module .'::' . $sub;
		$to_do = \&{ $module .'::' . $sub };
	}
	else {
		$to_do = $sub;
	}

	return $to_do;

}


sub coerce_section {
	my $req = shift;
#	return if $req->param('section');

	for my $k ( keys %{$req->params} ) {
		if ( $k =~ /^_section/ ) {
			$req->param( "section", ( split /_/, $k )[2] );
			last;
		}
	}
	return;
}


sub is_valid_module {
	my $m = shift;
	my $valid = valid_modules();
	return $valid->{$m} || 0;
}


sub valid_modules {

	return {
		ClusterScout                 => 'ClusterScout',
		WorkspaceBcSet               => 'WorkspaceBcSet',
		AbundanceProfileSearch       => 'AbundanceProfileSearch',
		GenomeList                   => 'GenomeList',
		ImgStatsOverview             => 'ImgStatsOverview',
		BiosyntheticDetail           => 'BiosyntheticDetail',
		GeneCassetteProfiler         => 'GeneCassetteProfiler',
		GenomeCart                   => 'GenomeCart',
		Caliban                      => 'Caliban',
		StudyViewer                  => 'StudyViewer',
		GeneCassette                 => 'GeneCassette',
		GeneCassetteSearch           => 'GeneCassetteSearch',
		ANI                          => 'ANI',
		ProjectId                    => 'ProjectId',
		TreeFile                     => 'TreeFile',
		ScaffoldSearch               => 'ScaffoldSearch',
		MeshTree                     => 'MeshTree',
		AbundanceProfiles            => 'AbundanceProfiles',
		AbundanceTest                => 'AbundanceTest',
		AbundanceComparisons         => 'AbundanceComparisons',
		AbundanceComparisonsSub      => 'AbundanceComparisonsSub',
		AbundanceToolkit             => 'AbundanceToolkit',
		Artemis                      => 'Artemis',
		np                           => 'NaturalProd',
		NaturalProd                  => 'NaturalProd',
		ClustalW                     => 'ClustalW',
		CogCategoryDetail            => 'CogCategoryDetail',
		CompareGenomes               => 'CompareGenomes',
		CompareGenomesTab            => 'CompareGenomes',
		GenomeGeneOrtholog           => 'GenomeGeneOrtholog',
		Pangenome                    => 'Pangenome',
		CompareGeneModelNeighborhood => 'CompareGeneModelNeighborhood',
		CuraCartStor                 => 'CuraCartStor',
		CuraCartDataEntry            => 'CuraCartDataEntry',
		DataEvolution                => 'DataEvolution',
		EbiIprScan                   => 'EbiIprScan',
		EgtCluster                   => 'EgtCluster',
		EmblFile                     => 'EmblFile',
		BcSearch                     => 'BcSearch',
		BiosyntheticStats            => 'BiosyntheticStats',
		BcNpIDSearch                 => 'BcNpIDSearch',
		ClusterScout                 => 'ClusterScout',
		FindFunctions                => 'FindFunctions',
		FindFunctionMERFS            => 'FindFunctionMERFS',
		FindGenes                    => 'FindGenes',
		FindGenesLucy                => 'FindGenesLucy',
		FindGenesBlast               => 'FindGenesBlast',
		FindGenomes                  => 'FindGenomes',
		FunctionAlignment            => 'FunctionAlignment',
		FuncCartStor                 => 'FuncCartStor',
		FuncCartStorTab              => 'FuncCartStor',
		FuncProfile                  => 'FuncProfile',
		FunctionProfiler             => 'FunctionProfiler',
		DotPlot                      => 'DotPlot',
		DistanceTree                 => 'DistanceTree',
		RadialPhyloTree              => 'RadialPhyloTree',
		Kmer                         => 'Kmer',
		GenBankFile                  => 'GenBankFile',
		GeneAnnotPager               => 'GeneAnnotPager',
		GeneCartChrViewer            => 'GeneCartChrViewer',
		GeneCartStor                 => 'GeneCartStor',
		GeneCartStorTab              => 'GeneCartStor',
		MyGeneDetail                 => 'MyGeneDetail',
		Help                         => 'Help',
		GeneDetail                   => 'GeneDetail',
		geneDetail                   => 'GeneDetail',
		MetaGeneDetail               => 'MetaGeneDetail',
		MetaGeneTable                => 'MetaGeneTable',
		GeneNeighborhood             => 'GeneNeighborhood',
		FindClosure                  => 'FindClosure',
		MetagPhyloDist               => 'MetagPhyloDist',
		Cart                         => 'Cart',
		HorizontalTransfer           => 'HorizontalTransfer',
		ImgTermStats                 => 'ImgTermStats',
		KoTermStats                  => 'KoTermStats',
		HmpTaxonList                 => 'HmpTaxonList',
		Interpro                     => 'Interpro',
		MetaCyc                      => 'MetaCyc',
		AnalysisProject              => 'AnalysisProject',
		GenePageEnvBlast             => 'GenePageEnvBlast',
		GeneProfilerStor             => 'GeneProfilerStor',
		GenomeProperty               => 'GenomeProperty',
		GreenGenesBlast              => 'GreenGenesBlast',
		HomologToolkit               => 'HomologToolkit',
		ImgCompound                  => 'ImgCompound',
		ImgCpdCartStor               => 'ImgCpdCartStor',
		ImgTermAndPathTab            => 'ImgTermAndPathTab',
		ImgNetworkBrowser            => 'ImgNetworkBrowser',
		ImgPwayBrowser               => 'ImgPwayBrowser',
		ImgPartsListBrowser          => 'ImgPartsListBrowser',
		ImgPartsListCartStor         => 'ImgPartsListCartStor',
		ImgPartsListDataEntry        => 'ImgPartsListDataEntry',
		ImgPwayCartDataEntry         => 'ImgPwayCartDataEntry',
		ImgPwayCartStor              => 'ImgPwayCartStor',
		ImgReaction                  => 'ImgReaction',
		ImgRxnCartStor               => 'ImgRxnCartStor',
		ImgTermBrowser               => 'ImgTermBrowser',
		ImgTermCartDataEntry         => 'ImgTermCartDataEntry',
		ImgTermCartStor              => 'ImgTermCartStor',
		KeggMap                      => 'KeggMap',
		KeggPathwayDetail            => 'KeggPathwayDetail',
		PathwayMaps                  => 'PathwayMaps',
		Metagenome                   => 'Metagenome',
		AllPwayBrowser               => 'AllPwayBrowser',
		MpwPwayBrowser               => 'MpwPwayBrowser',
		GenomeHits                   => 'GenomeHits',
		ScaffoldHits                 => 'ScaffoldHits',
		ScaffoldDetail               => 'ScaffoldDetail',
		MetaScaffoldDetail           => 'MetaScaffoldDetail',
		ScaffoldCart                 => 'ScaffoldCart',
		MetagenomeHits               => 'MetagenomeHits',
		MetaFileHits                 => 'MetaFileHits',
		MetagenomeGraph              => 'MetagenomeGraph',
		MetaFileGraph                => 'MetaFileGraph',
		MissingGenes                 => 'MissingGenes',
		MyFuncCat                    => 'MyFuncCat',
		MyIMG                        => 'MyIMG',
		ImgGroup                     => 'ImgGroup',
		Workspace                    => 'Workspace',
		WorkspaceGeneSet             => 'WorkspaceGeneSet',
		WorkspaceFuncSet             => 'WorkspaceFuncSet',
		WorkspaceGenomeSet           => 'WorkspaceGenomeSet',
		WorkspaceScafSet             => 'WorkspaceScafSet',
		WorkspaceRuleSet             => 'WorkspaceRuleSet',
		WorkspaceJob                 => 'WorkspaceJob',
		MyBins                       => 'MyBins',
		About                        => 'About',
		NcbiBlast                    => 'NcbiBlast',
		NrHits                       => 'NrHits',
		Operon                       => 'Operon',
		OtfBlast                     => 'OtfBlast',
		PepStats                     => 'PepStats',
		PfamCategoryDetail           => 'PfamCategoryDetail',
		PhyloCogs                    => 'PhyloCogs',
		PhyloDist                    => 'PhyloDist',
		PhyloOccur                   => 'PhyloOccur',
		PhyloProfile                 => 'PhyloProfile',
		PhyloSim                     => 'PhyloSim',
		PhyloClusterProfiler         => 'PhyloClusterProfiler',
		PhylogenProfiler             => 'PhylogenProfiler',
		ProteinCluster               => 'ProteinCluster',
		ProfileQuery                 => 'ProfileQuery',
		PdbBlast                     => 'PdbBlast',
		SixPack                      => 'SixPack',
		Sequence                     => 'Sequence',
		ScaffoldGraph                => 'ScaffoldGraph',
		MetaScaffoldGraph            => 'MetaScaffoldGraph',
		TaxonCircMaps                => 'TaxonCircMaps',
		GenerateArtemisFile          => 'GenerateArtemisFile',
		TaxonDetail                  => 'TaxonDetail',
		TaxonDeleted                 => 'TaxonDeleted',
		MetaDetail                   => 'MetaDetail',
		TaxonList                    => 'TaxonList',
		TaxonSearch                  => 'TaxonSearch',
		TigrBrowser                  => 'TigrBrowser',
		TreeQ                        => 'TreeQ',
		Vista                        => 'Vista',
		IMGContent                   => 'IMGContent',
		IMGProteins                  => 'IMGProteins',
		Methylomics                  => 'Methylomics',
		RNAStudies                   => 'RNAStudies',
		Questions                    => 'Questions',
		Messages                     => 'Messages',
		znormNote                    => 'Messages',
		CogDetail                    => 'CogDetail',
		Viral                        => 'Viral',
		GeneInfoPager                => 'GeneInfoPager',
		Export                       => 'Export',
		WorkspacePublicSet           => 'WorkspacePublicSet',
	};
}

1;

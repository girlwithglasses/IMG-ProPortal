############################################################################
#	IMG::App::Role::Dispatcher.pm
#
#	Parse query params and run the appropriate code
#
#	$Id: Dispatcher.pm 36523 2017-01-26 17:53:41Z aireland $
############################################################################
package IMG::App::Role::Dispatcher;

use IMG::Util::Import 'MooRole';
use IMG::App::DispatchCore;

my %valid_sections =


sub prepare_to_parse {
	my $dsl = shift;
	my $req = shift;
	my $app = $dsl->app;
	my $prep_args = parse_params( $app, $req );

	return $prep_args;
}

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

	my $dsl = shift;
	my $req = shift;
	my $app = $dsl->app;

	my $prep_args = parse_params( $app, $req );

	my $sub_to_run = IMG::App::DispatchCore::prepare_dispatch_coderef( $prep_args ) unless defined $prep_args->{sub_to_run} && 'CODE' eq ref $prep_args->{sub_to_run};

	return { %$prep_args, sub_to_run => $sub_to_run || $prep_args->{sub_to_run} };

};

=head3 parse_params

Parse the input query params and find the appropriate module, subroutine,
template, and template arguments to use.

@return hashref with keys

		sub    - subroutine to run
		module - module to load
		tmpl   - outer page template to use (defaults to 'default')
		tmpl_args  - template arguments

=cut

sub parse_params {

	my $self = shift;
	my $req = shift;
#	my $self = $dsl->app;

	my $module;           # the module to load
	my %tmpl_args;        # arguments for populating page templates
	my $sub = 'dispatch'; # subroutine to run (if not dispatch)
	my $tmpl = 'default'; # which template to use for the page
	my $hdrs;             # page headers to set
	my $code_ref;         # directly set the code ref to be run

#	say 'request: ' . Dumper $req;

	my $page = $req->params->{page} || "";
	my $section = $req->params->{section};

	say "page: $page; section: $section";


=cut
		# this should all be dealt with by Caliban!
        elsif ( ( $self->config->{public_login} || $self->config->{user_restricted_site} ) && $cgi->param("logout") ) {

            #        if ( !$oldLogin && $self->config->{sso_enabled} ) {
            #
            #            # do no login log here
            #        } else {
            #            WebUtil::loginLog( 'logout main.pl', 'img' );
            #        }

            $self->session->write( "blank_taxon_filter_oid_str", "1" );
            $self->session->write( "oldLogin",                   0 );
            setTaxonSelections("");
            print_app_header( current => "logout" );

            print "<div id='message'>\n";
            print "<p>\n";
            print "Logged out.\n";
            print "</p>\n";
            print "</div>\n";
            print qq{
				<p>
				<a href='main.cgi'>Sign in</a>
				</p>
			};

            # sso
            if ( ! $self->config->{oldLogin} && $self->config->{sso_enabled} ) {
                $module = 'Caliban';
                $sub = sub {
                	$module::sso_logout;
                };
#                Caliban::logout(1);
            }
            else {
                $module = 'Caliban';
                $sub = sub {
                	$module::logout;
                };
#                Caliban::logout();
            }
        }
    }
    else {
        my $rurl = $cgi->param("redirect");
        if ( ( $self->config->{public_login} || $self->config->{user_restricted_site} ) && $rurl ) {
            redirecturl($rurl);
        }
        else {
            $self->config->{homePage} = 1;
            %tmpl_args = ( current => "Home" );
        }
    }
=cut

	else {
		# render the main page instead
		$self->config->{homePage} = 1;
		%tmpl_args = ( current => 'Home' );
	}

	warn "Returning from prepare with args sub: $sub, module: $module, tmpl: $tmpl";

#	$self->set_tmpl_args( \%tmpl_args );
    my $page_id = ( defined $page && lc( $page ) ne 'home')
        ? $module . '/' . $page
        : $module;
    say 'page_id: ' . $page_id;

	return {
	    page_id   => $page_id,
		sub       => $sub,
		module    => $module,
		tmpl_args => \%tmpl_args,
		tmpl       => $tmpl,
		headers    => $hdrs,
		sub_to_run => $code_ref,
	};

}

=head3 prepare_dispatch_coderef

Load the module and prepare a coderef for dispatch

@param  arg_h   with keys
          module    - module to load
          sub       - function to execute

@return  $to_do  coderef to execute

sub prepare_dispatch_coderef {
	my $arg_h = shift;

	my $module = $arg_h->{module} || croak "No module defined!";
	my $sub = $arg_h->{sub} || croak "No sub defined!";

	my ($ok, $err) = try_load_class( $module );
	$ok or croak "Unable to load class " . $module . ": $err";

	# make sure that we can run the sub:
	if ( ! $module->can( $sub ) ) {
		croak "$module does not have $sub implemented!";
	}

#	warn "Loaded module OK!";

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
=cut


sub paramMatch {

	my $req = shift;
	my $p = shift;

	carp "running paramMatch: p: $p";

	for my $k ( keys %{$req->params} ) {
		return $k if $k =~ /$p/;
	}
	return undef;

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

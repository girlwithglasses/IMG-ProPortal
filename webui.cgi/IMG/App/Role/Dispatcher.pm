############################################################################
#	IMG::App::Role::Dispatcher.pm
#
#	Parse query params and run the appropriate code
#
#	$Id: Dispatcher.pm 35833 2016-07-06 02:42:03Z aireland $
############################################################################
package IMG::App::Role::Dispatcher;

use IMG::Util::Base 'MooRole';
use IMG::App::DispatchCore;

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

#	getPageTitle
#	getAppHeaderData

	my $section_table = {
	  ANI => sub {
		  %tmpl_args = ( title => 'ANI', current => 'CompareGenomes');
		  if ($page eq 'pairwise') {
			  $tmpl_args{'yui_js'} = 'genomeHeaderJson';
		  }
		  elsif ($page eq 'overview') {
			  $tmpl_args{'yui_js'} = 'meshTreeHeader';
		  }
		  elsif ($page eq 'home') {
				$module = 'ANI::Home';
			}
	  },
	  About => sub {
		  %tmpl_args = ( title => 'About', current => 'about');
	  },
	  AbundanceComparisons => sub {
		  %tmpl_args = ( title => 'Abundance Comparisons', current => 'CompareGenomes', yui_js => 'genomeHeaderJson');
		  $tmpl_args{'help'} = 'userGuide_m.pdf#page=20' if $self->config->{'include_metagenomes'};
	  },
	  AbundanceComparisonsSub => sub {
		  %tmpl_args = ( title => 'Function Category Comparisons', current => 'CompareGenomes', yui_js => 'genomeHeaderJson');
		  $tmpl_args{'help'} = 'userGuide_m.pdf#page=23' if $self->config->{'include_metagenomes'};
	  },
	  AbundanceProfileSearch => sub {
		  %tmpl_args = ( title => 'Abundance Profile Search', current => 'CompareGenomes', scripts => 'genomeHeaderJson', help => 'userGuide_m.pdf#page=');
		  $tmpl_args{'help'} .= $self->config->{'include_metagenomes'} ? '19' : '51';
	  },
	  AbundanceProfiles => sub {
		  %tmpl_args = ( title => 'Abundance Profiles', current => 'CompareGenomes', yui_js => 'genomeHeaderJson', help => 'userGuide_m.pdf#page=');
		  $tmpl_args{'help'} .= $self->config->{'include_metagenomes'} ? '18' : '49';
	  },
	  AbundanceTest => sub {
		  %tmpl_args = ( title => 'Abundance Test', current => 'CompareGenomes');
	  },
	  AbundanceToolkit => sub {
		  %tmpl_args = ( title => 'Abundance Toolkit', current => 'CompareGenomes');
	  },
	  AllPwayBrowser => sub {
		  %tmpl_args = ( title => 'All Pathways', current => 'FindFunctions');
	  },
	  AnalysisProject => sub {
		  %tmpl_args = ( title => 'Analysis Project', current => 'FindGenomes');
	  },
	  Artemis => sub {
		  %tmpl_args = ( title => 'Artemis', current => 'FindGenomes', yui_js => 'genomeHeaderJson');
		  my $from = $req->params->{'from'} // '';
		  if ($from eq 'ACT' or $page =~ /^ACT/ or $page =~ /ACT$/) {
			  $tmpl_args{'current'} = 'CompareGenomes';
		  }
	  },
	  BcNpIDSearch => sub {
		  %tmpl_args = ( title => 'Biosynthetic Cluster / Secondary Metabolite Search by ID', current => 'getsme');
	  },
	  BcSearch => sub {
		  %tmpl_args = ( title => 'Biosynthetic Cluster Search', current => 'getsme', yui_js => 'meshTreeHeader');
		  $tmpl_args{'title'} = 'Secondary Metabolite Search' if $page eq 'npSearches' or $page eq 'npSearchResult';
	  },
	  BiosyntheticDetail => sub {
		  %tmpl_args = ( title => 'Biosynthetic Cluster', current => 'getsme');
	  },
	  BiosyntheticStats => sub {
		  %tmpl_args = ( title => 'Biosynthetic Cluster Statistics', current => 'getsme', yui_js => 'meshTreeHeader');
	  },
	  Caliban => sub {
		  return;
	  },
	  Cart => sub {
		  %tmpl_args = ( title => 'My Cart', current => 'AnaCart');
	  },
	  ClustalW => sub {
		  %tmpl_args = ( title => 'Clustal - Multiple Sequence Alignment', current => 'AnaCart', help => 'DistanceTree.pdf#page=6');
	  },
	  CogCategoryDetail => sub {
		  %tmpl_args = ( title => 'COG', current => 'FindFunctions');
		  $tmpl_args{'title'} = 'KOG' if $page =~ /kog/i;
	  },
	  CompTaxonStats => sub {
		  %tmpl_args = ( title => 'Genome Statistics', current => 'CompareGenomes');
	  },
	  CompareGeneModelNeighborhood => sub {
		  %tmpl_args = ( title => 'Compare Gene Models', current => 'CompareGenomes');
	  },
	  CompareGenomes => sub {
		  if (paramMatch($req, '_excel')) {
			  $tmpl = 'excel';
			  $hdrs = sub {
				  return IMG::Views::ViewMaker::print_excel_header("stats_export$$.xls");
			  };
			  %tmpl_args = ( filename => "stats_export$$.xls" );
		  }
		  else {
			  %tmpl_args = ( title => 'Compare Genomes', current => 'CompareGenomes');
		  }
	  },
	  CuraCartDataEntry => sub {
		  %tmpl_args = ( title => 'Curation Cart Data Entry', current => 'AnaCart');
		  $self->session->write('lastCart', 'curaCart');
	  },
	  CuraCartStor => sub {
		  %tmpl_args = ( title => 'Curation Cart', current => 'AnaCart');
		  $self->session->write('lastCart', 'curaCart');
	  },
	  DataEvolution => sub {
		  %tmpl_args = ( title => 'Data Evolution', current => 'news');
	  },
	  DistanceTree => sub {
		  %tmpl_args = ( title => 'Distance Tree', current => 'CompareGenomes', yui_js => 'genomeHeaderJson', help => 'DistanceTree.pdf');
	  },
	  DotPlot => sub {
		  %tmpl_args = ( title => 'Dotplot', current => 'CompareGenomes', yui_js => 'genomeHeaderJson', help => 'Dotplot.pdf');
	  },
	  EggNog => sub {
		  %tmpl_args = ( title => 'EggNOG', current => 'FindFunctions');
	  },
	  EgtCluster => sub {
		  %tmpl_args = ( title => 'Genome Clustering', current => 'CompareGenomes', yui_js => 'genomeHeaderJson');
		  $tmpl_args{'help'} = 'DistanceTree.pdf#page=5' if defined $req->params->{'method'} and $req->params->{'method'} eq 'hier';
	  },
	  EmblFile => sub {
		  %tmpl_args = ( title => 'EMBL File Export', current => 'FindGenomes');
	  },
	  Fastbit => sub {
		  %tmpl_args = ( title => 'Fastbit Test', current => 'FindFunctions', yui_js => 'genomeHeaderJson');
	  },
	  FindClosure => sub {
		  %tmpl_args = ( title => 'Functional Closure', current => 'AnaCart');
	  },
	  FindFunctionMERFS => sub {
		  %tmpl_args = ( title => 'Find Functions', current => 'FindFunctions');
	  },
	  FindFunctions => sub {
		  %tmpl_args = ( title => 'Find Functions', current => 'FindFunctions', yui_js => 'genomeHeaderJson');
		  if ($page eq 'findFunctions') {
			  $tmpl_args{'help'} = 'FunctionSearch.pdf';
		  }
		  elsif ($page eq 'ffoAllSeed') {
			  $tmpl_args{'help'} = 'SEED.pdf';
		  }
		  elsif ($page eq 'ffoAllTc') {
			  $tmpl_args{'help'} = 'TransporterClassification.pdf';
		  }
	  },
	  FindGenes => sub {
		  %tmpl_args = ( title => 'Find Genes', current => 'FindGenes', yui_js => 'genomeHeaderJson');
		  if ($page eq 'findGenes' or $page eq 'geneSearch' or $page ne 'geneSearchForm' and not paramMatch($req, 'fgFindGenes')) {
			  $tmpl_args{'help'} = 'GeneSearch.pdf';
		  }
	  },
	  FindGenesBlast => sub {
		  %tmpl_args = ( title => 'Find Genes - BLAST', current => 'FindGenes', yui_js => 'genomeHeaderJson', help => 'Blast.pdf');
	  },
	  FindGenesLucy => sub {
		  %tmpl_args = ( title => 'Find Genes by Keyword', current => 'FindGenesLucy', help => 'GeneSearch.pdf');
	  },
	  FindGenomes => sub {
		  %tmpl_args = (current => 'FindGenomes', title => 'Find Genomes');
		  if ($page eq 'findGenomes') {
			  $tmpl_args{'help'} = 'GenomeBrowser.pdf';
		  }
		  elsif ($page eq 'genomeSearch') {
			  $tmpl_args{'help'} = 'GenomeSearch.pdf';
		  }
	  },
	  FuncCartStor => sub {
		  %tmpl_args = (current => 'AnaCart', help => 'FunctionCart.pdf', title => 'Function Cart');
		  $tmpl_args{'title'} = 'Assertion Profile' if paramMatch($req, 'AssertionProfile');
		  if ($page eq 'funcCart' and $self->config->{'enable_genomelistJson'}) {
			  $tmpl_args{'help'} = GenomeListJSON();
		  }
		  $self->session->write('lastCart', 'funcCart');
	  },
	  FuncProfile => sub {
		  %tmpl_args = ( title => 'Function Profile', current => 'AnaCart');
	  },
	  FunctionAlignment => sub {
		  %tmpl_args = ( title => 'Function Alignment', current => 'FindFunctions', help => 'FunctionAlignment.pdf');
	  },
	  FunctionProfiler => sub {
		  %tmpl_args = ( title => 'Function Profile', current => 'CompareGenomes', yui_js => 'genomeHeaderJson');
	  },
	  GenBankFile => sub {
		  %tmpl_args = ( title => 'GenBank File Export', current => 'FindGenomes');
	  },
	  GeneAnnotPager => sub {
		  %tmpl_args = ( title => 'Comparative Annotations', current => 'FindGenomes');
	  },
	  GeneCartChrViewer => sub {
		  %tmpl_args = ( title => 'Circular Chromosome Viewer', current => 'AnaCart');
		  $self->session->write('lastCart', 'geneCart');
	  },
	  GeneCartDataEntry => sub {
		  %tmpl_args = ( title => 'Gene Cart Data Entry', current => 'AnaCart');
		  $self->session->write('lastCart', 'geneCart');
	  },
	  GeneCartStor => sub {
		  %tmpl_args = (current => 'AnaCart', title => 'Gene Cart');
		  my $last_cart = paramMatch($req, 'addFunctionCart') ? 'funcCart' : 'geneCart';
		  $self->session->write('lastCart', $last_cart);
		  if ($page eq 'geneCart') {
			  $tmpl_args{'help'} = 'GeneCart.pdf';
			  $tmpl_args{'yui_js'} = 'genomeHeaderJson' if $self->config->{'enable_genomelistJson'};
		  }
	  },
	  GeneCassette => sub {
		  %tmpl_args = ( title => 'IMG Cassette', current => 'CompareGenomes');
	  },
	  GeneCassetteProfiler => sub {
		  %tmpl_args = ( title => 'Phylogenetic Profiler', current => 'FindGenes', yui_js => 'genomeHeaderJson');
	  },
	  GeneCassetteSearch => sub {
		  %tmpl_args = ( title => 'IMG Cassette Search', current => 'FindGenes', yui_js => 'genomeHeaderJson');
	  },
	  GeneDetail => sub {
		  %tmpl_args = ( title => 'Gene Details', current => 'FindGenes');
	  },
	  GeneInfoPager => sub {
		  %tmpl_args = ( title => 'Download Gene Information', current => 'FindGenomes');
	  },
	  GeneNeighborhood => sub {
		  %tmpl_args = ( title => 'Gene Neighborhood', current => 'FindGenes');
	  },
	  GenePageEnvBlast => sub {
		  %tmpl_args = ( title => 'SNP BLAST');
	  },
	  GeneProfilerStor => sub {
		  %tmpl_args = ( title => 'Gene Profiler', current => 'AnaCart');
		  $self->session->write('lastCart', 'geneCart');
	  },
	  GenerateArtemisFile => sub {
		  %tmpl_args = (current => 'FindGenomes');
	  },
	  GenomeCart => sub {
		  %tmpl_args = ( title => 'Genome Cart', current => 'AnaCart');
		  $self->session->write('lastCart', 'genomeCart');
	  },
	  GenomeGeneOrtholog => sub {
		  %tmpl_args = ( title => 'Genome Gene Ortholog', current => 'CompareGenomes', yui_js => 'genomeHeaderJson');
	  },
	  GenomeHits => sub {
		  %tmpl_args = ( title => 'Genome Hits', current => 'CompareGenomes', yui_js => 'genomeHeaderJson');
	  },
	  GenomeList => sub {
		  %tmpl_args = ( title => 'Genome List', current => 'FindGenomes');
	  },
	  GenomeListJSON => sub {
		  %tmpl_args = (current => 'AnaCart', yui_js => 'genomeHeaderJson');
		  $module = 'GenomeListJSON';
		  $sub = 'test';
	  },
	  GenomeProperty => sub {
		  %tmpl_args = ( title => 'Genome Property');
	  },
	  Help => sub {
		  %tmpl_args = ( title => help => current => 'about');
	  },
	  HmpTaxonList => sub {
		  %tmpl_args = ( title => 'HMP Genome List', current => 'FindGenomes');
		  if (paramMatch($req, '_excel')) {
			  $tmpl = 'excel';
			  %tmpl_args = (filename => "genome_export$$.xls");
			  $hdrs = sub {
				  return IMG::Views::ViewMaker::print_excel_header("genome_export$$.xls");
			  };
		  }
	  },
	  HomologToolkit => sub {
		  %tmpl_args = ( title => 'Homolog Toolkit', current => 'FindGenes');
	  },
	  HorizontalTransfer => sub {
		  %tmpl_args = ( title => 'Horizontal Transfer', current => 'FindGenomes');
	  },
	  IMGContent => sub {
		  %tmpl_args = ( title => 'IMG Content', current => 'IMGContent');
	  },
	  IMGProteins => sub {
		  %tmpl_args = ( title => 'Proteomics', current => 'Proteomics', help => 'Proteomics.pdf');
	  },
	  ImgCompound => sub {
		  %tmpl_args = ( title => 'IMG Compound', current => 'FindFunctions', yui_js => 'meshTreeHeader');
	  },
	  ImgCpdCartStor => sub {
		  %tmpl_args = ( title => 'IMG Compound Cart', current => 'AnaCart');
		  $self->session->write('lastCart', 'imgCpdCart');
	  },
	  ImgGroup => sub {
		  %tmpl_args = ( title => 'MyIMG', current => 'MyIMG');
	  },
	  ImgNetworkBrowser => sub {
		  %tmpl_args = ( title => 'IMG Network Browser', current => 'FindFunctions', help => 'imgterms.html');
	  },
	  ImgPartsListBrowser => sub {
		  %tmpl_args = ( title => 'IMG Parts List Browser', current => 'FindFunctions');
	  },
	  ImgPartsListCartStor => sub {
		  %tmpl_args = ( title => 'IMG Parts List Cart', current => 'AnaCart');
		  $self->session->write('lastCart', 'imgPartsListCart');
	  },
	  ImgPartsListDataEntry => sub {
		  %tmpl_args = ( title => 'IMG Parts List Data Entry', current => 'AnaCart');
		  $self->session->write('lastCart', 'imgPartsListCart');
	  },
	  ImgPwayBrowser => sub {
		  %tmpl_args = ( title => 'IMG Pathway Browser', current => 'FindFunctions');
	  },
	  ImgPwayCartDataEntry => sub {
		  %tmpl_args = ( title => 'IMG Pathway Cart Data Entry', current => 'AnaCart');
		  $self->session->write('lastCart', 'imgPwayCart');
	  },
	  ImgPwayCartStor => sub {
		  %tmpl_args = ( title => 'IMG Pathway Cart', current => 'AnaCart');
		  $self->session->write('lastCart', 'imgPwayCart');
	  },
	  ImgReaction => sub {
		  %tmpl_args = ( title => 'IMG Reaction', current => 'FindFunctions');
	  },
	  ImgRxnCartStor => sub {
		  %tmpl_args = ( title => 'IMG Reaction Cart', current => 'AnaCart');
		  $self->session->write('lastCart', 'imgRxnCart');
	  },
	  ImgStatsOverview => sub {
		  %tmpl_args = ( title => 'IMG Stats Overview', current => 'ImgStatsOverview');
		  if ($req->params->{'excel'} and 'yes' eq $req->params->{'excel'}) {
			  $tmpl = 'excel';
			  %tmpl_args = ( filename => "stats_export$$.xls" );
			  $hdrs = sub {
				  return IMG::Views::ViewMaker::print_excel_header("stats_export$$.xls");
			  };
		  }
	  },
	  ImgTermAndPathTab => sub {
		  %tmpl_args = ( title => 'IMG Terms and Pathways', current => 'FindFunctions');
	  },
	  ImgTermBrowser => sub {
		  %tmpl_args = ( title => 'IMG Term Browser', current => 'FindFunctions');
	  },
	  ImgTermCartDataEntry => sub {
		  %tmpl_args = ( title => 'IMG Term Cart Data Entry', current => 'AnaCart');
		  $self->session->write('lastCart', 'imgTermCart');
	  },
	  ImgTermCartStor => sub {
		  %tmpl_args = ( title => 'IMG Term Cart', current => 'AnaCart');
		  $self->session->write('lastCart', 'imgTermCart');
	  },
	  ImgTermStats => sub {
		  %tmpl_args = ( title => 'IMG Term', current => 'FindFunctions');
	  },
	  Interpro => sub {
		  %tmpl_args = ( title => 'Interpro', current => 'FindFunctions');
	  },
	  KeggMap => sub {
		  %tmpl_args = ( title => 'KEGG Map', current => 'FindFunctions');
	  },
	  KeggPathwayDetail => sub {
		  %tmpl_args = ( title => 'KEGG Pathway Detail', current => 'FindFunctions', yui_js => 'genomeHeaderJson');
	  },
	  Kmer => sub {
		  %tmpl_args = ( title => 'Kmer Frequency Analysis', current => 'FindGenomes') if not paramMatch($req, 'export');
	  },
	  KoTermStats => sub {
		  %tmpl_args = ( title => 'KO Stats', current => 'FindFunctions');
	  },
	  MeshTree => sub {
		  %tmpl_args = ( title => 'Mesh Tree', current => 'FindFunctions', yui_js => 'meshTreeHeader');
	  },
	  MetaCyc => sub {
		  %tmpl_args = ( title => 'MetaCyc', current => 'FindFunctions');
	  },
	  MetaDetail => sub {
		  %tmpl_args = ( title => 'Microbiome Details', current => 'FindGenomes');
		  $tmpl_args{'help'} = 'GenerateGenBankFile.pdf' if $page eq 'taxonArtemisForm';
	  },
	  MetaFileGraph => sub {
		  %tmpl_args = ( title => 'Metagenome Graph', current => 'FindGenomes');
	  },
	  MetaFileHits => sub {
		  %tmpl_args = ( title => 'Metagenome Hits', current => 'FindGenomes');
	  },
	  MetaGeneDetail => sub {
		  %tmpl_args = ( title => 'Metagenome Gene Details', current => 'FindGenes');
	  },
	  MetaGeneTable => sub {
		  %tmpl_args = ( title => 'Gene List', current => 'FindGenes');
	  },
	  MetaScaffoldGraph => sub {
		  %tmpl_args = ( title => 'Chromosome Viewer', current => 'FindGenomes');
	  },
	  MetagPhyloDist => sub {
		  %tmpl_args = ( title => 'Phylogenetic Distribution', current => 'CompareGenomes', yui_js => 'genomeHeaderJson');
	  },
	  Metagenome => sub {
		  %tmpl_args = ( title => 'Metagenome', current => 'FindGenomes');
	  },
	  MetagenomeGraph => sub {
		  %tmpl_args = ( title => 'Genome Graph', current => 'FindGenomes');
	  },
	  MetagenomeHits => sub {
		  %tmpl_args = ( title => 'Genome Hits', current => 'FindGenomes');
	  },
	  Methylomics => sub {
		  %tmpl_args = ( title => 'Methylomics Experiments', current => 'Methylomics', help => 'Methylomics.pdf');
	  },
	  MissingGenes => sub {
		  %tmpl_args = ( title => 'MissingGenes', current => 'AnaCart');
	  },
	  MpwPwayBrowser => sub {
		  %tmpl_args = ( title => 'Mpw Pathway Browser', current => 'FindFunctions');
	  },
	  MyBins => sub {
		  %tmpl_args = ( title => 'My Bins', current => 'MyIMG');
	  },
	  MyFuncCat => sub {
		  %tmpl_args = ( title => 'My Functional Categories', current => 'AnaCart');
	  },
	  MyGeneDetail => sub {
		  %tmpl_args = ( title => 'My Gene Detail', current => 'FindGenes');
	  },
	  MyIMG => sub {
		  %tmpl_args = ( title => 'My IMG', current => 'MyIMG', help => 'MyIMG4.pdf');
		  if ($page eq 'taxonUploadForm') {
			  delete $tmpl_args{'help'};
			  $tmpl_args{'current'} = 'AnaCart';
		  }
	  },
	  NaturalProd => sub {
		  %tmpl_args = ( title => 'Secondary Metabolite Statistics', current => 'getsme', yui_js => 'meshTreeHeader');
	  },
	  NcbiBlast => sub {
		  %tmpl_args = ( title => 'NCBI BLAST', current => 'FindGenes');
	  },
	  NrHits => sub {
		  %tmpl_args = ( title => 'Gene Details');
	  },
	  Operon => sub {
		  %tmpl_args = ( title => 'Operons', current => 'FindGenes');
	  },
	  OtfBlast => sub {
		  %tmpl_args = ( title => 'Gene Details', current => 'FindGenes', yui_js => 'genomeHeaderJson');
	  },
	  Pangenome => sub {
		  if (paramMatch($req, '_excel')) {
			  $tmpl = 'excel';
			  %tmpl_args = (filename => "stats_export$$.xls");
			  $hdrs = sub {
				  return IMG::Views::ViewMaker::print_excel_header("stats_export$$.xls");
			  };
		  }
		  else {
			  %tmpl_args = ( title => 'Pangenome', current => 'Pangenome');
		  }
	  },
	  PathwayMaps => sub {
		  %tmpl_args = ( title => 'Pathway Maps', current => 'PathwayMaps');
	  },
	  PepStats => sub {
		  %tmpl_args = ( title => 'Peptide Stats', current => 'FindGenes');
	  },
	  PfamCategoryDetail => sub {
		  %tmpl_args = ( title => 'Pfam Category', current => 'FindFunctions');
	  },
	  PhyloClusterProfiler => sub {
		  %tmpl_args = ( title => 'Phylogenetic Profiler using Clusters', current => 'FindGenes');
	  },
	  PhyloCogs => sub {
		  %tmpl_args = ( title => 'Phylogenetic Marker COGs', current => 'CompareGenomes');
	  },
	  PhyloDist => sub {
		  %tmpl_args = ( title => 'Phylogenetic Distribution', current => 'FindGenes');
	  },
	  PhyloOccur => sub {
		  %tmpl_args = ( title => 'Phylogenetic Occurrence Profile', current => 'AnaCart');
	  },
	  PhyloProfile => sub {
		  %tmpl_args = ( title => 'Phylogenetic Profile', current => 'AnaCart');
	  },
	  PhyloSim => sub {
		  %tmpl_args = ( title => 'Phylogenetic Similarity Search', current => 'FindGenes');
	  },
	  PhylogenProfiler => sub {
		  %tmpl_args = ( title => 'Phylogenetic Profiler', current => 'FindGenes', yui_js => 'genomeHeaderJson');
	  },




	  Portal => sub {
		  %tmpl_args = (current => 'FindGenomes');
	  },





	  ProfileQuery => sub {
		  %tmpl_args = ( title => 'Profile Query', current => 'FindFunctions');
	  },
	  ProjectId => sub {
		  %tmpl_args = ( title => 'Project ID List', current => 'FindGenomes');
	  },
	  ProteinCluster => sub {
		  %tmpl_args = ( title => 'Protein Cluster', current => 'FindGenes');
	  },
	  Questions => sub {
		  %tmpl_args = ( title => 'Questions and Comments', current => 'about');
	  },
	  RNAStudies => sub {
		  %tmpl_args = ( title => 'RNASeq Expression Studies', current => 'RNAStudies', help => 'RNAStudies.pdf');
		  if (paramMatch($req, 'samplePathways')) {
			  $tmpl_args{'title'} = 'RNASeq Studies: Pathways';
		  }
		  elsif (paramMatch($req, 'describeSamples')) {
			  $tmpl_args{'title'} = 'RNASeq Studies: Describe';
		  }
	  },
	  RadialPhyloTree => sub {
		  %tmpl_args = ( title => 'Radial Phylogenetic Tree', current => 'CompareGenomes', yui_js => 'genomeHeaderJson');
	  },
	  Registration => sub {
		  %tmpl_args = ( title => 'Registration', current => 'MyIMG');
	  },
	  ScaffoldCart => sub {
		  %tmpl_args = ( title => 'Scaffold Cart', current => 'AnaCart');
		  if (paramMatch($req, 'exportScaffoldCart') or paramMatch($req, 'exportFasta')) {
			  $self->session->write('lastCart', 'scaffoldCart');
		  }
		  elsif (not paramMatch($req, 'addSelectedToGeneCart')) {
			  $self->session->write('lastCart', 'scaffoldCart');
		  }
	  },
	  ScaffoldGraph => sub {
		  %tmpl_args = ( title => 'Chromosome Viewer', current => 'FindGenomes');
	  },
	  ScaffoldHits => sub {
		  %tmpl_args = ( title => 'Scaffold Hits', current => 'AnaCart');
	  },
	  ScaffoldSearch => sub {
		  %tmpl_args = ( title => 'Scaffold Search', current => 'FindGenomes', yui_js => 'genomeHeaderJson');
	  },
	  Sequence => sub {
		  %tmpl_args = ( title => 'Six Frame Translation', current => 'FindGenes');
	  },
	  SixPack => sub {
		  %tmpl_args = ( title => 'Six Frame Translation', current => 'FindGenes');
	  },
	  StudyViewer => sub {
		  %tmpl_args = ( title => 'Metagenome Study Viewer', current => 'FindGenomes', scripts => 'treeview.tt', styles => 'treeview.tt');
	  },
	  TaxonCircMaps => sub {
		  %tmpl_args = ( title => 'Circular Map', current => 'FindGenomes');
	  },
	  TaxonDeleted => sub {
		  %tmpl_args = ( title => 'Taxon Deleted', current => 'FindGenomes');
	  },
	  TaxonDetail => sub {
		  %tmpl_args = ( title => 'Taxon Details', current => 'FindGenomes');
		  $tmpl_args{'help'} = 'GenerateGenBankFile.pdf' if $page eq 'taxonArtemisForm';
	  },
	  TaxonEdit => sub {
		  %tmpl_args = ( title => 'Taxon Edit', current => 'Taxon Edit');
	  },
	  TaxonList => sub {
		  %tmpl_args = ( title => 'Taxon Browser', current => 'FindGenomes');
		  $tmpl_args{'title'} = 'Category Browser' if $page eq 'categoryBrowser';
		  if (paramMatch($req, '_excel')) {
			  $tmpl = 'excel';
			  %tmpl_args = (filename => "genome_export$$.xls");
			  $hdrs = sub {
				  return IMG::Views::ViewMaker::print_excel_header("genome_export$$.xls");
			  };
		  }
		  elsif ($page eq 'taxonListAlpha' or $page eq 'gebaList' or $page eq 'selected') {
			  $tmpl_args{'help'} = 'GenomeBrowser.pdf';
		  }
	  },
	  TaxonSearch => sub {
		  %tmpl_args = ( title => 'Taxon Search', current => 'FindGenomes');
	  },
	  TigrBrowser => sub {
		  %tmpl_args = ( title => 'TIGRfam Browser', current => 'FindFunctions');
	  },
	  TreeFile => sub {
		  %tmpl_args = ( title => 'IMG Tree', current => 'FindGenomes');
	  },
	  TreeQ => sub {
		  %tmpl_args = ( title => 'Dynamic Tree View');
	  },
	  Vista => sub {
		  %tmpl_args = ( title => 'VISTA', current => 'CompareGenomes');
		  $tmpl_args{'title'} = 'Synteny Viewers' if $page eq 'toppage';
	  },
	  Workspace => sub {
		  %tmpl_args = ( title => 'Workspace', current => 'MyIMG', help => 'IMGWorkspaceUserGuide.pdf', yui_js => 'workspaceStyles');
	  },
	  WorkspaceFuncSet => sub {
		  %tmpl_args = ( title => 'Workspace Function Sets', current => 'MyIMG', help => 'IMGWorkspaceUserGuide.pdf', yui_js => 'workspaceStyles');
	  },
	  WorkspaceGeneSet => sub {
		  %tmpl_args = ( title => 'Workspace Gene Sets', current => 'MyIMG', help => 'IMGWorkspaceUserGuide.pdf', yui_js => 'workspaceStyles');
	  },
	  WorkspaceGenomeSet => sub {
		  %tmpl_args = ( title => 'Workspace Genome Sets', current => 'MyIMG', help => 'IMGWorkspaceUserGuide.pdf', yui_js => 'workspaceStyles');
	  },
	  WorkspaceJob => sub {
		  %tmpl_args = ( title => 'Workspace Jobs', current => 'MyIMG', help => 'IMGWorkspaceUserGuide.pdf');
	  },
	  WorkspaceRuleSet => sub {
		  %tmpl_args = ( title => 'Workspace Rule Sets', current => 'MyIMG', help => 'IMGWorkspaceUserGuide.pdf');
	  },
	  WorkspaceScafSet => sub {
		  %tmpl_args = ( title => 'Workspace Scaffold Sets', current => 'MyIMG', help => 'IMGWorkspaceUserGuide.pdf', yui_js => 'workspaceStyles');
	  },
	  np => sub {
		  $module = 'NaturalProd';
		  %tmpl_args = ( title => 'Biosynthetic Clusters and Secondary Metabolites', current => 'getsme', help => 'GetSMe_intro.pdf');
		  $sub = 'printLandingPage';
	  }
	};

	# extras that use existing data:
	$section_table->{ CompareGenomesTab } = sub {
		$module = 'CompareGenomes';
		$section_table->{ $module }->();
	};
	$section_table->{ FuncCartStorTab } = sub {
		$module = 'FuncCartStor';
		$section_table->{ $module }->();
	};
	$section_table->{ GeneCartStorTab } = sub {
		$module = 'GeneCartStor';
		$section_table->{ $module }->();
	};

	# extras that print headers:
	$section_table->{ EbiIprScan } = sub {
		%tmpl_args = ( title => 'EBI InterPro Scan' );
		print header( -header => "text/html" );
	};
	$section_table->{ GreenGenesBlast } = sub {
		%tmpl_args = ( title => 'Green Genes BLAST' );
		print header( -header => "text/html" );
	};
	$section_table->{ PdbBlast } = sub {
		%tmpl_args = ( title => 'Protein Data Bank BLAST' );
		print header( -header => "text/html" );
	};

	my $page_table = {

		# no incidences
		questions => sub {
			$module = 'Questions';
			$section_table->{ $module }->();
		},

		metaDetail => sub {
			$module = 'MetaDetail';
			$section_table->{ $module }->();
		},

		taxonDetail => sub {
			$module = 'TaxonDetail';
			$section_table->{ $module }->();
		},

		geneDetail => sub {
			$module = 'GeneDetail';
			$section_table->{ $module }->();
		},

        znormNote => sub {
			$module = 'WebUtil';
            %tmpl_args = ( title => "Z-normalization", current => "FindGenes" );
            $sub = 'printZnormNote';
        },

        # non-standard
        message => sub {
            %tmpl_args = ( title => 'Message', current => $req->params->{menuSelection} );
			$module = 'IMG::Views::ViewMaker';
			$sub = 'print_message';
#			$sub = sub {
#				$module->print_message( undef, $req->params->{message} );
#			};
        },
	};


	if ( $section && $section_table->{$section} ) {
		$module = is_valid_module( $section ) if ! $module;
		die "$section does not seem to be a valid module!" unless $module;
		$section_table->{$section}->();
	}
	elsif ( $page && $page_table->{$page} ) {
		die "no module specified" unless $module;
		$page_table->{$page}->();
	}
	# EXCEPTION
    # TODO: http_params --> psgi equivalent
	elsif ( paramMatch( $req, "taxon_oid") && scalar( keys %{$self->http_params} ) < 2 ) {
		$module = 'TaxonDetail';
		%tmpl_args = ( title => 'Taxon Details', current => "FindGenomes" );
		$tmpl_args{help} = 'GenerateGenBankFile.pdf' if $page eq 'taxonArtemisForm';
		# if only taxon_oid is specified assume taxon detail page
		$self->session->write( "section", "TaxonDetail" );
		$self->session->write( "page",    "taxonDetail" );
	}

#	This logic should not be handled here!
	# EXCEPTION!
	elsif ( $req->params->{setTaxonFilter} && $self->config->{taxon_filter_oid_str} ) {
		$module = 'GenomeCart';
		%tmpl_args = ( title => 'Genome Cart', current => "AnaCart" );
		# add to genome cart - ken
		require GenomeList;
		GenomeList::clearCache();
		$self->session->write( "lastCart", "genomeCart" );
	}
	# EXCEPTION!
	elsif (! $req->params->{setTaxonFilter} && ! $self->config->{taxon_filter_oid_str} ) {

		%tmpl_args = ( title => "Genome Selection Message", current => "FindGenomes" );
		printMessage( "Saving 'no selections' is the same as selecting "
			  . "all genomes. Genome filtering is disabled.\n" );
	}

	# non-standard
	elsif ( paramMatch( $req, "uploadTaxonSelections") ) {

		$module = 'TaxonList';
		%tmpl_args = ( title => 'Genome Browser', current => "FindGenomes", help => 'GenomeBrowser.pdf' );
		$sub = 'printTaxonTable';
		# this should be in the module itself
		my $taxon_filter_oid_str = TaxonList::uploadTaxonSelections();
		setTaxonSelections($taxon_filter_oid_str);

	}
	elsif ( $req->params->{exportGenes} ) {
		my $et = $req->params->{exportType};
		if ( 'excel' eq $et ) {
#				my @gene_oid = $req->params->{gene_oid};
#				if ( scalar(@gene_oid) == 0 ) {
#					print_app_header();
#					webError("You must select at least one gene to export.");
#				}
			$tmpl = 'excel';
			%tmpl_args = ( filename => 'gene_export$$.xls' );
			$hdrs = sub {
				return IMG::Views::ViewMaker::print_excel_header("stats_export$$.xls");
			};
			$module = 'GeneDataUtil';
			$sub = 'printGeneDataFile';
			# where has @gene_oid come from?
			#	$module::printGeneDataFile( \@gene_oid );
		}
		elsif ( 'nucleic' eq $et ) {
			$module = 'GenerateArtemisFile';
			%tmpl_args = ( title => "Gene Export" );
			$sub  = 'prepareProcessGeneFastaFile';
		}
		elsif ( 'amino' eq $et ) {
			$module = 'GenerateArtemisFile';
			%tmpl_args = ( title => "Gene Export" );
			$sub = 'prepareProcessGeneAAFastaFile';
		}
		elsif ( 'tab' eq $et ) {
			print_app_header( title => "Gene Export",);
			## CHECK THIS!!
			my $to_do = sub {
				print "<h1>Gene Export</h1>\n";
				my @gene_oid = $req->params->{gene_oid};


				my $nGenes   = @gene_oid;
				if ( $nGenes == 0 ) {
					print "<p>\n";
					webErrorNoFooter("Select genes to export first.");
				}
				print "<p>Export in tab-delimited format for copying and pasting.</p>\n";
				print "<pre>\n";
				require WebUtil;
				WebUtil::printGeneTableExport( \@gene_oid );
				print "</pre>\n";
			};
		}
	}

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

package IMG::Views::Links;

use IMG::Util::Import;
use IMG::Views::ExternalLinks;
use IMG::App::Role::ErrorMessages qw( err );
use IMG::App::Role::Logger;
use utf8;
use Carp;

our (@ISA, @EXPORT_OK);

BEGIN {
	require Exporter;
	@ISA = qw( Exporter );
	@EXPORT_OK = qw( get_link_data get_ext_link get_img_link get_img_link_tt base_url_h );
}

sub set_base_url_h {
	return {
		main_cgi_url    => 'http://localhost',
		base_url        => 'http://localhost',
		server          => 'http://localhost',
		img_google_site => 'http://something.com',
	};
}

my $base_url_h = set_base_url_h();

=pod

=encoding UTF-8

=head1 NAME

IMG::Views::Links - functional interface to IMG link manager

=head1 VERSION

version 0.01

=head1 SYNOPSIS


	use IMG::Views::Links qw( get_img_link );

	# run 'init' to set the values for main_cgi_url and base_url
	#
	my $cfg = {
		base_url => 'https://img.jgi.doe.gov',
		main_cgi_url => 'https://img.jgi.doe.gov/cgi-bin/main.cgi'
	};
	IMG::Views::Links::init( $cfg );

	my $url = get_img_link({ id => 'login' });
	# $url is https://img.jgi.doe.gov

=head1 DESCRIPTION

This module manages links for pages within IMG, and provides an interface to IMG::Views::ExternalLinks.

=head2

=head3 init

Initialise local URL-generating variables

@param   $config  - configuration hash (e.g. from WebConfig or DancerApp->config )

=cut


sub init {
	my $config = shift // die err({ err => 'missing', subject => 'config' });

	say 'Initialising!';

	if (! ref $config || 'HASH' ne ref $config ) {
		die err({
			err => 'format_err',
			subject => 'link configuration',
			fmt => 'a hashref'
		});
	}
	elsif ( ! ( defined $config->{main_cgi_url} || defined $config->{base_url} ) ) {
		die err({
			err => 'cfg_missing',
			subject => 'link URLs'
		});
	}

	# remove any trailing slashes
	for my $v ( qw( main_cgi_url base_url server jbrowse ) ) {
		if ( defined $config->{$v} ) {
			$config->{$v} =~ s!/$!!;
			$base_url_h->{$v} = $config->{$v};
		}
	}
	$base_url_h->{init_run} = 1;
	return 1;
}

=head3 get_ext_link

Get an external link. See IMG::Views::ExternalLinks::get_external_link for details;
use IMG::Views::ExternalLinks directly for a function-oriented interface.

=cut

sub get_ext_link {
	my $self = shift;
	return IMG::Views::ExternalLinks::get_external_link( @_ );
}

=head3 $static_links

Links for static/generic pages (i.e. not gene/taxon/etc. details)

structure:

	label	- text string to use for the link
	title	- string to go in the 'title' attribute (optional)
	url_h	- for links using main.cgi; hashref contains params and values to be appended to main_cgi_url
		url		- links to be appended directly to base_url
		abs_url	- an absolute URL, no appending required
=cut

my $static_links = {
  ABC => {
    label => 'ABC',
    url_h => {
      section => 'np'
    }
  },
#   ANI => {
#     label => 'Average Nucleotide Identity',
#     title => 'ANI',
#     url_h => {
#       section => 'ANI'
#     }
#   },
  'ANI/doSameSpeciesPlot' => {
    label => 'Same Species Plot',
    url_h => {
      page => 'doSameSpeciesPlot',
      section => 'ANI'
    }
  },
  'ANI/overview' => {
    label => '<abbr title="Average Nucleotide Identity">ANI</abbr> Cliques',
    url_h => {
      page => 'overview',
      section => 'ANI'
    }
  },
  'ANI/pairwise' => {
    label => 'Pairwise <abbr title="Average Nucleotide Identity">ANI</abbr>',
    url_h => {
      page => 'pairwise',
      section => 'ANI'
    }
  },
  AbundanceComparisons => {
    label => 'Function Comparisons',
    url_h => {
      section => 'AbundanceComparisons'
    }
  },
  AbundanceComparisonsSub => {
    label => 'Function Category Comparisons',
    url_h => {
      section => 'AbundanceComparisonsSub'
    }
  },
  AbundanceProfileSearch => {
    label => 'Abundance Profile Search',
    url_h => {
      section => 'AbundanceProfileSearch'
    }
  },
  AbundanceProfiles => {
    label => 'Overview (All Functions)',
    url_h => {
      page => 'mergedForm',
      section => 'AbundanceProfiles'
    }
  },
  AllPwayBrowser => {
    label => 'Search Pathways',
    url_h => {
      page => 'allPwayBrowser',
      section => 'AllPwayBrowser'
    }
  },
  Artemis => {
    label => 'Artemis ACT',
    url_h => {
      page => 'ACTForm',
      section => 'Artemis'
    }
  },
  BcNpIDSearch => {
    label => 'Search <abbr title="Biosynthetic clusters">BC</abbr>/<abbr title="Secondary metabolites">SM</abbr> by ID',
    url_h => {
      option => 'np',
      section => 'BcNpIDSearch'
    }
  },
  'BcSearch/bcSearch' => {
    label => 'Search <abbr title="Biosynthetic clusters">BCs</abbr>',
    url_h => {
      page => 'bcSearch',
      section => 'BcSearch'
    }
  },
  'BcSearch/npSearches' => {
    label => 'Search <abbr title="Secondary metabolites">SMs</abbr>',
    url_h => {
      page => 'npSearches',
      section => 'BcSearch'
    }
  },
  BiosyntheticStats => {
    label => 'Biosynthetic Clusters',
    url_h => {
      page => 'stats',
      section => 'BiosyntheticStats'
    }
  },
  CompareGenomes => {
    label => 'Genome Statistics',
    url_h => {
      page => 'compareGenomes',
      section => 'CompareGenomes'
    }
  },
  DistanceTree => {
    label => 'Distance Tree',
    url_h => {
      page => 'tree',
      section => 'DistanceTree'
    }
  },
  DotPlot => {
    label => 'Dot Plot',
    url_h => {
      page => 'plot',
      section => 'DotPlot'
    }
  },
  EgtCluster => {
    label => 'Genome Clustering',
    url_h => {
      page => 'topPage',
      section => 'EgtCluster'
    }
  },
  'FindFunctions/cogList' => {
    label => 'COG List',
    url_h => {
      page => 'cogList',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/cogList/stats' => {
    label => 'COGs with Stats',
    url_h => {
      page => 'cogList',
      section => 'FindFunctions',
      stats => 1
    }
  },
  'FindFunctions/cogid2cat' => {
    label => 'COG Id to Categories',
    url_h => {
      page => 'cogid2cat',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/enzymeList' => {
    label => 'Enzyme',
    url_h => {
      page => 'enzymeList',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/ffoAllCogCategories' => {
    label => 'COG Browser',
    url_h => {
      page => 'ffoAllCogCategories',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/ffoAllKeggPathways/brite' => {
    label => 'Orthology KO Terms',
    url_h => {
      page => 'ffoAllKeggPathways',
      section => 'FindFunctions',
      view => 'brite'
    }
  },
  'FindFunctions/ffoAllKeggPathways/ko' => {
    label => 'Pathways via KO Terms',
    url_h => {
      page => 'ffoAllKeggPathways',
      section => 'FindFunctions',
      view => 'ko'
    }
  },
  'FindFunctions/ffoAllKogCategories' => {
    label => 'KOG Browser',
    url_h => {
      page => 'ffoAllKogCategories',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/ffoAllTc' => {
    label => 'Transporter Classification',
    title => 'Transporter Classification (TC)',
    url_h => {
      page => 'ffoAllTc',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/findFunctions' => {
    label => 'Function Search',
    url_h => {
      page => 'findFunctions',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/kogList' => {
    label => 'KOG List',
    url_h => {
      page => 'kogList',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/kogList/stats' => {
    label => 'KOGs with Stats',
    url_h => {
      page => 'kogList',
      section => 'FindFunctions',
      stats => 1
    }
  },
  'FindFunctions/pfamCategories' => {
    label => 'Pfam Browser',
    url_h => {
      page => 'pfamCategories',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/pfamList' => {
    label => 'Pfam List',
    url_h => {
      page => 'pfamList',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/pfamList/stats' => {
    label => 'Pfam with Stats',
    url_h => {
      page => 'pfamList',
      section => 'FindFunctions',
      stats => 1
    }
  },
  'FindFunctions/pfamListClans' => {
    label => 'Pfam Clans',
    url_h => {
      page => 'pfamListClans',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/tcList' => {
    label => 'TC List',
    url_h => {
      page => 'tcList',
      section => 'FindFunctions'
    }
  },
  'FindGenes/findGenes' => {
    label => 'Find Genes',
    url_h => {
      page => 'findGenes',
      section => 'FindGenes'
    }
  },
  'FindGenes/geneSearch' => {
    label => 'Gene Search',
    url_h => {
      page => 'geneSearch',
      section => 'FindGenes'
    }
  },
  FindGenesBlast => {
    label => 'BLAST',
    url_h => {
      page => 'geneSearchBlast',
      section => 'FindGenesBlast'
    }
  },
  FindGenomes => {
    label => 'Genome Search',
    url_h => {
      page => 'genomeSearch',
      section => 'FindGenomes'
    }
  },
  FuncCartStor => {
    label => 'Functions',
    url_h => {
      page => 'funcCart',
      section => 'FuncCartStor'
    }
  },
  FunctionProfiler => {
    label => 'Function Profile',
    url_h => {
      page => 'profiler',
      section => 'FunctionProfiler'
    }
  },
  GeneCartStor => {
    label => 'Genes',
    url_h => {
      page => 'geneCart',
      section => 'GeneCartStor'
    }
  },
  GeneCassetteProfiler => {
    label => 'Gene Cassettes',
    url_h => {
      page => 'geneContextPhyloProfiler2',
      section => 'GeneCassetteProfiler'
    }
  },
  GeneCassetteSearch => {
    label => 'Cassette Search',
    url_h => {
      page => 'form',
      section => 'GeneCassetteSearch'
    }
  },
  GenomeCart => {
    label => 'Genomes',
    url_h => {
      page => 'genomeCart',
      section => 'GenomeCart'
    }
  },
  GenomeGeneOrtholog => {
    label => 'Genome Gene Best Homologs',
    url_h => {
      section => 'GenomeGeneOrtholog'
    }
  },
  GenomeHits => {
    label => 'Genome vs Metagenomes',
    url_h => {
      section => 'GenomeHits'
    }
  },
  Help => {
    label => 'Site Map',
    title => 'Contains links to all menu pages and documents',
    url_h => {
      section => 'Help'
    }
  },
  'Help/policypage' => {
    label => 'Data Usage Policy',
    url_h => {
      page => 'policypage',
      section => 'Help'
    }
  },
  IMGProteins => {
    label => 'Protein',
    url_h => {
      page => 'proteomics',
      section => 'IMGProteins'
    }
  },
  ImgNetworkBrowser => {
    label => 'IMG Network Browser',
    url_h => {
      page => 'imgNetworkBrowser',
      section => 'ImgNetworkBrowser'
    }
  },
  ImgPartsListBrowser => {
    label => 'IMG Parts List',
    url_h => {
      page => 'browse',
      section => 'ImgPartsListBrowser'
    }
  },
  ImgPwayBrowser => {
    label => 'IMG Pathways',
    url_h => {
      page => 'imgPwayBrowser',
      section => 'ImgPwayBrowser'
    }
  },
  'ImgPwayBrowser/phenoRules' => {
    label => 'Phenotypes',
    url_h => {
      page => 'phenoRules',
      section => 'ImgPwayBrowser'
    }
  },
  ImgStatsOverview => {
    label => 'OMICS',
    url_h => {
      section => 'ImgStatsOverview#tabview=tab3'
    }
  },
  ImgTermBrowser => {
    label => 'IMG Terms',
    url_h => {
      page => 'imgTermBrowser',
      section => 'ImgTermBrowser'
    }
  },
  Interpro => {
    label => 'InterPro Browser',
    url_h => {
      section => 'Interpro'
    }
  },
  MetagPhyloDist => {
    label => 'Metagenomes vs Genomes',
    title => 'Metagenome Phylogenetic Distribution',
    url_h => {
      page => 'form',
      section => 'MetagPhyloDist'
    }
  },
  Methylomics => {
    label => 'Methylation',
    url_h => {
      page => 'methylomics',
      section => 'Methylomics'
    }
  },
  MyIMG => {
    label => 'My IMG Home',
    url_h => {
      page => 'home',
      section => 'MyIMG'
    }
  },
  'MyIMG/myAnnotationsForm' => {
    label => 'Annotations',
    url_h => {
      page => 'myAnnotationsForm',
      section => 'MyIMG'
    }
  },
  'MyIMG/myJobForm' => {
    label => 'Jobs',
    url_h => {
      page => 'myJobForm',
      section => 'MyIMG'
    }
  },
  'MyIMG/preferences' => {
    label => 'Preferences',
    url_h => {
      page => 'preferences',
      section => 'MyIMG'
    }
  },
  NaturalProd => {
    label => 'Secondary Metabolites',
    url_h => {
      page => 'list',
      section => 'NaturalProd'
    }
  },
  PhyloCogs => {
    label => 'Phylogenetic Marker COGs',
    url_h => {
      page => 'phyloCogTaxonsForm',
      section => 'PhyloCogs'
    }
  },
  PhylogenProfiler => {
    label => 'Single Genes',
    url_h => {
      page => 'phyloProfileForm',
      section => 'PhylogenProfiler'
    }
  },
  Questions => {
    label => 'Report Bugs / Issues',
    title => 'Report bugs or issues',
    url_h => {
      page => 'questions'
    }
  },
  RNAStudies => {
    label => 'RNASeq Studies',
    url_h => {
      page => 'rnastudies',
      section => 'RNAStudies'
    }
  },
  RadialPhyloTree => {
    label => 'Radial Tree',
    url_h => {
      section => 'RadialPhyloTree'
    }
  },
  ScaffoldCart => {
    label => 'Scaffolds',
    url_h => {
      page => 'index',
      section => 'ScaffoldCart'
    }
  },
  ScaffoldSearch => {
    label => 'Scaffold Search',
    url_h => {
      section => 'ScaffoldSearch'
    }
  },
  TaxonDeleted => {
    label => 'Deleted Genomes',
    url_h => {
      section => 'TaxonDeleted'
    }
  },
  'TigrBrowser/tigrBrowser' => {
    label => 'TIGRfam Roles',
    url_h => {
      page => 'tigrBrowser',
      section => 'TigrBrowser'
    }
  },
  'TigrBrowser/tigrfamList' => {
    label => 'TIGRfam List',
    url_h => {
      page => 'tigrfamList',
      section => 'TigrBrowser'
    }
  },
  'TigrBrowser/tigrfamList/stats' => {
    label => 'TIGRfam with stats',
    url_h => {
      page => 'tigrfamList',
      section => 'TigrBrowser',
      stats => 1
    },
    url_new => 'TigrBrowser/tigrfamList/stats',
  },
  TreeFile => {
    label => 'Genome Browser',
    url_h => {
      domain => 'all',
      page => 'domain',
      section => 'TreeFile'
    },
  },
  Vista => {
    label => 'VISTA',
    url_h => {
      page => 'vista',
      section => 'Vista'
    }
  },
  Workspace => {
    label => 'Workspace',
    title => 'My saved data: Genes, Functions, Scaffolds, Genomes',
    url_h => {
      section => 'Workspace'
    }
  },

#   'Workspace/WorkspaceFuncSet' => {
#     label => 'Workspace Function Sets',
#     url_h => {
#       page => 'WorkspaceFuncSet',
#       section => 'Workspace'
#     }
#   },
#   'Workspace/WorkspaceGeneSet' => {
#     label => 'Workspace Gene Sets',
#     url_h => {
#       page => 'WorkspaceGeneSet',
#       section => 'Workspace'
#     }
#   },
#   'Workspace/WorkspaceGenomeSet' => {
#     label => 'Workspace Genome Sets',
#     url_h => {
#       page => 'WorkspaceGenomeSet',
#       section => 'Workspace'
#     }
#   },
#   'Workspace/WorkspaceJob' => {
#     label => 'Workspace Jobs',
#     url_h => {
#       page => 'WorkspaceJob',
#       section => 'Workspace'
#     }
#   },
#   'Workspace/WorkspaceRuleSet' => {
#     label => 'Workspace Rule Sets',
#     url_h => {
#       page => 'WorkspaceRuleSet',
#       section => 'Workspace'
#     }
#   },
#   'Workspace/WorkspaceScafSet' => {
#     label => 'Workspace Scaffold Sets',
#     url_h => {
#       page => 'WorkspaceScafSet',
#       section => 'Workspace'
#     }
#   },

  WorkspaceFuncSet => {
    label => 'Function Sets',
    url_h => {
      page => 'home',
      section => 'WorkspaceFuncSet'
    }
  },
  WorkspaceGeneSet => {
    label => 'Gene Sets',
    url_h => {
      page => 'home',
      section => 'WorkspaceGeneSet'
    }
  },
  WorkspaceGenomeSet => {
    label => 'Genome Sets',
    url_h => {
      page => 'home',
      section => 'WorkspaceGenomeSet'
    }
  },
  WorkspaceScafSet => {
    label => 'Scaffold Sets',
    url_h => {
      page => 'home',
      section => 'WorkspaceScafSet'
    }
  },


#	data marts
	w => {
		abs_url => $base_url_h->{server} . '/w',
		label => 'IMG isolates'
	},
	er => {
		abs_url => $base_url_h->{server} . '/er',
		title => 'IMG Expert Review',
		label => '<abbr title="IMG Expert Review">IMG ER</abbr>'
	},
	edu => {
		abs_url => $base_url_h->{server} . '/edu',
		title => 'IMG Education',
		label => '<abbr title="IMG Education">IMG EDU</abbr>'
	},
	'm' => {
		abs_url => $base_url_h->{server} . '/m',
		title => 'IMG Metagenomes',
		label => '<abbr title="IMG Metagenomes">IMG M</abbr>'
	},
	mer => {
		abs_url => $base_url_h->{server} . '/mer',
		title => 'Metagenome Expert Review',
		label => '<abbr title="IMG Metagenome Expert Review">IMG MER</abbr>'
	},
	hmpm => {
		abs_url => 'https://img.jgi.doe.gov/cgi-bin/imgm_hmp/main.cgi',
		title => 'Human Microbiome Project Metagenomes',
		label => '<abbr title="Human Microbiome Project Metagenome">IMG HMP M</abbr>'
	},
	abc => {
		abs_url => $base_url_h->{server} . '/abc',
		label => 'IMG ABC'
	},
	submit => {
		abs_url => $base_url_h->{server} . '/submit',
		label => 'Submit Data Set'
	},

#	other link types
	login => {
		label => 'Log in',
		url => 'login'
	},
	logout => {
		label => 'Log out',
		url => 'logout',
	},

#	proportal links

	home => {
		label => 'IMG/ProPortal', url => 'proportal',
	},
	'menu/proportal' => {
		label => 'Browse', url => 'menu/proportal',
	},
	'menu/search' => {
		label => 'Search', url => 'menu/search',
	},
	'search/blast' => {
		label => 'BLAST', url => 'search/blast',
	},
	'search/advanced_search' => {
		label => 'Advanced Search', url => 'search/advanced_search',
	},
	'menu/tools' => {
		label => 'Tools', url => 'menu/tools',
	},
	'tools/galaxy' => {
		label => 'Launch Galaxy', url => 'tools/galaxy',
	},
	'tools/phyloviewer' => {
		label => 'PhyloViewer', url => 'tools/phyloviewer',
	},
	'tools/jbrowse' => {
		label => 'JBrowse', url => 'tools/jbrowse',
	},
	'tools/krona' => {
		label => 'Krona', url => 'tools/krona',
	},
	my_img => {
		label => 'My IMG', url => 'my_img',
	},
	'my_img/preferences' => {
		label => 'Preferences', url => 'my_img/preferences',
	},
	'menu/support' => {
		label => 'Support', url => 'menu/support',
	},
	'menu/user_guide' => {
		url => 'menu/user_guide',
		label => 'User Guide',
	},
	'support/about' => {
		label => 'About IMG/ProPortal', url => 'support/about',
	},
	'user_guide' => {
		label => 'User Guide', url => 'user_guide',
	},
	'user_guide/api_manual' => {
		label => 'API Manual', url => 'user_guide/api_manual',
	},
	'user_guide/browsing' => {
		label => 'Browsing', url => 'user_guide/browsing',
	},
	'user_guide/getting_started' => {
		label => 'Getting Started', url => 'user_guide/getting_started',
	},
	'user_guide/searching' => {
		label => 'Searching', url => 'user_guide/searching',
	},
	'user_guide/using_tools' => {
		label => 'Using Tools', url => 'user_guide/using_tools',
	},
	'support/news' => {
		label => 'News', url => 'support/news',
	},
	'support/about' => {
		label => 'About', url => 'support/about',
	},
	cart => {
		label => 'Analysis Cart', url => 'cart',
	},
	'cart/genomes' => {
		label => 'Genomes (#)', url => 'cart/genomes',
	},
	'cart/genes' => {
		label => 'Genes (#)', url => 'cart/genes',
	},
	'cart/functions' => {
		label => 'Functions (#)', url => 'cart/functions',
	},
	'cart/scaffolds' => {
		label => 'Scaffolds (#)', url => 'cart/scaffolds',
	},


	proportal => {
		label => 'IMG ProPortal', url => 'proportal',
	},
	'proportal/big_ugly_taxon_table' => {
		url => 'proportal/big_ugly_taxon_table', label => 'table view',
	},
	'proportal/clade' => {
		url => 'proportal/clade', label => 'by clade',
	},
	'proportal/data_type' => {
		url => 'proportal/data_type', label => 'by data type',
	},
	'proportal/location' => {
		url => 'proportal/location', label => 'by location',
	},
	'proportal/phylogram' => {
		url => 'proportal/phylogram', label => 'by taxonomic tree',
	},
	'proportal/ecosystem' => {
		url => 'proportal/ecosystem', label => 'by ecosystem',
	},
	'proportal/ecotype' => {
		url => 'proportal/ecotype', label => 'by ecotype'
	},

	'phyloviewer' => {
		url => 'tools/phyloviewer', label => 'PhyloViewer',
	},

#	galaxy
	galaxy => {
		url => 'galaxy', label => 'Galaxy'
	},

# menu links

	'menu/abc' => {
		url => 'menu/abc',
		label => 'ABC',
	},
	'menu/About' => {
		url => 'menu/About',
		label => 'About',
	},
	'menu/AbundanceProfiles' => {
		url => 'menu/AbundanceProfiles',
		label => 'Abundance Profiles',
	},
	'menu/ani' => {
		url => 'menu/ani',
		label => 'Average Nucleotide Identity',
	},
	'menu/cart' => {
		url => 'menu/cart',
		label => 'Analysis Cart',
	},
	'menu/cassetteProfilers' => {
		url => 'menu/cassetteProfilers',
		label => 'Gene Cassette Profilers',
	},
	'menu/COG' => {
		url => 'menu/COG',
		label => 'COG',
	},
	'menu/CompareGenomes' => {
		url => 'menu/CompareGenomes',
		label => 'Compare Genomes',
	},
	'menu/DataMarts' => {
		url => 'menu/DataMarts',
		label => 'Data Marts',
	},
	'menu/Downloads' => {
		url => 'menu/Downloads',
		label => 'Downloads',
	},
	'menu/FindFunctions' => {
		url => 'menu/FindFunctions',
		label => '<span class="extra-text">Find </span>Functions',
	},
	'menu/FindGenes' => {
		url => 'menu/FindGenes',
		label => '<span class="extra-text">Find </span>Genes',
	},
	'menu/FindGenomes' => {
		url => 'menu/FindGenomes',
		label => '<span class="extra-text">Find </span>Genomes',
	},
	'menu/IMGNetworks' => {
		url => 'menu/IMGNetworks',
		label => 'IMG Networks',
	},
	'menu/isolates' => {
		url => 'menu/isolates',
		label => 'IMG Isolates',
	},
	'menu/KEGG' => {
		url => 'menu/KEGG',
		label => 'KEGG',
	},
	'menu/KOG' => {
		url => 'menu/KOG',
		label => 'KOG',
	},
	'menu/metagenomes' => {
		url => 'menu/metagenomes',
		label => 'IMG Metagenomes',
	},
	'menu/MyIMG' => {
		url => 'menu/MyIMG',
		label => 'My IMG',
	},
	'menu/omics' => {
		url => 'menu/omics',
		label => 'OMICs',
	},
	'menu/Pfam' => {
		url => 'menu/Pfam',
		label => 'Pfam',
	},
	'menu/PhylogeneticDistribution' => {
		url => 'menu/PhylogeneticDistribution',
		label => 'Phylogenetic Distribution',
	},
	'menu/SyntenyViewers' => {
		url => 'menu/SyntenyViewers',
		label => 'Synteny Viewers',
	},
	'menu/TC' => {
		url => 'menu/TC',
		label => 'Transporter Classification (TC)',
	},
	'menu/TIGRfam' => {
		url => 'menu/TIGRfam',
		label => 'TIGRfam',
	},
	'menu/UsingIMG' => {
		url => 'menu/UsingIMG',
		label => 'Using IMG',
	},
	'menu/Workspace' => {
		url => 'menu/Workspace',
		label => 'Workspace',
	},

	## FAKE LINK!!!
	'cart/genomes/add' => {
		url => 'cart/genomes/add',
		label => 'Add to genome cart'
	},

	'about' => {
		abs_url => $base_url_h->{server} . '/#IMGMission',
		label => 'IMG Mission'
	},
	'about/cite' => {
		abs_url => $base_url_h->{img_google_site} . 'using-img/citation',
		label => 'Citation'
	},
	'about/contact' => {
		abs_url => $base_url_h->{img_google_site} . 'contact-us',
		label => 'Contact us' },
	'about/credits' => {
		abs_url => $base_url_h->{img_google_site} . 'using-img/credits',
		label => 'Credits' },
	'about/documents' => {
		abs_url => $base_url_h->{img_google_site} . 'documents', title => 'documents',
		label => 'IMG Document Archive' },
	'about/faq' => {
		abs_url => $base_url_h->{img_google_site} . 'faq', title => 'Frequently Asked Questions',
		label => 'FAQ' },
	'about/links' => {
		abs_url => $base_url_h->{img_google_site} . 'using-img/related-links',
		label => 'Related Links' },
	'about/mer' => {
		abs_url => $base_url_h->{server} . '/mer/doc/about_index.html', title => 'Information about IMG',
		label => 'About IMG/M ER' },
	'about/publications' => {
		abs_url => $base_url_h->{img_google_site} . 'using-img/publication',
		label => 'Publications' },
	'about/systemreqs' => {
		abs_url => $base_url_h->{server} . '/mer/doc/systemreqs.html',
		label => 'System Requirements' },
	'about/tutorial' => {
		abs_url => $base_url_h->{img_google_site} . 'using-img/tutorial',
		label => 'Tutorial' },
	'about/user_forum' => {
		abs_url => $base_url_h->{img_google_site} . 'questions',
		label => 'IMG User Forum' },
	'about/workshop' => {
		abs_url => 'http://www.jgi.doe.gov/meetings/mgm/',
		label => 'MGM Workshop' },

#	{ abs_url => 'http://jgi.doe.gov/data-and-tools/data-management-policy-practices-resources/', label => 'Data Management Policy' },
#	{ abs_url => 'http://jgi.doe.gov/collaborate-with-jgi/pmo-overview/policies/', label => 'Collaborate with JGI' },
#	{ abs_url => 'https://groups.google.com/a/lbl.gov/d/msg/img-user-forum/o4Pjc_GV1js/EazHPcCk1hoJ', label => 'How to download' },
#	{ abs_url => 'http://genome.jgi-psf.org/', label => 'JGI Genome Portal' },


};

=head3 $dynamic_links

Links for dynamic or detail pages, e.g. taxon details, or any page
that depends on certain parameters

=cut

my $dynamic_links = {

	# JBrowse base URL: jbrowse.com/12345678
	# no JBrowse URL:   base_url/jbrowse/12345678
	jbrowse => sub {
		return {
			style => 'new',
			fn => sub {
				my $h = shift;
				return
				( $base_url_h->{jbrowse}
				? $base_url_h->{jbrowse}
				: $base_url_h->{base_url} . '/jbrowse' )
				.
				( $h && $h->{params}
				? '/' . $h->{params}{taxon_oid}
				: '' );
			}
		}
	},

	details => sub {
		return {
			style => 'new',
			fn => sub {
				my $h = shift;
	#			log_debug { 'h: ' . Dumper $h };
				return $h->{base}
				. 'details/'
				. $h->{params}{type}
				.
				( $h->{params}
				? '/' . $h->{params}{ $h->{params}{type} . '_oid' }
				: '' );
			},
		};
	},

	list => sub {
		return {
			style => 'new',
			fn => sub {
				my $h = shift;
				return $h->{base}
				. 'list/'
				. $h->{params}{type}
				.
				( $h->{params}
				? '?' . join "&amp;", map {
						$_ . "=" . escape( $h->{params}{$_} )
					} sort keys %{$h->{params}}
				: '' );
			},
		};
	},
	taxon_details => sub {
		return {
			style => 'new',
			fn => sub {
				return $_[0]->{base} . 'details/taxon' .
				( $_[0] && $_[0]->{params}
				? '/' . shift->{params}{taxon_oid}
				: '' );
			},
		};
	},
	gene_details => sub {
		return {
			style => 'new',
			fn => sub {
				return $_[0]->{base} . 'details/gene' .
				( $_[0] && $_[0]->{params}
				? '/' . shift->{params}{gene_oid}
				: '' );
			},
		};
	},
	taxon_list => sub {
		return {
			style => 'new',
			fn => sub {
				my $h = shift;
				return $h->{base} . 'list/gene' .
				( $h->{params}
				? '?' . join "&amp;", map {
						$_ . "=" . escape( $h->{params}{$_} )
					} sort keys %{$h->{params}}
				: '' );
			},
		};
	},
	gene_list => sub {
		return {
			style => 'new',
			fn => sub {
				my $h = shift;
				return $h->{base} . 'list/gene' .
				( $h->{params}
				? '?' . join "&amp;", map {
						$_ . "=" . escape( $h->{params}{$_} )
					} sort keys %{$h->{params}}
				: '' );
			},
		};
	},
	'list/gene' => sub {
		return {
			style => 'new',
			fn => sub {
				my $h = shift;
				return $h->{base} . 'list/gene' .
				( $h->{params}
				? '?' . join "&amp;", map {
						$_ . "=" . escape( $h->{params}{$_} )
					} sort keys %{$h->{params}}
				: '' );
			},
		};
	},

	genome_list => sub {
		return {
			section => 'ProPortal',
			page => 'genomeList',
	#		?? is this the same as TaxonList/lineageMicrobes ?
	#		class => '',
		};
	},

	genome_list_ecosystem => sub {
		return {
			section => 'ProPortal',
			page => 'genomeList',
			class => 'marine_metagenome',
			ecosystem_subtype => ''
		};
	},

	genome_list_clade => sub {
		return {
			section => 'ProPortal',
			page => 'genomeList',
			metadata_col => 'p.clade',
			clade => ''
		};
	},


#	https://img-proportal-test.jgi.doe.gov/details/taxon/main.cgi?section=GeneCassette&page=occurrence&taxon_oid=2634166547
	chr_cassette_genes => sub {
		return {
			section => 'GeneCassette',
			page => 'occurrence',
			taxon_oid => $_[0]->{params}{taxon_oid}
		};
	},

	biosyn_cluster_genes => sub {
# 	https://img.jgi.doe.gov/cgi-bin/m/main.cgi?section=BiosyntheticDetail&page=biosynthetic_clusters&taxon_oid=637000212
		return {
			section => 'BiosyntheticDetail',
			page => 'biosynthetic_clusters',
			taxon_oid => $_[0]->{params}{taxon_oid}
		};
	}

};

# /gene/details/12345678
# $dynamic_links->{gene_details} = sub {
# 	my $args = shift;
# 	say 'args: ' . Dumper $args;
# 	return $dynamic_links->{details}->( { type => 'gene', %$args } );
# };
#
# $dynamic_links->{taxon_details} = sub {
# 	my $args = shift;
# 	say 'args: ' . Dumper $args;
# 	return $dynamic_links->{details}->( { type => 'taxon', %$args } );
# };
#

	# /taxon/details/1234568
# 	taxon_details => sub {
# 		return {
# 			style => 'new',
# 			fn => sub {
# 				return $_[0]->{base} . 'details/taxon' .
# 				( $_[0] && $_[0]->{params}
# 				? '?' . shift->{params}{taxon_oid}
# 				: '' );
# 			},
# 		};
# 	},

	# /gene/list/<criteria>
# $dynamic_links->{gene_list} = sub {
# 	my $args = shift;
# 	say 'args: ' . Dumper $args;
# 	return $dynamic_links->{list}->( { type => 'gene', %$args } );
# # 	return {
# # 		style => 'new',
# # 		fn => sub {
# # 			my $h = shift;
# # 			return $h->{base} . 'gene/list' .
# # 			( $h->{params}
# # 			? '?' . join "&amp;", map {
# # 					$_ . "=" . escape( $h->{params}{$_} )
# # 				} sort keys %{$h->{params}}
# # 			: '' );
# # 		},
# # 	};
# };

	# /taxon/list/<criteria>
# $dynamic_links->{taxon_list} = sub {
# 	return {
# 		style => 'new',
# 		fn => sub {
# 			my $h = shift;
# 			return $h->{base} . 'taxon/list' .
# 			( $h->{params}
# 			? '/' . join "&amp;", map {
# 					$_ . "=" . escape( $h->{params}{$_} )
# 				} sort keys %{$h->{params}}
# 			: '' );
# 		},
# 	};
# };


=head3 $link_library

Merged library of static and dynamic links

=cut

my $link_library = $static_links;

@$link_library{ keys %$dynamic_links } = map { $_->() } values %$dynamic_links;

sub _get_link_library {
	return $link_library;
}

=head3 get_link_data

Given an ID for a static page, fetch the data for creating the link. Data
includes parameters for constructing the link and the label for the link.

@param  $l      the ID for the page

@return $link_h     hashref of data for the link, including url and label

=cut


sub get_link_data {

	my $l = shift // die err({
		err => 'missing',
		subject => 'link ID'
	});
	return $link_library->{ $l } || undef;
}

my $order = {
	static =>  [ qw( section page domain view stats option ) ],
	dynamic => [ qw( section page class taxon_oid ecosystem_subtype metadata_col clade ) ],
};

my $link_gen_h = {

	new_static => sub {
		my $l_hash = shift;
#		say 'new static: ' . Dumper $l_hash;
		return $l_hash->{base} .
			join "/", map {
				$l_hash->{url_h}{$_}
			} grep {
				exists $l_hash->{url_h}{$_}
			} @{ $order->{static} };
	},

	new_dynamic => sub {
		my $l_hash = shift;
#		say 'new dynamic: ' . Dumper $l_hash;
#		say 'url: ' . $l_hash->{base} . $l_hash->{fn}->( $l_hash );

		# the function should generate the whole link
		if ( $l_hash->{fn} ) {
			return $l_hash->{fn}->( $l_hash );
		}

		return $l_hash->{base} .
			join "/", map {
				$l_hash->{url_h}{$_}
			}
			grep {
				exists $l_hash->{url_h}{$_}
			} @{ $order->{dynamic} };
	},

	old => sub {
		my $l_hash = shift;
		my %temp;
		say 'old: ' . Dumper $l_hash;
		return $l_hash->{base} . "?"
		. join "&amp;",
			map {
				$_ . '=' .
				( $l_hash->{params} && $l_hash->{params}{$_}
					? $l_hash->{params}{$_}
					: $l_hash->{url_h}{$_} )
			}
		# make sure that undefined parameters go to the end of the URL
			sort {
				defined $l_hash->{url_h}{ $a } <=> defined $l_hash->{url_h}{ $b }
				||
				$a cmp $b
			} keys %{$l_hash->{url_h}};
	},
};


=head3 get_img_link

Get a link from the library. See get_img_link_tt for the Template Toolkit wrapper.

@param  $args  hashref of arguments, including the following
		id => $id           the link identifier (e.g. a page ID or link type)
		style => 'old' | 'new'  link style -- defaults to 'old' -- main.cgi?x=y
		params => { }     link parameters (e.g. taxon_oid=1234567)

@return $string     link string

=cut

sub get_img_link {

	if ( ! $base_url_h->{init_run} ) {
		die err({
			err => 'cfg_missing',
			subject => 'link URLs'
		});
	}

	my $args = shift // die err({
		err => 'missing',
		subject => 'arguments to get_img_link'
	});

	if ( ! exists $args->{id} || ! $args->{id} ) {

#		warn 'args: ' . Dumper $args;
		die err({
			err => 'missing',
			subject => 'link ID'
		});
	}


	# get the link data or die trying
	my $l_data = $link_library->{ $args->{id} } || confess err({
		err => 'invalid',
		type => 'link ID',
		subject => $args->{id}
	});

	my $jbrowse;
	if ( $args->{id} eq 'jbrowse' ) {
		$jbrowse++;
	}

	if ( $l_data->{abs_url} ) {
		return $l_data->{abs_url};
	}

	my $base = $l_data->{base_url} || $base_url_h->{base_url};
	if ( '/' ne substr( $base, -1 ) ) {
		$base .= '/';
	}

	if ( $l_data->{url} ) {
		# send it as-is
		return $base . $l_data->{url};
	}

#	say 'args: '   . Dumper $args if $jbrowse;
#	say 'l_data: ' . Dumper $l_data if $jbrowse;

	$args->{style} ||= $l_data->{style} // 'old';

#	say 'style now: ' . $args->{style};

	if ( 'new' eq $args->{style} ) {
		$args->{style} .= ( exists $dynamic_links->{ $args->{id} }
		? '_dynamic'
		: '_static' );
	}
	elsif ( 'old' eq $args->{style} ) {
		$base = $base_url_h->{main_cgi_url};
	}
	else {
		$args->{style} = 'old';
		$base = $base_url_h->{main_cgi_url};
	}

	if ( $args->{params} ) {
		for ( keys %{$args->{params}} ) {
			# params should be URL-encoded!
			$args->{params}{$_} = escape( $args->{params}{$_} );
		}
	}

# 	say 'base: '   . Dumper $base if $jbrowse;
# 	say 'l_data: ' . Dumper $l_data if $jbrowse;
# 	say 'args: '   . Dumper $args if $jbrowse;

	return $link_gen_h->{ $args->{style} }->( { base => $base, %$l_data, %$args } );

}

sub escape {
	my $toencode = shift;
	return undef unless defined($toencode);
	utf8::encode($toencode);
	$toencode=~s/([^a-zA-Z0-9_.-])/uc sprintf("%%%02x",ord($1))/eg;
	return $toencode;
}


=head3 get_img_link_tt

Template Toolkit wrapper for getting an IMG link, allowing a simpler syntax to be used

To use in a template, specify the link ID as the first argument, and any extra parameters as the second. For example:

[% link( 'MyIMG/preferences' ) %]

# http://example.com/cgi-bin/main.cgi?section=MyIMG&amp;page=preferences

[% link( 'details', { type => 'taxon', taxon_oid => 1234567 } %]

# http://example.com/cgi-bin/main.cgi?section=TaxonDetail&amp;page=taxonDetail&taxon_oid=1234567

=cut

sub get_img_link_tt {

#	warn __SUB__ . ' arguments: ' . Dumper [ @_ ];
	if ( 2 == scalar @_ ) {
		return get_img_link({ id => shift, params => shift });
	}
	if ( ! ref $_[0] ) {
		return get_img_link({ id => shift });
	}
	return get_img_link( @_ );
}

=head3 reset_links

Undefine $env for testing purposes

=cut

sub reset_links {
	delete $base_url_h->{init_run};
}


1;

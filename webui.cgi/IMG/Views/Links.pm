package IMG::Views::Links;

use IMG::Util::Base;

our (@ISA, @EXPORT_OK);

BEGIN {
	require Exporter;
	@ISA = qw( Exporter );
	@EXPORT_OK = qw( get_link get_link_data get_ext_link );
}

=head3 $link_library

All links

=cut

my $link_library  = {
  ABC => {
    label => 'ABC',
    url => {
      section => 'np'
    }
  },
  ANI => {
    label => 'Average Nucleotide Identity',
    title => 'ANI',
    url => {
      section => 'ANI'
    }
  },
  'ANI/doSameSpeciesPlot' => {
    label => 'Same Species Plot',
    url => {
      page => 'doSameSpeciesPlot',
      section => 'ANI'
    }
  },
  'ANI/overview' => {
    label => 'ANI Cliques',
    url => {
      page => 'overview',
      section => 'ANI'
    }
  },
  'ANI/pairwise' => {
    label => 'Pairwise ANI',
    title => 'Pairwise',
    url => {
      page => 'pairwise',
      section => 'ANI'
    }
  },
  AbundanceComparisons => {
    label => 'Function Comparisons',
    url => {
      section => 'AbundanceComparisons'
    }
  },
  AbundanceComparisonsSub => {
    label => 'Function Category Comparisons',
    url => {
      section => 'AbundanceComparisonsSub'
    }
  },
  AbundanceProfileSearch => {
    label => 'Abundance Profile Search',
    url => {
      section => 'AbundanceProfileSearch'
    }
  },
  AbundanceProfiles => {
    label => 'Overview (All Functions)',
    url => {
      page => 'mergedForm',
      section => 'AbundanceProfiles'
    }
  },
  AllPwayBrowser => {
    label => 'Search Pathways',
    url => {
      page => 'allPwayBrowser',
      section => 'AllPwayBrowser'
    }
  },
  Artemis => {
    label => 'Artemis ACT',
    url => {
      page => 'ACTForm',
      section => 'Artemis'
    }
  },
  BcNpIDSearch => {
    label => 'Search <abbr title="Biosynthetic clusters">BC</abbr>/<abbr title="Secondary metabolites">SM</abbr> by ID',
    url => {
      option => 'np',
      section => 'BcNpIDSearch'
    }
  },
  'BcSearch/bcSearch' => {
    label => 'Search <abbr title="Biosynthetic clusters">BCs</abbr>',
    url => {
      page => 'bcSearch',
      section => 'BcSearch'
    }
  },
  'BcSearch/npSearches' => {
    label => 'Search <abbr title="Secondary metabolites">SMs</abbr>',
    url => {
      page => 'npSearches',
      section => 'BcSearch'
    }
  },
  BiosyntheticStats => {
    label => 'Biosynthetic Clusters',
    url => {
      page => 'stats',
      section => 'BiosyntheticStats'
    }
  },
  CompareGenomes => {
    label => 'Genome Statistics',
    url => {
      page => 'compareGenomes',
      section => 'CompareGenomes'
    }
  },
  DistanceTree => {
    label => 'Distance Tree',
    url => {
      page => 'tree',
      section => 'DistanceTree'
    }
  },
  DotPlot => {
    label => 'Dot Plot',
    url => {
      page => 'plot',
      section => 'DotPlot'
    }
  },
  EgtCluster => {
    label => 'Genome Clustering',
    url => {
      page => 'topPage',
      section => 'EgtCluster'
    }
  },
  'FindFunctions/cogList' => {
    label => 'COG List',
    url => {
      page => 'cogList',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/cogList/stats' => {
    label => 'COGs with Stats',
    url => {
      page => 'cogList',
      section => 'FindFunctions',
      stats => 1
    }
  },
  'FindFunctions/cogid2cat' => {
    label => 'COG Id to Categories',
    url => {
      page => 'cogid2cat',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/enzymeList' => {
    label => 'Enzyme',
    url => {
      page => 'enzymeList',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/ffoAllCogCategories' => {
    label => 'COG Browser',
    url => {
      page => 'ffoAllCogCategories',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/ffoAllKeggPathways/brite' => {
    label => 'Orthology KO Terms',
    url => {
      page => 'ffoAllKeggPathways',
      section => 'FindFunctions',
      view => 'brite'
    }
  },
  'FindFunctions/ffoAllKeggPathways/ko' => {
    label => 'Pathways via KO Terms',
    url => {
      page => 'ffoAllKeggPathways',
      section => 'FindFunctions',
      view => 'ko'
    }
  },
  'FindFunctions/ffoAllKogCategories' => {
    label => 'KOG Browser',
    url => {
      page => 'ffoAllKogCategories',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/ffoAllTc' => {
    label => 'Transporter Classification',
    title => 'Transporter Classification (TC)',
    url => {
      page => 'ffoAllTc',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/findFunctions' => {
    label => 'Function Search',
    url => {
      page => 'findFunctions',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/kogList' => {
    label => 'KOG List',
    url => {
      page => 'kogList',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/kogList/stats' => {
    label => 'KOGs with Stats',
    url => {
      page => 'kogList',
      section => 'FindFunctions',
      stats => 1
    }
  },
  'FindFunctions/pfamCategories' => {
    label => 'Pfam Browser',
    url => {
      page => 'pfamCategories',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/pfamList' => {
    label => 'Pfam List',
    url => {
      page => 'pfamList',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/pfamList/stats' => {
    label => 'Pfam with Stats',
    url => {
      page => 'pfamList',
      section => 'FindFunctions',
      stats => 1
    }
  },
  'FindFunctions/pfamListClans' => {
    label => 'Pfam Clans',
    url => {
      page => 'pfamListClans',
      section => 'FindFunctions'
    }
  },
  'FindFunctions/tcList' => {
    label => 'TC List',
    url => {
      page => 'tcList',
      section => 'FindFunctions'
    }
  },
  'FindGenes/findGenes' => {
    label => 'Find Genes',
    url => {
      page => 'findGenes',
      section => 'FindGenes'
    }
  },
  'FindGenes/geneSearch' => {
    label => 'Gene Search',
    url => {
      page => 'geneSearch',
      section => 'FindGenes'
    }
  },
  FindGenesBlast => {
    label => 'BLAST',
    url => {
      page => 'geneSearchBlast',
      section => 'FindGenesBlast'
    }
  },
  FindGenomes => {
    label => 'Genome Search',
    url => {
      page => 'genomeSearch',
      section => 'FindGenomes'
    }
  },
  FuncCartStor => {
    label => 'Functions',
    url => {
      page => 'funcCart',
      section => 'FuncCartStor'
    }
  },
  FunctionProfiler => {
    label => 'Function Profile',
    url => {
      page => 'profiler',
      section => 'FunctionProfiler'
    }
  },
  GeneCartStor => {
    label => 'Genes',
    url => {
      page => 'geneCart',
      section => 'GeneCartStor'
    }
  },
  GeneCassetteProfiler => {
    label => 'Gene Cassettes',
    url => {
      page => 'geneContextPhyloProfiler2',
      section => 'GeneCassetteProfiler'
    }
  },
  GeneCassetteSearch => {
    label => 'Cassette Search',
    url => {
      page => 'form',
      section => 'GeneCassetteSearch'
    }
  },
  GenomeCart => {
    label => 'Genomes',
    url => {
      page => 'genomeCart',
      section => 'GenomeCart'
    }
  },
  GenomeGeneOrtholog => {
    label => 'Genome Gene Best Homologs',
    url => {
      section => 'GenomeGeneOrtholog'
    }
  },
  GenomeHits => {
    label => 'Genome vs Metagenomes',
    url => {
      section => 'GenomeHits'
    }
  },
  Help => {
    label => 'Site Map',
    title => 'Contains links to all menu pages and documents',
    url => {
      section => 'Help'
    }
  },
  'Help/policypage' => {
    label => 'Data Usage Policy',
    url => {
      page => 'policypage',
      section => 'Help'
    }
  },
  IMGProteins => {
    label => 'Protein',
    url => {
      page => 'proteomics',
      section => 'IMGProteins'
    }
  },
  ImgNetworkBrowser => {
    label => 'IMG Network Browser',
    url => {
      page => 'imgNetworkBrowser',
      section => 'ImgNetworkBrowser'
    }
  },
  ImgPartsListBrowser => {
    label => 'IMG Parts List',
    url => {
      page => 'browse',
      section => 'ImgPartsListBrowser'
    }
  },
  ImgPwayBrowser => {
    label => 'IMG Pathways',
    url => {
      page => 'imgPwayBrowser',
      section => 'ImgPwayBrowser'
    }
  },
  'ImgPwayBrowser/phenoRules' => {
    label => 'Phenotypes',
    url => {
      page => 'phenoRules',
      section => 'ImgPwayBrowser'
    }
  },
  ImgStatsOverview => {
    label => 'OMICS',
    url => {
      section => 'ImgStatsOverview#tabview=tab3'
    }
  },
  ImgTermBrowser => {
    label => 'IMG Terms',
    url => {
      page => 'imgTermBrowser',
      section => 'ImgTermBrowser'
    }
  },
  Interpro => {
    label => 'InterPro Browser',
    url => {
      section => 'Interpro'
    }
  },
  MetagPhyloDist => {
    label => 'Metagenomes vs Genomes',
    title => 'Metagenome Phylogenetic Distribution',
    url => {
      page => 'form',
      section => 'MetagPhyloDist'
    }
  },
  Methylomics => {
    label => 'Methylation',
    url => {
      page => 'methylomics',
      section => 'Methylomics'
    }
  },
  MyIMG => {
    label => 'My IMG',
    url => {
      section => 'MyIMG'
    }
  },
  'MyIMG/home' => {
    label => 'MyIMG Home',
    url => {
      page => 'home',
      section => 'MyIMG'
    }
  },
  'MyIMG/myAnnotationsForm' => {
    label => 'Annotations',
    url => {
      page => 'myAnnotationsForm',
      section => 'MyIMG'
    }
  },
  'MyIMG/myJobForm' => {
    label => 'MyJob',
    url => {
      page => 'myJobForm',
      section => 'MyIMG'
    }
  },
  'MyIMG/preferences' => {
    label => 'Preferences',
    url => {
      page => 'preferences',
      section => 'MyIMG'
    }
  },
  NaturalProd => {
    label => 'Secondary Metabolites',
    url => {
      page => 'list',
      section => 'NaturalProd'
    }
  },
  PhyloCogs => {
    label => 'Phylogenetic Marker COGs',
    url => {
      page => 'phyloCogTaxonsForm',
      section => 'PhyloCogs'
    }
  },
  PhylogenProfiler => {
    label => 'Single Genes',
    url => {
      page => 'phyloProfileForm',
      section => 'PhylogenProfiler'
    }
  },
  Questions => {
    label => 'Report Bugs / Issues',
    title => 'Report bugs or issues',
    url => {
      page => 'questions'
    }
  },
  RNAStudies => {
    label => 'RNASeq Studies',
    url => {
      page => 'rnastudies',
      section => 'RNAStudies'
    }
  },
  RadialPhyloTree => {
    label => 'Radial Tree',
    url => {
      section => 'RadialPhyloTree'
    }
  },
  ScaffoldCart => {
    label => 'Scaffolds',
    url => {
      page => 'index',
      section => 'ScaffoldCart'
    }
  },
  ScaffoldSearch => {
    label => 'Scaffold Search',
    url => {
      section => 'ScaffoldSearch'
    }
  },
  TaxonDeleted => {
    label => 'Deleted Genomes',
    url => {
      section => 'TaxonDeleted'
    }
  },
  'TigrBrowser/tigrBrowser' => {
    label => 'TIGRfam Roles',
    url => {
      page => 'tigrBrowser',
      section => 'TigrBrowser'
    }
  },
  'TigrBrowser/tigrfamList' => {
    label => 'TIGRfam List',
    url => {
      page => 'tigrfamList',
      section => 'TigrBrowser'
    }
  },
  'TigrBrowser/tigrfamList/stats' => {
    label => 'TIGRfam with stats',
    url => {
      page => 'tigrfamList',
      section => 'TigrBrowser',
      stats => 1
    }
  },
  TreeFile => {
    label => 'Genome Browser',
    url => {
      domain => 'all',
      page => 'domain',
      section => 'TreeFile'
    }
  },
  Vista => {
    label => 'VISTA',
    url => {
      page => 'vista',
      section => 'Vista'
    }
  },
  Workspace => {
    label => 'Workspace',
    title => 'My saved data: Genes, Functions, Scaffolds, Genomes',
    url => {
      section => 'Workspace'
    }
  },

#   'Workspace/WorkspaceFuncSet' => {
#     label => 'Workspace Function Sets',
#     url => {
#       page => 'WorkspaceFuncSet',
#       section => 'Workspace'
#     }
#   },
#   'Workspace/WorkspaceGeneSet' => {
#     label => 'Workspace Gene Sets',
#     url => {
#       page => 'WorkspaceGeneSet',
#       section => 'Workspace'
#     }
#   },
#   'Workspace/WorkspaceGenomeSet' => {
#     label => 'Workspace Genome Sets',
#     url => {
#       page => 'WorkspaceGenomeSet',
#       section => 'Workspace'
#     }
#   },
#   'Workspace/WorkspaceJob' => {
#     label => 'Workspace Jobs',
#     url => {
#       page => 'WorkspaceJob',
#       section => 'Workspace'
#     }
#   },
#   'Workspace/WorkspaceRuleSet' => {
#     label => 'Workspace Rule Sets',
#     url => {
#       page => 'WorkspaceRuleSet',
#       section => 'Workspace'
#     }
#   },
#   'Workspace/WorkspaceScafSet' => {
#     label => 'Workspace Scaffold Sets',
#     url => {
#       page => 'WorkspaceScafSet',
#       section => 'Workspace'
#     }
#   },

  WorkspaceFuncSet => {
    label => 'Function Sets',
    url => {
      page => 'home',
      section => 'WorkspaceFuncSet'
    }
  },
  WorkspaceGeneSet => {
    label => 'Gene Sets',
    url => {
      page => 'home',
      section => 'WorkspaceGeneSet'
    }
  },
  WorkspaceGenomeSet => {
    label => 'Genome Sets',
    url => {
      page => 'home',
      section => 'WorkspaceGenomeSet'
    }
  },
  WorkspaceScafSet => {
    label => 'Scaffold Sets',
    url => {
      page => 'home',
      section => 'WorkspaceScafSet'
    }
  },

# other link types
  Login => {
  	label => 'Log in',
  	url => '/login'
  },
  Logout => {
  	label => 'Log out',
  	url => '/logout',
  },

	proportal => {
		label => 'IMG ProPortal',
		url => '/proportal',
	},
	'proportal/clade' => {
		url => '/proportal/clade', label => 'by clade',
	},
	'proportal/data_type' => {
		url => '/proportal/data_type', label => 'by data type',
	},
	'proportal/location' => {
		url => '/proportal/location', label => 'by location',
	},
	'proportal/phylogram' => {
		url => '/phylogram.html', label => 'phylogram (work in progress)',
	},
	'proportal/phylo_heat' => {
		url => '/proportal/phylo_heat', label => 'phylogram / heat map',
	},

# menu links

	'/menu/abc' => {
		url => '/menu/abc', label => 'ABC',
	},
	'/menu/About' => {
		url => '/menu/About', label => 'About',
	},
	'/menu/AbundanceProfiles' => {
		url => '/menu/AbundanceProfiles', label => 'Abundance Profiles',
	},
	'/menu/ani' => {
		url => '/menu/ani', label => 'Average Nucleotide Identity',
	},
	'/menu/cart' => {
		url => '/menu/cart', label => 'Analysis Cart',
	},
	'/menu/cassetteProfilers' => {
		url => '/menu/cassetteProfilers', label => 'Gene Cassette Profilers',
	},
	'/menu/COG' => {
		url => '/menu/COG', label => 'COG',
	},
	'/menu/CompareGenomes' => {
		url => '/menu/CompareGenomes', label => 'Compare Genomes',
	},
	'/menu/DataMarts' => {
		url => '/menu/DataMarts', label => 'Data Marts',
	},
	'/menu/Downloads' => {
		url => '/menu/Downloads', label => 'Downloads',
	},
	'/menu/FindFunctions' => {
		url => '/menu/FindFunctions', label => 'Find Functions',
	},
	'/menu/FindGenes' => {
		url => '/menu/FindGenes', label => 'Find Genes',
	},
	'/menu/FindGenomes' => {
		url => '/menu/FindGenomes', label => 'Find Genomes',
	},
	'/menu/IMGNetworks' => {
		url => '/menu/IMGNetworks', label => 'IMG Networks',
	},
	'/menu/isolates' => {
		url => '/menu/isolates', label => 'IMG isolates',
	},
	'/menu/KEGG' => {
		url => '/menu/KEGG', label => 'KEGG',
	},
	'/menu/KOG' => {
		url => '/menu/KOG', label => 'KOG',
	},
	'/menu/metagenomes' => {
		url => '/menu/metagenomes', label => 'IMG Metagenomes',
	},
	'/menu/MyIMG' => {
		url => '/menu/MyIMG', label => 'MyIMG',
	},
	'/menu/omics' => {
		url => '/menu/omics', label => 'OMICs',
	},
	'/menu/Pfam' => {
		url => '/menu/Pfam', label => 'Pfam',
	},
	'/menu/PhylogeneticDistribution' => {
		url => '/menu/PhylogeneticDistribution', label => 'Phylogenetic Distribution',
	},
	'/menu/SyntenyViewers' => {
		url => '/menu/SyntenyViewers', label => 'Synteny Viewers',
	},
	'/menu/TC' => {
		url => '/menu/TC', label => 'Transporter Classification (TC)',
	},
	'/menu/TIGRfam' => {
		url => '/menu/TIGRfam', label => 'TIGRfam',
	},
	'/menu/UserGuide' => {
		url => '/menu/UserGuide', label => 'User Guide',
	},
	'/menu/UsingIMG' => {
		url => '/menu/UsingIMG', label => 'Using IMG',
	},
	'/menu/Workspace' => {
		url => '/menu/Workspace', label => 'Workspace',
	},


#		depth_graph => 'by depth',
#		datamart_stats => 'data mart stats',
#		genome_list => 'genome list',

};

sub get_link_data {

	my $l = shift;
	return $link_library->{ $l } || undef;

}

=head3 proportal_links

Construct links for ProPortal pages

Takes the list of active components or a default set of components

@output $links          hash of link templates

=cut

sub proportal_links {
#	my $self = shift;
	my $config = shift;
	my $active = $config->{active_components} || [ qw( location clade data_type ) ];

	my %links;

	@links{ @$active } = map { $config->{pp_app} . $_ . "/" } @$active;

	return \%links;

}

my $params = [ qw( section page class taxon_oid ecosystem_subtype metadata_col clade ) ];


=head3 img_links

Construct templates for internal (ProPortal) links

@param  $style  (opt)   the link style to construct. Will use the old school
                        param=value form unless specified otherwise
                        currently-valid values: 'new'

@output $output         hash of link templates

=cut

# links required: news

sub img_links {
#	my $self = shift;
	my $config = shift;
	my $style = shift || 'old';

	my $base = {
		old => $config->{main_cgi_url},
#		new => $self->config->{pp_app},
	};

	my $links = {
		taxon => {
			section => 'TaxonDetail',
			page => 'taxonDetail',
			taxon_oid => ''
		},
		genome_list => {
			section => 'ProPortal',
			page => 'genomeList',
			class => '',
		},
		genome_list_ecosystem => {
			section => 'ProPortal',
			page => 'genomeList',
			class => 'marine_metagenome',
			ecosystem_subtype => ''
		},
		genome_list_clade => {
			section => 'ProPortal',
			page => 'genomeList',
			metadata_col => 'p.clade',
			clade => ''
		},
		workspace_gene_set => {
#			url => {
			section => 'WorkspaceGeneSet'
#			},
#			title => 'Workspace Gene Sets',
		},
	};

	my $link_gen = {
		# new skool /section/page/class style
		'new' => sub {
			my $l_hash = shift;
			return join "", map { "/" . ( $l_hash->{$_} || "" ) } grep { exists $l_hash->{$_} } @$params;
		},

		# this constructs URLs in the old skool arg1=val1&arg2=val2 style
		'old' => sub {
			my $l_hash = shift;
			return
				$base->{old} . "?" . join "&amp;",
					map { $_ . "=" . ( $l_hash->{$_} || "" ) }
					grep { exists $l_hash->{$_} } @$params;
		}
	};

	if (! $link_gen->{$style}) {
		$style = 'old';
	}

	my %output;

	@output{ keys %$links } = map {
		$link_gen->{ $style }->( $_ );
	} values %$links;

	return \%output;
}



sub new_link_gen {

	my $l_hash = shift;
	return join "", map { "/" . ( $l_hash->{$_} || "" ) } grep { exists $l_hash->{$_} } @$params;

}

sub old_link_gen {

	my $l_hash = shift;
	return "?"
		. join "&amp;",
			map { $_ . "=" . ( $l_hash->{$_} || "" ) }
			grep { exists $l_hash->{$_} } @$params;
}


=head3 external_links

External links

=cut

my $external_links = {

	'sso_api_url' => 'https://signon.jgi-psf.org/api/sessions/',
	'sso_url' => 'https://signon.jgi-psf.org',
	'sso_user_info_url' => 'https://signon.jgi-psf.org/api/users/',

	'aclame_base_url' => 'http://aclame.ulb.ac.be/perl/Aclame/Genomes/prot_view.cgi?mode=genome&id=',
	'artemis_url' => 'http://www.sanger.ac.uk/Software/Artemis/',
	'blast_server_url' => 'https://img-worker.jgi-psf.org/cgi-bin/usearch/generic/hopsServer.cgi',
	'blastallm0_server_url' => 'https://img-worker.jgi-psf.org/cgi-bin/blast/generic/blastQueue.cgi',
	'cmr_jcvi_ncbi_project_id_base_url' => 'http://cmr.jcvi.org/cgi-bin/CMR/ncbiProjectId2CMR.cgi?ncbi_project_id=',
	'doi' => 'http://dx.doi.org/',
	'ebi_iprscan_url' => 'http://www.ebi.ac.uk/Tools/pfa/iprscan/',
	'enzyme_base_url' => 'http://www.genome.jp/dbget-bin/www_bget?',
	'flybase_base_url' => 'http://flybase.bio.indiana.edu/reports/',
	'gbrowse_base_url' => 'http://gpweb07.nersc.gov/',
	'gcat_base_url' => 'http://darwin.nox.ac.uk/gsc/gcat/report/',
	'geneid_base_url' => 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=gene&cmd=Retrieve&dopt=full_report&list_uids=',
	'go_base_url' => 'http://www.ebi.ac.uk/ego/DisplayGoTerm?id=',
	'go_evidence_url' => 'http://www.geneontology.org/GO.evidence.shtml',
	'gold_api_base_url' => 'https://gpweb08.nersc.gov:8443/',
	'gold_base_url' => 'http://genomesonline.org/',
	'gold_base_url_analysis' => 'https://gold.jgi-psf.org/analysis_projects?id=',
	'gold_base_url_project' => 'https://gold.jgi-psf.org/projects?id=',
	'gold_base_url_study' => 'https://gold.jgi-psf.org/study?id=',
	'greengenes_base_url' => 'http://greengenes.lbl.gov/cgi-bin/show_one_record_v2.pl?prokMSA_id=',
	'greengenes_blast_url' => 'http://greengenes.lbl.gov/cgi-bin/nph-blast_interface.cgi',
	'hgnc_base_url' => 'http://www.gene.ucl.ac.uk/nomenclature/data/get_data.php?hgnc_id=',
	'img_er_submit_project_url' => 'https://img.jgi.doe.gov/cgi-bin/submit/main.cgi?section=ProjectInfo&page=displayProject&project_oid=',
	'img_er_submit_url' => 'https://img.jgi.doe.gov/cgi-bin/submit/main.cgi?section=ERSubmission&page=displaySubmission&submission_id=',
	'img_mer_submit_url' => 'https://img.jgi.doe.gov/cgi-bin/submit/main.cgi?section=MSubmission&page=displaySubmission&submission_id=',
	'img_submit_url' => 'https://img.jgi.doe.gov/submit',
	'ipr_base_url' => 'http://www.ebi.ac.uk/interpro/entry/',
	'ipr_base_url2' => 'http://supfam.cs.bris.ac.uk/SUPERFAMILY/cgi-bin/scop.cgi?ipid=',
	'ipr_base_url3' => 'http://prosite.expasy.org/',
	'ipr_base_url4' => 'http://smart.embl-heidelberg.de/smart/do_annotation.pl?ACC=',
	'jgi_project_qa_base_url' => 'http://cayman.jgi-psf.org/prod/data/QA/Reports/QD/',
	'kegg_module_url' => 'http://www.genome.jp/dbget-bin/www_bget?md+',
	'kegg_orthology_url' => 'http://www.genome.jp/dbget-bin/www_bget?ko+',
	'kegg_reaction_url' => 'http://www.genome.jp/dbget-bin/www_bget?rn+',
	'ko_base_url' => 'http://www.genome.ad.jp/dbget-bin/www_bget?ko+',
	'metacyc_url' => 'http://biocyc.org/META/NEW-IMAGE?object=',
	'mgi_base_url' => 'http://www.informatics.jax.org/searches/accession_report.cgi?id=MGI:',
	'ncbi_blast_server_url' => 'https://img-proportal-dev.jgi-psf.org/cgi-bin/ncbiBlastServer.cgi',
	'ncbi_blast_url' => 'http://www.ncbi.nlm.nih.gov/blast/Blast.cgi?PAGE=Proteins&PROGRAM=blastp&BLAST_PROGRAMS=blastp&PAGE_TYPE=BlastSearch&SHOW_DEFAULTS=on',
	'ncbi_entrez_base_url' => 'http://www.ncbi.nlm.nih.gov/entrez/viewer.fcgi?val=',
	'ncbi_mapview_base_url' => 'http://www.ncbi.nlm.nih.gov/mapview/map_search.cgi?direct=on&idtype=gene&id=',
	'ncbi_project_id_base_url' => 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=genomeprj&cmd=Retrieve&dopt=Overview&list_uids=',
	'nice_prot_base_url' => 'http://www.uniprot.org/uniprot/',
	'pdb_base_url' => 'http://www.rcsb.org/pdb/explore.do?structureId=',
	'pdb_blast_url' => 'http://www.rcsb.org/pdb/search/searchSequence.do',
	'pfam_base_url' => 'http://pfam.sanger.ac.uk/family?acc=',
	'pfam_clan_base_url' => 'http://pfam.sanger.ac.uk/clan?acc=',
	'pirsf_base_url' => 'http://pir.georgetown.edu/cgi-bin/ipcSF?id=',
	'pubmed' => 'http://www.ncbi.nlm.nih.gov/pubmed/',
	'pubmed_base_url' => 'http://www.ncbi.nlm.nih.gov/entrez?db=PubMed&term=',
	'puma_base_url' => 'http://compbio.mcs.anl.gov/puma2/cgi-bin/search.cgi?protein_id_type=NCBI_GI&search=Search&search_type=protein_id&search_text=',
	'puma_redirect_base_url' => 'http://compbio.mcs.anl.gov/puma2/cgi-bin/puma2_url.cgi?gi=',
	'regtransbase_base_url' => 'http://regtransbase.lbl.gov/cgi-bin/regtransbase?page=geneinfo&protein_id=',
	'regtransbase_check_base_url' => 'http://regtransbase.lbl.gov/cgi-bin/regtransbase?page=check_gene_exp&protein_id=',
	'rfam_base_url' => 'http://rfam.sanger.ac.uk/family/',
	'rgd_base_url' => 'http://rgd.mcw.edu/tools/genes/genes_view.cgi?id=',
	'rna_server_url' => 'https://img-worker.jgi-psf.org/cgi-bin/blast/generic/rnaServer.cgi',
	'swiss_prot_base_url' => 'http://www.uniprot.org/uniprot/',
	'swissprot_source_url' => 'http://www.uniprot.org/uniprot/',
	'tair_base_url' => 'http://www.arabidopsis.org/servlets/TairObject?type=locus&name=',
	'taxonomy_base_url' => 'http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=',
	'tigrfam_base_url' => 'http://www.jcvi.org/cgi-bin/tigrfams/HmmReportPage.cgi?acc=',
	'unigene_base_url' => 'http://www.ncbi.nlm.nih.gov/UniGene/clust.cgi',
	'vimss_redirect_base_url' => 'http://www.microbesonline.org/cgi-bin/gi2vimss.cgi?gi=',
	'worker_base_url' => 'https://img-worker.jgi-psf.org',
	'wormbase_base_url' => 'http://www.wormbase.org/db/gene/gene?name=',
	'zfin_base_url' => 'http://zfin.org/cgi-bin/webdriver?MIval=aa-markerview.apg&OID=',
};


=head3 get_ext_link

Get an external link from the library

	my $link = IMG::Views::Links::get_ext_link( 'pubmed', '81274414' );
	# $link = http://www.ncbi.nlm.nih.gov/pubm40ted/81274414

@param  $target - the name of the link in the hash above
@param  $id     - any other params (optional)

@return $link   - text string that forms the link

=cut

sub get_ext_link {
	my $target = shift;
	return '' unless $external_links->{$target};

	# simple string; append any arguments to it
	if ( ! ref $external_links->{$target} ) {
		return $external_links->{$target} . ( $_[0] || "" );
	}
	# otherwise, it's a coderef
	elsif ( ref $external_links eq 'CODE' ) {
		return $external_links->{$target}->( @_ );
	}
	return '';
}

1;

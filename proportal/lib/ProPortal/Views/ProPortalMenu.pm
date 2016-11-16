package ProPortal::Views::ProPortalMenu;

use IMG::Util::Base 'MooRole';

with 'IMG::App::Role::MenuManager';

=pod

=encoding UTF-8

=head1 NAME

ProPortal::Views::Menu - navigation-related functionality

=head1 VERSION

version 0.01

=head1 SYNOPSIS

	# given the application config, a page ID, and optionally a menu group, create a menu data structure to be rendered by menu.tt and nav.tt

	my $menu = ProPortal::Views::Menu::get_menus( $config, $menu_grp, $page_id );

=head1 DESCRIPTION

ProPortal::Views::Menu holds a data structure representing the ProPortal menu system.

=head3 _get_menu_items {

Returns a data structure representing the menu. This can be overridden by site-specific menu structures.

=cut

sub _get_menu_items {
	my $self = shift;
	return [
# 		proportal(),
# 		genomes(),
# 		genes(),
# 		functions(),
# 		compare_genomes(),
# 		omics(),
# 		using(),
# 		$self->my_img,
#		datamarts(),

		home(),
		browse(),
		search(),
		tools(),
		$self->my_img(),
		support(),
		cart(),
	];

}


sub home {
	return {
		id => 'home'
	};
}

sub browse {
	return {
		id => 'menu/proportal',
		submenu =>
		[
			'proportal/clade',
			'proportal/data_type',
			'proportal/location',
			'proportal/ecosystem',
			'proportal/ecotype',
			'proportal/phylogram',
		],
	};
}

sub search {
	return {
		id => 'menu/search',
		submenu => [
			'search/blast',
			'search/advanced_search'
		],
	};
}

sub tools {
	return {
		id => 'menu/tools',
		submenu => [
			'phyloviewer',
			'tools/jbrowse',
			'tools/krona',
			'galaxy',
		],
	};
}

sub my_img {
	my $self = shift;
	# logged in user?
	if ( $self->has_user ) {
		return {
			id => 'menu/MyIMG',
			submenu =>
			[	'MyIMG/preferences',

				id => 'menu/Workspace',
				submenu =>
				[
					'Workspace', # label => 'Export Workspace' },
					'WorkspaceGeneSet',
					'WorkspaceFuncSet',
					'WorkspaceGenomeSet',
					'WorkspaceScafSet',
				],
			]
		};
	}

	return {
		id => 'menu/MyIMG',
		submenu =>
		[	'MyIMG/preferences',
			'login'
		]
	};
}

sub support {
	return {
		id => 'menu/support',
		submenu => [
			'support/about',
			'support/user_guide',
			'support/news',
 		],
	};
}

sub cart {
	return {
# 		id => 'cart',
# 		submenu => [
# 			'cart/genomes',
# 			'cart/genes',
# 			'cart/functions',
# 			'cart/scaffolds',
# 		],
		id => 'menu/cart',
		submenu =>
		[
			'GeneCartStor',
			'FuncCartStor',
			'GenomeCart',
			'ScaffoldCart',
		],
	};
}




sub proportal {

	return {
		id => 'proportal',
		submenu =>
		[
			'proportal/clade',
			'proportal/data_type',
			'proportal/location',
			'proportal/ecosystem',
			'proportal/ecotype',
			'proportal/phylogram',
			'galaxy',
		],
	};
}

sub genomes {

	return {
		id => 'menu/FindGenomes',
		submenu =>
		[
			'TreeFile',
			'FindGenomes',
#			'TaxonDeleted',
			'ScaffoldSearch',
		],
	};
}

sub genes {

	return {
		id => 'menu/FindGenes',
		submenu =>
		[
			'FindGenes/findGenes',
			'FindGenes/geneSearch',
			'GeneCassetteSearch',
			'FindGenesBlast',
			{	id => 'menu/cassetteProfilers',
				submenu =>
				[
					'PhylogenProfiler',
					'GeneCassetteProfiler',
				],
			}
		],
	};
}

sub functions {

	return {
		id => 'menu/FindFunctions',
		submenu =>
		[
			'FindFunctions/findFunctions',
			'AllPwayBrowser',

			{	id => 'menu/COG',
				submenu =>
				[
					'FindFunctions/ffoAllCogCategories',
					'FindFunctions/cogList',
					'FindFunctions/cogList/stats',
					'FindFunctions/cogid2cat',
				],
			},
			{	id => 'menu/KOG',
				submenu =>
				[
					'FindFunctions/ffoAllKogCategories',
					'FindFunctions/kogList',
					'FindFunctions/kogList/stats',
				],
			},
			{	id => 'menu/Pfam',
				submenu =>
				[
					'FindFunctions/pfamCategories',
					'FindFunctions/pfamList',
					'FindFunctions/pfamList/stats',
					'FindFunctions/pfamListClans',
				],
			},
			{	id => 'menu/TIGRfam',
				submenu =>
				[
					'TigrBrowser/tigrBrowser',
					'TigrBrowser/tigrfamList',
					'TigrBrowser/tigrfamList/stats',
				],
			},
			{	id => 'menu/TC',
				submenu =>
				[
					'FindFunctions/ffoAllTc',
					'FindFunctions/tcList',
				],
			},
			{	id => 'menu/KEGG',
				submenu =>
				[
					'FindFunctions/ffoAllKeggPathways/brite',
					'FindFunctions/ffoAllKeggPathways/ko',
				],
			},
			{	id => 'menu/IMGNetworks',
				submenu =>
				[
					'ImgNetworkBrowser',
					'ImgPartsListBrowser',
					'ImgPwayBrowser',
					'ImgTermBrowser',
				],
			},
			'FindFunctions/enzymeList',
			'ImgPwayBrowser/phenoRules',
			'Interpro',
		],
	};
}

sub compare_genomes {

	return {
		id => 'menu/CompareGenomes',
		submenu =>
		[
			'CompareGenomes',
			{	id => 'menu/SyntenyViewers',
				submenu =>
				[
					'Vista',
					'DotPlot',
					'Artemis',
				],
			},
			{	id => 'menu/AbundanceProfiles',
				submenu =>
				[
					'AbundanceProfiles',
					'AbundanceProfileSearch',
					'AbundanceComparisons',
					'AbundanceComparisonsSub',
				],
			},
			{	id => 'menu/PhylogeneticDistribution',
				submenu =>
				[
					'MetagPhyloDist',
					'GenomeHits',
					'RadialPhyloTree',
				],
			},

			{	id => 'menu/ani',
				submenu =>
				[
					'ANI/pairwise',
					'ANI/doSameSpeciesPlot',
					'ANI/overview',
				],
			},
			'DistanceTree',
			'FunctionProfiler',
			'EgtCluster',
			'GenomeGeneOrtholog',
			'PhyloCogs',
		],
	};
}

sub omics {

	return {
		id => 'menu/omics',
		submenu =>
		[
			'ImgStatsOverview',
			'IMGProteins',
			'RNAStudies',
			'Methylomics',
		],
	};
}

sub abc {

	return {
		id => 'menu/abc',
		submenu =>
		[

			'ABC',

			'BcNpIDSearch',
			'BiosyntheticStats',
			'BcSearch/bcSearch',
			'NaturalProd',
			'BcSearch/npSearches',
		],
	};
}

sub workspace {
	return {
		id => 'menu/Workspace',
		submenu =>
		[
			'Workspace', # label => 'Export Workspace' },
			'WorkspaceGeneSet',
			'WorkspaceFuncSet',
			'WorkspaceGenomeSet',
			'WorkspaceScafSet',
		],
	};
}

sub my_img_expanded {
	my $self = shift;

	my $core_menu = {
		id => 'menu/MyIMG',
		submenu =>
		[
			{
				id => 'menu/cart',
				submenu =>
				[
					'GeneCartStor',
					'FuncCartStor',
					'GenomeCart',
					'ScaffoldCart',
				],
			},
			'MyIMG/preferences',
		]
	};

	# logged in
	if ( $self->has_user ) {
		# show workspace links
		for ( 'MyIMG/myAnnotationsForm', 'MyIMG/myJobForm', workspace(), 'logout' ) {
			push @{$core_menu->{submenu}}, $_;
		}
	}

	return $core_menu;

}


sub datamarts {

	return {
		id => 'menu/DataMarts',
		submenu =>
		[
			{ 	id => 'menu/isolates',
				submenu =>
				[ qw(
					w
					er
					edu
				)],
			},
			{ 	id => 'menu/metagenomes',
				submenu =>
				[ qw(
					m
					mer
					hmpm
				)],
			},
			'abc',
			'submit'
		],
	};
}

sub using {

	return {
		id => 'menu/UsingIMG',
		submenu =>
		[
			{	id => 'menu/About',
				submenu =>
				[	'about/mer',
					'about/faq',
					'about/cite',
					'about/credits',
					'about/publications',
					'about/links',
					'about/documents',
				],
			},
			{ 	id => 'menu/UserGuide',
				submenu =>
				[
					'about/systemreqs',
					'about/tutorial',
					'about/workshop',
					'about/user_forum',
				],
			},
			{	id => 'menu/Downloads',
				submenu =>
				[
					'Help/policypage',
					{ abs_url => 'http://jgi.doe.gov/data-and-tools/data-management-policy-practices-resources/', label => 'Data Management Policy' },
					{ abs_url => 'http://jgi.doe.gov/collaborate-with-jgi/pmo-overview/policies/', label => 'Collaborate with JGI' },
					{ abs_url => 'https://groups.google.com/a/lbl.gov/d/msg/img-user-forum/o4Pjc_GV1js/EazHPcCk1hoJ', label => 'How to download' },
					{ abs_url => 'http://genome.jgi-psf.org/', label => 'JGI Genome Portal' },
				],
			},
			'about/contact'
		],
	};
}


1;

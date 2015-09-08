package IMG::Views::Menu;

use IMG::Util::Base;
use IMG::Views::Links;
use Role::Tiny;

my $url = {
	main_cgi_url => 'http://localhost/',
	server => 'http://img.jgi.doe.gov/',
	img_google_site => 'https://sites.google.com/a/lbl.gov/img-form/',
};

=head3 get_menus

Get the page menus

@param  $cfg     - config, e.g. from webEnv()
@param  $section - the section of the menu to display in the left-hand nav

@output hashref with structure
        menu_bar    => { data structure representing the menu bar }
        section_nav => {

=cut

sub get_menus {
	my $cfg = shift;
	my $section = shift;
#	say "cfg: " . Dumper $cfg;
	$url->{main_cgi_url} = $cfg->{main_cgi_url} if $cfg->{main_cgi_url};

	if (! $section || $self->can( $section ) ) {
		carp "menu section $section does not exist!";
		return { menu_bar => $self->img_menu_bar };
	}

	return {
		menu_bar => $self->img_menu_bar,
		section_nav => $self->$section,
	};

}

sub make_menus {

	my $cfg = shift;
	my $page = shift; # current page
	my $section = get_group( $page );

	# get the menu structures and populate the links
	my $menus = get_menu_items();
	for my $m ( @$menus ) {
		populate_links( $m );


	}
}


sub populate_links {
	my $data_struct = shift;

	for my $i ( @$data_struct ) {
		# scalar:
		if ( ! ref $i ) {
			get_link( $i );

=head3 img_menu_bar

Generate a data structure representing the IMG horizontal menu bar

This gets rendered by Template::Toolkit

=cut

sub img_menu_bar {

	my $cfg = shift;

	my $menu = {
		L => [
			$self->home,
			$self->genomes,
			$self->genes,
			$self->functions,
			$self->compare_genomes,
			$self->analysis,
			$self->omics,
			$self->abc,
			$self->datamarts,
		],
		R => [
			$self->my_img,
			$self->using,
		]
	};
}

sub home {
	return {
		{ title => 'Home', url => $cfg->{base_url} }
	};
}

sub genomes {

	return {
		title => "Find Genomes",
		submenu =>
		[
			'TreeFile',
			'FindGenomes',
			'TaxonDeleted',
			'ScaffoldSearch',
		],
	};
}

sub genes {

	return {
		title => "Find Genes"
		submenu =>
		[
			'FindGenes/findGenes',
			'FindGenes/geneSearch',
			'GeneCassetteSearch',
			'FindGenesBlast',
			{	title => 'Gene Cassette Profilers',
				submenu =>
				[
					'GeneCassetteProfiler/genetools' -- ????
					'PhylogenProfiler',
					'GeneCassetteProfiler/geneContextPhyloProfiler2' (gene_cassettes),
				],
			}
		],
	};
}

sub functions {

	return {
		title => "Find Functions",
		submenu =>
		[
			'FindFunctions/findFunctions',
			'AllPwayBrowser',
			{	title => 'COG',
				submenu =>
				[
					'FindFunctions/ffoAllCogCategories',
					'FindFunctions/cogList',
					'FindFunctions/cogList/stats',
					'FindFunctions/cogid2cat',
				],
			},
			{	title => 'KOG',
				submenu =>
				[
					'FindFunctions/ffoAllKogCategories',
					'FindFunctions/kogList',
					'FindFunctions/kogList/stats',
				],
			},
			{	title => 'Pfam',
				submenu =>
				[
					'FindFunctions/pfamCategories',
					'FindFunctions/pfamList',
					'FindFunctions/pfamList/stats',
					'FindFunctions/pfamListClans',
				],
			},
			{	title => 'TIGRfam',
				submenu =>
				[
					'TigrBrowser/tigrBrowser',
					'TigrBrowser/tigrfamList',
					'TigrBrowser/tigrfamList/stats',
				],
			},
			{	title => 'Transporter Classification (TC)',
				submenu =>
				[
					'FindFunctions/ffoAllTc',
					'FindFunctions/tcList',
				],
			},
			{	title => 'KEGG',
				submenu =>
				[
					'FindFunctions/ffoAllKeggPathways/brite',
					'FindFunctions/ffoAllKeggPathways/ko',
				],
			},
			{	title => 'IMG Networks',
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
		title => 'CompareGenomes',
		submenu =>
		[
			'CompareGenomes',
			'Vista/toppage',
				submenu =>
				[
					'Vista/vista',
					'DotPlot',
					'Artemis',
				],
			},
			'AbundanceProfiles/topPage',
				submenu =>
				[
					'AbundanceProfiles/mergedForm',
					'AbundanceProfileSearch',
					'AbundanceComparisons',
					'AbundanceComparisonsSub',
				],
			},
			'MetagPhyloDist/top',
				submenu =>
				[
					'MetagPhyloDist/form',
					'GenomeHits',
					'RadialPhyloTree',
				],
			},

			'ANI',
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

sub analysis {

	return {
		title => 'Analysis Cart',
		submenu =>
		[
			'GeneCartStor',
			'FuncCartStor',
			'GenomeCart',
			'ScaffoldCart',
		],
	};
}

sub omics {

	return
	'ImgStatsOverview',
		submenu =>
		[
			'IMGProteins',
			'RNAStudies',
			'Methylomics',
		],
	};
}

sub abc {

	return
	'ABC',
		submenu =>
		[
			'BcNpIDSearch',
			'BiosyntheticStats',
			'BcSearch/bcSearch',
			'NaturalProd',
			'BcSearch/npSearches',
		],
	};
}


sub my_img {

	return

	'MyIMG',
		submenu =>
		[
			'MyIMG/home',
			'MyIMG/myAnnotationsForm',
			'MyIMG/myJobForm',
			'MyIMG/preferences',
			{
				title => 'Workspace'
				submenu =>
				[
					'Workspace', label => 'Export Workspace' },
					'WorkspaceGeneSet',
					'WorkspaceFuncSet',
					'WorkspaceGenomeSet',
					'WorkspaceScafSet',
				],
			},
			'Logout',
		],
	};
}


sub datamarts {

	return
	{ url => 'http://img.jgi.doe.gov/', label => 'Data Marts',
		submenu =>
		[
			{ url => $url->{server} . '/w', title => 'IMG isolates', label => 'IMG',
				submenu =>
				[
					{ url => $url->{server} . '/w', label => 'IMG' },
					{ url => $url->{server} . '/er', title => 'IMG Expert Review', label => '<abbr title="IMG Expert Review">IMG ER</abbr>' },
					{ url => $url->{server} . '/edu', title => 'IMG Education', label => '<abbr title="IMG Education">IMG EDU</abbr>' },
				],
			},
			{ url => $url->{server} . '/m', title => 'IMG Metagenomes', label => '<abbr title="IMG Metagenomes">IMG M</abbr>',
				submenu =>
				[
					{ url => $url->{server} . '/m', title => 'IMG Metagenomes', label => '<abbr title="IMG Metagenomes">IMG M</abbr>' },
					{ url => $url->{server} . '/mer/', title => 'Expert Review', label => '<abbr title="IMG Metagenome Expert Review">IMG MER</abbr>' },
					{ url => 'https://img.jgi.doe.gov/cgi-bin/imgm_hmp/main.cgi', title => 'Human Microbiome Project Metagenomes', label => '<abbr title="Human Microbiome Project Metagenome">IMG HMP M</abbr>' },
				],
			},
			{ url => '/abc', label => 'IMG ABC' },
			{ url => 'https://img.jgi.doe.gov/submit', label => 'Submit Data Set' },
		],
	};
}

sub using {

return
	{ url => $url->{server} . '/mer/doc/about_index.html', label => 'Using IMG',
		submenu =>
		[
			{ url => $url->{server} . '/mer/doc/about_index.html', title => 'Information about IMG', label => 'About IMG/M ER',
				submenu =>
				[
					{ url => 'https://img.jgi.doe.gov/#IMGMission', label => 'IMG Mission' },
					{ url => $url->{img_google_site} . 'faq', title => 'Frequently Asked Questions', label => 'FAQ' },
					{ url => $url->{img_google_site} . 'using-img/related-links', label => 'Related Links' },
					{ url => $url->{img_google_site} . 'using-img/credits', label => 'Credits' },
					{ url => $url->{img_google_site} . 'documents', title => 'documents', label => 'IMG Document Archive' },
				],
			},
			{ url => $url->{server} . '/mer/doc/using_index.html', label => 'User Guide',
				submenu =>
				[
					{ url => $url->{server} . '/mer/doc/systemreqs.html', label => 'System Requirements' },
					'Help', title => 'Contains links to all menu pages and documents', label => 'Site Map' },
					{ url => $url->{img_google_site} . 'using-img/tutorial', label => 'Tutorial' },
					{ url => $url->{server} . '/mer/doc/images/uiMap.pdf', label => 'User Interface Map' },
					{ url => $url->{server} . '/mer/doc/SingleCellDataDecontamination.pdf', label => 'Single Cell Data Decontamination' },
					{ url => $url->{server} . '/mer/doc/userGuide_m.pdf', title => 'User Manual IMG/M Addendum', label => 'IMG/M Addendum' },
				],
			},
			'Help/policypage', label => 'Downloads',
				submenu =>
				[
					'Help/policypage', label => 'Data Usage Policy' },
					{ url => 'http://jgi.doe.gov/data-and-tools/data-management-policy-practices-resources/', label => 'Data Management Policy' },
					{ url => 'http://jgi.doe.gov/collaborate-with-jgi/pmo-overview/policies/', label => 'Collaborate with JGI' },
					{ url => 'https://groups.google.com/a/lbl.gov/d/msg/img-user-forum/o4Pjc_GV1js/EazHPcCk1hoJ', label => 'How to download' },
					{ url => 'http://genome.jgi-psf.org/', label => 'JGI Genome Portal' },
				],
			},
			{ url => $url->{img_google_site} . 'using-img/citation', label => 'Citation' },
			{ url => $url->{server} . '/mer/doc/MGAandDI_SOP.pdf', title => 'Microbial Genome Annotation &amp; Data Integration SOP', label => 'Genome Annotation SOP' },
			{ url => $url->{server} . '/mer/doc/MetagenomeAnnotationSOP.pdf', title => 'Metagenome Annotation &amp; SOP for IMG', label => 'Metagenome SOP' },
			{ url => $url->{server} . '/mer/doc/education.html', label => 'Education' },
			{ url => $url->{img_google_site} . 'using-img/publication', label => 'Publications' },
			{ url => 'http://www.jgi.doe.gov/meetings/mgm/', label => 'MGM Workshop' },
			{ url => $url->{img_google_site} . 'questions', label => 'IMG User Forum' },
			{ url => $url->{main_cgi_url} . '?page=questions', title => 'Report bugs or issues', label => 'Report Bugs / Issues' },
			{ url => $url->{img_google_site} . 'contact-us', label => 'Contact us' },
			{ url => 'http://jgi.doe.gov/disclaimer/', label => 'Disclaimer' },
		],
	};
}


1;

package IMG::Views::Menu;

use IMG::Util::Base;
use IMG::Views::Links qw( get_link_data );
use Role::Tiny;

my $url = {
	main_cgi_url => 'http://localhost/',
	server => 'http://img.jgi.doe.gov/',
	img_google_site => 'https://sites.google.com/a/lbl.gov/img-form/',
	base_url     => 'http://localhost/',
};

sub init {
	my $config = shift // confess "init requires a configuration hash for URL generation";

	if (! ref $config || ref $config ne 'HASH' || ! $config->{main_cgi_url} || ! $config->{pp_app} ) {
		confess "init requires a configuration hash for URL generation";
	}
	for my $v ( qw( main_cgi_url server base_url ) ) {
		$url->{$v} = $config->{$v} if defined $config->{$v};
	}
	$url->{init_run} = 1;
	return;
}

=head3 get_menus

Get the page menus

@param  $config     - config, e.g. from webEnv()
@param  $section - the section of the menu to display in the left-hand nav

@output hashref with structure
        menu_bar    => { data structure representing the menu bar }
        section_nav => {

=cut

sub get_menus {
	my $config = shift;
	if ( ! $url->{init_run} ) {
		if ( not defined $config ) {
			confess "get_menus requires a configuration hash for URL generation";
		}
		init( $config );
	}

	my $section = shift;
	my $url = shift;

	if (! $section && ! $url ) { #|| $self->can( $section ) ) {
		warn "menu section does not exist!";
	#	return { menu_bar => $self->img_menu_bar };
		return { menu_bar => make_menus() };
	}

	my $grp = get_group( $section, $url );
	populate_links( $grp );
	return {
		menu_bar => make_menus(),
	#	menu_bar => $self->img_menu_bar,
		section_nav => $grp,
	};

}

sub make_menus {
	my $config = shift;
	if ( ! $url->{init_run} ) {
		if ( not defined $config ) {
			confess "make_menus requires a configuration hash for URL generation";
		}
		init( $config );
	}

	# get the menu structures and populate the links
	my $menus = get_menu_items();
#	say 'menus: ' . Dumper $menus;
	populate_links( $menus );
	return $menus;
}


sub populate_links {
	my $data_struct = shift;

	if ('ARRAY' eq ref $data_struct) {
		for my $i ( @$data_struct ) {
			# scalar: replace with the link data
			if ( ! ref $i ) {
				my $ld = get_link_data( $i );
				$ld->{id} = $i;
				if ( $ld->{url} && ref $ld->{url} && 'HASH' eq ref $ld->{url} ) {
					# turn it into a link
					my $link = $url->{main_cgi_url} . IMG::Views::Links::old_link_gen( $ld->{url} );
					$ld->{url} = $link;
				}
				$i = $ld;
			}
			else {
				if ( $i->{id} ) {
					my $data = get_link_data( $i->{id} );
					for (keys %$data) {
						$i->{$_} = $data->{$_};
					}
				}
				populate_links( $i->{submenu} ) if defined $i->{submenu};
			}
		}
	}
	elsif ('HASH' eq ref $data_struct) {
		if ( $data_struct->{id} ) {
			my $data = get_link_data( $data_struct->{id} );
			for (keys %$data) {
				$data_struct->{$_} = $data->{$_};
			}
		}
		populate_links( $data_struct->{submenu} ) if defined $data_struct->{submenu};
	}
}

sub get_subtree {

	my $struct = shift;

#	say 'struct: ' . Dumper $struct;

	my $menu_page = shift;
	if ( ref $struct && 'ARRAY' eq ref $struct ) {
		for ( @$struct ) {
			next unless ref $_;
			if ( $_->{id} && $menu_page eq $_->{id} ) {
				say 'found the thing I was looking for!';
				return $_;
			}
			my $results = get_subtree( $_->{submenu}, $menu_page ) if $_->{submenu};
			return $results if $results;
		}
	}
	return undef;
}


sub search_menu {
	my $id = shift // die 'No ID supplied';
	my $menus = get_menu_items();
	my $rslt = get_subtree( $menus, $id );
	if ( $rslt ) {
		populate_links( $rslt );
	}
	return $rslt;
}


sub find_parent_menu {
	my $id = shift // die 'No ID supplied';
	my $menus = get_menu_items();
	for my $m ( @$menus ) {
		my $rslt = get_subtree( [ $m ], $id );
		if ( $rslt ) {
			populate_links( $m );
			return $m;
		}
	}
	return;
}


sub get_group {
	my $section = shift;
	my $url = shift;

	say 'section: ' . ( '>>' . $section . '<<' || 'undefined' );

	my $mapping = {
		FindGenomes    => genomes(),
		FindGenes      => genes(),
		FindFunctions  => functions(),
		CompareGenomes => compare_genomes(),
		AnaCart        => analysis(),
		Methylomics    => omics(),
#		abc(),
		about          => using(),
		MyIMG          => my_img(),
		'/proportal'   => proportal(),
		proportal      => proportal(),
	};

	if ( defined $section && $mapping->{ $section } ) {
		say 'We definitely have this one!';
		return $mapping->{ $section };
	}
	else {
		if ( defined $url && $url =~ m!/menu/! ) {
			return find_parent_menu( $url );
		}
	}
	say 'but for some reason, we are not returning it!';
	return home();

}


sub get_menu_items {

	return [
#		home(),
		proportal(),
		genomes(),
		genes(),
		functions(),
		compare_genomes(),
		analysis(),
		omics(),
#		abc(),
		using(),
		my_img(),
		datamarts(),
	];

}

=head3 img_menu_bar

Generate a data structure representing the IMG horizontal menu bar

This gets rendered by Template::Toolkit

=cut

sub img_menu_bar {
#	my $self = shift;
	my $config = shift;

	my $menu = {
		L => [
			home(),
			genomes(),
			genes(),
			functions(),
			compare_genomes(),
			analysis(),
			omics(),
			abc(),
			datamarts(),
		],
		R => [
			using(),
			my_img(),
		]
	};
}

sub home {
	return {
		title => 'Home',
		url => $url->{base_url}
	};
}

sub proportal {

	return {
		id => 'proportal',
		submenu =>
		[
#			'proportal', # home page
			'proportal/clade',
			'proportal/data_type',
			'proportal/location',
			'proportal/phylogram',
			'proportal/phylo_heat',
		],
	};
}

sub genomes {

	return {
		id => '/menu/FindGenomes',
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
		id => '/menu/FindGenes',
		submenu =>
		[
			'FindGenes/findGenes',
			'FindGenes/geneSearch',
			'GeneCassetteSearch',
			'FindGenesBlast',
			{	id => '/menu/cassetteProfilers',
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
		id => '/menu/FindFunctions',
		submenu =>
		[
			'FindFunctions/findFunctions',
			'AllPwayBrowser',

			{	id => '/menu/COG',
				submenu =>
				[
					'FindFunctions/ffoAllCogCategories',
					'FindFunctions/cogList',
					'FindFunctions/cogList/stats',
					'FindFunctions/cogid2cat',
				],
			},
			{	id => '/menu/KOG',
				submenu =>
				[
					'FindFunctions/ffoAllKogCategories',
					'FindFunctions/kogList',
					'FindFunctions/kogList/stats',
				],
			},
			{	id => '/menu/Pfam',
				submenu =>
				[
					'FindFunctions/pfamCategories',
					'FindFunctions/pfamList',
					'FindFunctions/pfamList/stats',
					'FindFunctions/pfamListClans',
				],
			},
			{	id => '/menu/TIGRfam',
				submenu =>
				[
					'TigrBrowser/tigrBrowser',
					'TigrBrowser/tigrfamList',
					'TigrBrowser/tigrfamList/stats',
				],
			},
			{	id => '/menu/TC',
				submenu =>
				[
					'FindFunctions/ffoAllTc',
					'FindFunctions/tcList',
				],
			},
			{	id => '/menu/KEGG',
				submenu =>
				[
					'FindFunctions/ffoAllKeggPathways/brite',
					'FindFunctions/ffoAllKeggPathways/ko',
				],
			},
			{	id => '/menu/IMGNetworks',
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
		id => '/menu/CompareGenomes',
		submenu =>
		[
			'CompareGenomes',
			{	id => '/menu/SyntenyViewers',
				submenu =>
				[
					'Vista',
					'DotPlot',
					'Artemis',
				],
			},
			{	id => '/menu/AbundanceProfiles',
				submenu =>
				[
					'AbundanceProfiles',
					'AbundanceProfileSearch',
					'AbundanceComparisons',
					'AbundanceComparisonsSub',
				],
			},
			{	id => '/menu/PhylogeneticDistribution',
				submenu =>
				[
					'MetagPhyloDist',
					'GenomeHits',
					'RadialPhyloTree',
				],
			},

			{	id => '/menu/ani',
				submenu =>
				[
'ANI', #==> this page has content

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
		id => '/menu/cart',
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

	return {
		id => '/menu/omics',
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
		id => '/menu/abc',
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


sub my_img {

	return {
		id => '/menu/MyIMG',
		submenu =>
		[
			'MyIMG/home', # (same as MyIMG)
			'MyIMG/myAnnotationsForm',
			'MyIMG/myJobForm',
			'MyIMG/preferences',
			{
				id => '/menu/Workspace',
				submenu =>
				[
					'Workspace', # label => 'Export Workspace' },
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

	return {
		id => '/menu/DataMarts',
		submenu =>
		[
			{ 	id => '/menu/isolates',
				submenu =>
				[
					{ url => $url->{server} . '/w', label => 'IMG isolates' },
					{ url => $url->{server} . '/er', title => 'IMG Expert Review', label => '<abbr title="IMG Expert Review">IMG ER</abbr>' },
					{ url => $url->{server} . '/edu', title => 'IMG Education', label => '<abbr title="IMG Education">IMG EDU</abbr>' },
				],
			},
			{ 	id => '/menu/metagenomes',
				submenu =>
				[
					{ url => $url->{server} . '/m', title => 'IMG Metagenomes', label => '<abbr title="IMG Metagenomes">IMG M</abbr>' },
					{ url => $url->{server} . '/mer/', title => 'Expert Review', label => '<abbr title="IMG Metagenome Expert Review">IMG MER</abbr>' },
					{ url => 'https://img.jgi.doe.gov/cgi-bin/imgm_hmp/main.cgi', title => 'Human Microbiome Project Metagenomes', label => '<abbr title="Human Microbiome Project Metagenome">IMG HMP M</abbr>' },
				],
			},
			{ url => $url->{server} . '/abc', label => 'IMG ABC' },
			{ url => $url->{server} . '/submit', label => 'Submit Data Set' },
		],
	};
}

sub using {

	return {
		id => '/menu/UsingIMG',
		submenu =>
		[
			{	id => '/menu/About',
				submenu =>
				[
					{ url => $url->{server} . '/mer/doc/about_index.html', title => 'Information about IMG', label => 'About IMG/M ER', },
					{ url => $url->{server} . '/#IMGMission', label => 'IMG Mission' },
					{ url => $url->{img_google_site} . 'faq', title => 'Frequently Asked Questions', label => 'FAQ' },
					{ url => $url->{img_google_site} . 'using-img/related-links', label => 'Related Links' },
					{ url => $url->{img_google_site} . 'using-img/credits', label => 'Credits' },
					{ url => $url->{img_google_site} . 'documents', title => 'documents', label => 'IMG Document Archive' },
				],
			},
			{ 	id => '/menu/UserGuide',
				submenu =>
				[
					{ url => $url->{server} . '/mer/doc/systemreqs.html', label => 'System Requirements' },
					'Help',
					{ url => $url->{img_google_site} . 'using-img/tutorial', label => 'Tutorial' },
					{ url => $url->{server} . '/mer/doc/images/uiMap.pdf', label => 'User Interface Map' },
					{ url => $url->{server} . '/mer/doc/SingleCellDataDecontamination.pdf', label => 'Single Cell Data Decontamination' },
					{ url => $url->{server} . '/mer/doc/userGuide_m.pdf', title => 'User Manual IMG/M Addendum', label => 'IMG/M Addendum' },
				],
			},
			{	id => '/menu/Downloads',
				submenu =>
				[
					'Help/policypage',
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
			'Questions',
			{ url => $url->{img_google_site} . 'contact-us', label => 'Contact us' },
			{ url => 'http://jgi.doe.gov/disclaimer/', label => 'Disclaimer' },
		],
	};
}


1;

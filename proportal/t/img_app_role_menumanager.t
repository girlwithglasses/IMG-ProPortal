#!/usr/bin/env perl

BEGIN {
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	my $dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	our @dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib proportal/t/lib );
}
use lib @dir_arr;
use IMG::Util::Import 'Test';

{	package TestMenu;
	use IMG::Util::Import 'MooRole';
	with 'IMG::App::Role::MenuManager';

	sub _get_menu_items {

		return [
			functions(),
			my_img(),
		];
	}

	sub functions {

		return {
			id => 'menu/FindFunctions',
			submenu =>
			[
				'FindFunctions/findFunctions',
				'AllPwayBrowser',
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
						{	id => 'ANI/pairwise',
							submenu => [
								'ANI/overview',
								'ANI/doSameSpeciesPlot'
							]
						},
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

	sub my_img {
		return {
			id => 'menu/MyIMG',
			submenu =>
			[
				'MyIMG/home', # (same as MyIMG)
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
				'MyIMG/myAnnotationsForm',
				'MyIMG/myJobForm',
				{
					id => 'menu/Workspace',
					submenu =>
					[
						'Workspace', # label => 'Export Workspace' },
						'WorkspaceGeneSet',
						'WorkspaceFuncSet',
						'WorkspaceGenomeSet',
						'WorkspaceScafSet',
					],
				},
				'logout',
			],
		};
	}

	1;
}

{	package CrapApp;
	use IMG::Util::Import 'Class';
	has config => ( is => 'ro' );
	with 'IMG::App::Role::MenuManager';
	1;
}

{	package TestApp;
	use IMG::Util::Import 'Class';
	has config => ( is => 'ro' );
	with 'TestMenu', 'IMG::App::Role::MenuManager';

	1;
}

sub recurse {
	my $ds = shift;
	my $fn = shift;
	my $c = shift // {};
	if ( 'ARRAY' eq ref $ds  ) {
		for ( @$ds ) {
			$c = recurse( $_, $fn, $c )
		}
	}
	elsif ( 'HASH' eq ref $ds ) {
		if ( $ds->{submenu} ) {
			$c = recurse( $ds->{submenu}, $fn, $c );
		}
		$c = $fn->( $ds, $c );
	}
#	say 'collect now: ' . Dumper $c;
	return $c;
}

my $cfg = { base_url => 'http://test.com', main_cgi_url => 'http://test.com/x.cgi' };

use_ok( 'IMG::App::Role::MenuManager' );

subtest 'hapless app' => sub {

	my $app = CrapApp->new( config => $cfg );

	throws_ok { $app->get_menu_items } qr[CrapApp is missing required method _get_menu_items];

};

my ( $rtn, $app, $menu, $rslt );

subtest 'checking make_menu' => sub {

	$app = TestApp->new( config => $cfg );
	my $get_classes = sub {
		my $s = shift;
		my $c = shift;
		if ( $s->{class} ) {
			$c->{ $s->{class} }{ $s->{id} }++;
		}
		return $c;
	};

	subtest 'get_menu_items' => sub {
		$rtn = $app->get_menu_items;
		ok( defined $rtn && ref $rtn eq 'ARRAY' );
	};

	subtest 'zero' => sub {
		$rtn = $app->make_menu;
		$menu = $rtn->{menu};
		is( ref $menu, 'ARRAY', 'checking we get an arrayref back' );

		is_deeply( {}, recurse( $menu, $get_classes ), 'Checking there are no classes' );
	};

	subtest 'one' => sub {
		$rtn = $app->make_menu({ group => 'proportal', page => 'proportal/location' });
		$menu = $rtn->{menu};
		is_deeply( {}, recurse( $menu, $get_classes ), 'Checking there are no classes' );
	};

	subtest 'two' => sub {
		$rtn = $app->make_menu({ group => undef, page => 'MyIMG/preferences' });
		$menu = $rtn->{menu};
		$rslt = recurse( $menu, $get_classes );

		ok( defined $rslt && defined $rslt->{current} && 1 == scalar keys %{$rslt->{current}}, 'we have the current class!' ) or diag explain $rslt;
		ok( defined $rslt->{current}{'MyIMG/preferences'} && 1 == $rslt->{current}{'MyIMG/preferences'}, 'We have the correct current page') or diag explain $rslt;

		ok( defined $rslt->{parent} && 'menu/MyIMG' eq join( '__', sort keys %{$rslt->{parent}} ), 'Checking parents are correct' ) or diag explain $rslt;
	};

	subtest 'three' => sub {
		$rtn = $app->make_menu({ group => undef, page => 'FindFunctions/ffoAllTc' });
		$menu = $rtn->{menu};
		$rslt = recurse( $menu, $get_classes );
		ok( defined $rslt && defined $rslt->{current} && 1 == scalar keys %{$rslt->{current}}, 'we have the current class!' ) or diag explain $rslt;

		ok( defined $rslt->{current}{'FindFunctions/ffoAllTc'} &&  1 == $rslt->{current}{'FindFunctions/ffoAllTc'}, 'We have the correct current page') or diag explain $rslt;

		ok( defined $rslt->{parent} && 'menu/FindFunctions__menu/TC' eq join ( "__", sort keys %{$rslt->{parent}} ), 'Checking that the parents are correct' ) or diag explain $rslt;
	};

	subtest 'four' => sub {
		$rtn = $app->make_menu({ group => undef, page => 'ANI/doSameSpeciesPlot' });
		$menu = $rtn->{menu};
		$rslt = recurse( $menu, $get_classes );
		ok( defined $rslt && defined $rslt->{current} && 1 == scalar keys %{$rslt->{current}} && defined $rslt->{current}{'ANI/doSameSpeciesPlot'}, 'Checking we have the correct current' ) or diag explain $rslt;

		ok( defined $rslt->{parent} && 'ANI/pairwise__menu/FindFunctions__menu/KEGG' eq join ( "__", sort keys %{$rslt->{parent}} ), 'Checking that the parents are correct' ) or diag explain $rslt;
	};
};


done_testing();

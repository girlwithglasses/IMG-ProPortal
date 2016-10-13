#!/usr/bin/env perl

my $dir;
my @dir_arr;

BEGIN {
	$ENV{'DANCER_ENVIRONMENT'} = 'testing';
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	$dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib proportal/t/lib );
}

use lib @dir_arr;
use IMG::Util::Base 'Test';
use Dancer2;
use ProPortalTestData;

use IMG::App;
use AppCore;
use ProPortal::Controller::PhyloViewer::Pipeline;
use ProPortal::Controller::PhyloViewer::DemoData;
use Bio::SeqIO;
use Bio::Seq;

{
	package TestApp;
	use IMG::Util::Base 'Class';
	extends 'IMG::App';
	with qw( ProPortal::IO::DBIxDataModel ProPortal::Controller::PhyloViewer::Pipeline );
	1;
}

my $msg;
my $cfg = config;
$cfg->{web_data_dir} = catdir( $dir, 'proportal/t/files/img_web_data' );

my $app = TestApp->new( config => $cfg );

my $args = script_prep();

say 'config: ' . Dumper $app->config;

subtest 'get_metadata_for_taxa' => sub {

	subtest 'error states' => sub {
		# no input
		$msg = err({
			err => 'missing',
			subject => 'taxon_oids'
		});

		throws_ok {
			$app->get_metadata_for_taxa({});
		} qr[$msg];

		throws_ok {
			$app->get_metadata_for_taxa({ taxon_oid => [] });
		} qr[$msg];

		# no results
		$msg = err({
			err => 'no_results',
			subject => 'taxon_oids'
		});
		throws_ok {
			$app->get_metadata_for_taxa({ taxon_oid => [ 'abc', 'def', 'ghi' ] });
		} qr[$msg];

		# missing results
		$msg = err({
			err => 'missing_results',
			subject => 'taxon_oids',
			ids => [ 666, 911 ]
		});
		throws_ok {
			$app->get_metadata_for_taxa({
				taxon_oid => [ @{tax_arr()}, 666, 911 ]
			});
		} qr[$msg];

	};

	subtest 'valid' => sub {
		my $rslts = $app->get_metadata_for_taxa({ taxon_oid => tax_arr() });
		my $expected = [ sort @{tax_arr()} ];
		ok( scalar @$rslts == scalar @{ tax_arr() }, 'checking get_metadata_for_taxa results' );
		my $got = [ sort map { $_->{taxon_oid} } @$rslts ];
		is_deeply( $got, $expected, 'TODO') or diag explain $got, $expected;
	};
};


subtest 'get_taxon_oid_for_genes' => sub {

	subtest 'error states' => sub {

		$msg = err({
			err => 'missing',
			subject => 'gene_oids'
		});

		throws_ok {
			$app->get_taxon_oid_for_genes();
		} qr[$msg];

		throws_ok {
			$app->get_taxon_oid_for_genes({ gene_oid => [] });
		} qr[$msg];


		$msg = err({
			err => 'no_results',
			subject => 'gene_oids'
		});
		throws_ok {
			$app->get_taxon_oid_for_genes({ gene_oid => [ 'abcde', 'bcdef' ] });
		} qr[$msg];


		# some results missing
		$msg = err({
			err => 'missing_results',
			subject => 'gene_oids',
			ids => [ 666 ]
		});
		throws_ok {
			$app->get_taxon_oid_for_genes({ gene_oid => [ 637449936, 637686988, 637686994, 666, 640078650 ] });
		} qr[$msg];
	};

	subtest 'valid' => sub {
		my $got = [
			sort { $a->{gene_oid} <=> $b->{gene_oid} }
			map {
				TestUtils::clean_db_output($_);
				$_ = { gene_oid => $_->{gene_oid}, taxon_oid => $_->{taxon_oid} };
			}
			@{$app->get_taxon_oid_for_genes({
				gene_oid => [ 637449936, 637686988, 637686994, 640078650 ]
			})}
		];
		my $expected = [
			{ gene_oid => 637449936, taxon_oid => 637000214 },
			{ gene_oid => 637686988, taxon_oid => 637000212 },
			{ gene_oid => 637686994, taxon_oid => 637000212 },
			{ gene_oid => 640078650, taxon_oid => 640069321 }];
		is_deeply( $got, $expected, 'Checking query returned valid results') or diag explain $got, $expected;
	};
};


subtest 'create FASTA file' => sub {

	my $app = TestApp->new( config => $cfg );
	my ($fh, $file) = tempfile( UNLINK => 1 );
	my ($fh1, $file1) = tempfile( UNLINK => 1 );


	subtest 'error states' => sub {

		# Error state: sequence type does not exist
		$msg = err({
			err => 'invalid',
			subject => 'blob',
			type => 'sequence type'
		});
		throws_ok {
			$app->create_FASTA_file({
				seq_type => 'blob'
			});
		} qr[$msg];

		# no gene IDs
		$msg = err({
			err => 'missing',
			subject => 'gene IDs'
		});
		throws_ok {
			$app->create_FASTA_file({
				seq_type => 'fna'
			});
		} qr[$msg];

		throws_ok {
			$app->create_FASTA_file({
				seq_type => 'fna', gp_arr => [], fh => $fh
			});
		} qr[$msg];

		# all have failed!
		$msg = err({
			err => 'no_results',
			subject => 'sequences'
		});
		my $gp_ref_3 = [
	{ gene_oid => 1, taxon_oid => 637000214, ext_acc => "NC_005072" },
	{ gene_oid => 2, taxon_oid => 637000212, ext_acc => "NC_007335" },
	{ gene_oid => 3, taxon_oid => 637000212, ext_acc => "NC_007335" },
	{ gene_oid => 4, taxon_oid => 640069321, ext_acc => "NC_008816" },
	{ gene_oid => 5, taxon_oid => 640069321, ext_acc => "NC_008816" },
		];

		throws_ok {
			$app->create_FASTA_file({
				seq_type => 'fna',
				gp_arr => $gp_ref_3,
				fh => $fh
			})
		} qr[$msg];

		$msg = err({
			err => 'missing_results',
			subject => 'sequences',
			ids => [ 666 ]
		});

		my $gp_ref_2 = [
	{ gene_oid => 637449936, taxon_oid => 637000214, ext_acc => "NC_005072" },
	{ gene_oid => 637686988, taxon_oid => 637000212, ext_acc => "NC_007335" },
	{ gene_oid => 637686994, taxon_oid => 637000212, ext_acc => "NC_007335" },
	{ gene_oid => 666,       taxon_oid => 640069321, ext_acc => "NC_008816" },
	{ gene_oid => 640078650, taxon_oid => 640069321, ext_acc => "NC_008816" },
		];

		# gene_oid 666 does not exist
		throws_ok {
			$app->create_FASTA_file({
				seq_type =>  'fna', gp_arr => $gp_ref_2, fh => $fh
			});
		} qr[$msg];

		$msg = err({
			err => 'missing',
			subject => 'combined FASTA file'
		});
		throws_ok {
			$app->create_FASTA_file({
				seq_type => 'fna', gp_arr => $gp_ref_2
			});
		} qr[$msg];

	};

# Valid input
# TODO: add an faa test!
	subtest 'valid' => sub {
		my $gp_ref = [
	{ gene_oid => 637449936, taxon_oid => 637000214, ext_acc => "NC_005072" },
	{ gene_oid => 637686988, taxon_oid => 637000212, ext_acc => "NC_007335" },
	{ gene_oid => 637686994, taxon_oid => 637000212, ext_acc => "NC_007335" },
	{ gene_oid => 640078650, taxon_oid => 640069321, ext_acc => "NC_008816" },
		];

		ok( $app->create_FASTA_file({
			seq_type => 'fna', gp_arr => $gp_ref, file => $file
		}) == 1, 'checking for success' );

		my $got = fasta_hash_from_input({ -file => $file });

		my $result = fasta_hash_from_input({ -string => all_results() });

		is_deeply( $got, $result, 'Got sequences correctly');

		# use a file handle instead
		ok( $app->create_FASTA_file({
			seq_type => 'fna', gp_arr => $gp_ref, fh => $fh1
		}) == 1, 'checking for success' );

		is_deeply(
			fasta_hash_from_input({ -file => $file1 }),
			$result,
			'Got FH sequences correctly'
		);
	};


};

subtest 'write_gene_taxon_file' => sub {

	subtest 'error states' => sub {

		$msg = err({
			err => 'not_writable',
			subject => $args->{read_only_file}
		});

		throws_ok {
			$app->write_gene_taxon_file({
				file => $args->{read_only_file},
				gp_arr => $args->{gp_arr} });
		} qr[$msg];

		$msg = err({
			err => 'missing',
			subject => 'gene taxon file'
		});
		throws_ok {
			$app->write_gene_taxon_file({ gp_arr => [ 1, 2, 3 ] });
		} qr[$msg];

		$msg = err({
			err => 'missing',
			subject => 'gene and taxon data'
		});
		throws_ok {
			$app->write_gene_taxon_file({ file => 'tmp', gp_arr => [] });
		} qr[$msg];
		throws_ok {
			$app->write_gene_taxon_file({});
		} qr[$msg];
	};

	subtest 'valid' => sub {
		my ($fh, $fn) = tempfile();
		$app->write_gene_taxon_file({ file => $fn, gp_arr => $args->{gp_arr} });
#		say $fn;
		ok( -s $fn > 0, 'file has non-zero size' );
		# TODO: check file contents!
		$args->{new_gene_taxon_file} = $fn;

	};
};



subtest 'read_gene_taxon_file' => sub {

	subtest 'error states' => sub {

		$msg = err({
			err => 'missing',
			subject => 'gene taxon file'
		});

		throws_ok {
			$app->read_gene_taxon_file({});
		} qr[$msg];


		$msg = err({
			err => 'not_readable',
			subject => 'made_up_file'
		});
		throws_ok {
			$app->read_gene_taxon_file({ file => 'made_up_file' });
		} qr[$msg];

	};

	subtest 'valid' => sub {
		is_deeply( $app->read_gene_taxon_file({ file => $args->{newick} }), [], 'dud file' );

		is_deeply(
			$app->read_gene_taxon_file({ file => $args->{new_gene_taxon_file} }),
			$args->{gp_arr}, 'checking file contents'
		);
	};
};

subtest 'read tree file' => sub {

	subtest 'error states' => sub {

		$msg = err({
			err => 'missing',
			subject => 'tree file'
		});
		throws_ok {
			$app->read_tree_file({});
		} qr[$msg];

		$msg = err({
			err => 'not_readable',
			subject => 'made_up_file'
		});
		throws_ok {
			$app->read_tree_file({ file => 'made_up_file', format => 'newick' });
		} qr[$msg];

		$msg = err({
			err => 'invalid',
			subject => 'blob',
			type => 'tree format'
		});
		throws_ok {
			$app->read_tree_file({ file => $args->{new_gene_taxon_file}, format => 'blob' });
		} qr[$msg];

		# wrong format
		my $out;
		$out = $app->read_tree_file({ file => $args->{new_gene_taxon_file} });
		my $tree = $out->next_tree;
		# should have one messed-up node
		ok( $tree->number_nodes == 1, 'checking number of tree nodes' );
		ok( $tree->get_root_node->id =~ /^gene_oid\ttaxon_oid/, 'Checking node ID' );

		$out = $app->read_tree_file({ file => $args->{part_newick} });
		throws_ok {
			$tree = $out->next_tree;
		} qr[unbalanced]
	};

	subtest 'valid' => sub {
		my $rslt = $app->read_tree_file({ file => $args->{newick} });
		isa_ok( $rslt, 'Bio::TreeIO', 'checking results');
		my $tree = $rslt->next_tree;
		my @nodes = grep { $_->id } $tree->get_nodes;
		ok( scalar(@nodes) == scalar @{ gene_taxon_file() }, 'checking number of tree nodes' );

		# do the same thing but with a filehandle
		open( my $fhndl, '<', $args->{newick} ) or die 'Could not open newick file: ' . $!;
		$rslt = $app->read_tree_file({ fh => $fhndl, format => 'newick' });
		isa_ok( $rslt, 'Bio::TreeIO', 'checking results');
		my $treetwo = $rslt->next_tree;
		ok( $treetwo->number_nodes == $tree->number_nodes, 'checking number of tree nodes' );

	};
};

done_testing();

=cut
subtest 'galaxy script test' => sub {

# 	say $0;
#
# 	my $output =  $base . 'gene_ids.txt';
	my $args = gal_script_prep();

	script_compiles( $args->{script} );

	my $test_name = 'img_gene_id_to_fasta script';
	script_runs( [ $args->{script}, $args->{input}, $args->{output}, 1 ], $test_name );

	script_stdout_is $args->{output}, $test_name;

	my $expect = fasta_hash_from_input({ -string => most_results() });
	my $result = fasta_hash_from_input({ -file => $args->{output} });

	is_deeply( $result, $expect, 'checking generated file' );

	script_stderr_is '', $test_name;


};

subtest 'galaxy script test with errors' => sub {

	# TO DO!


};

# subtest 'phyloviewer results' => sub {
#
#
#
#
# };

sub gal_script_prep {

	my $script = 'script/img_gene_id_to_fasta.pl';
	my $input_file = make_file( \&input );
	my ( $fh, $outfile ) = tempfile();

	return {
		script => $script,
		input  => $input_file,
		output => $outfile
	};
}

=cut
sub script_prep {

	my ( $fh, $outfile ) = tempfile();

	return {
		script          => 'script/phyloviewer_page_gen.pl',
		read_only_file  => test_ro_file(),
		newick          => $dir . '/proportal/t/files/full.newick',
		gene_taxon_file => test_make_file( \&make_gt_file ),
		part_newick     => $dir . '/proportal/t/files/partial.newick',
		gp_arr   => gene_taxon_file(),
		outfile  => $outfile
	};
}


sub input {
	return
'

637449936
	637686988
hi mum!
	whassupz
	637686994
640078650
crapperoo 1234567
';
}

sub most_results {
	return
'>637449936 PMM0923 884216..884659(-)(NC_005072) [Prochlorococcus marinus pastoris CCMP 1986]
ATGTCCTTTTTTCAGGGCAAAATTCTTTTAAATTTTATTATTGATTTACT
TAATAAACCAGCAATTAACTGGTCTAATTTTGAATTAAATTCTTCACTAC
AATTAAATGATTTTGTTGATTTATTGTTAGAACCTTTAAATACTTCTCAA
TACAGCTACAACATAAAACTAGGTTTACATGAAGCACTTATAAATGCGGT
TACGCATGGCAACAAACTAGATCCTAATAAATCGATTAGAGTTCGAAGAA
TCATTACTCCTAACTGGTGTGTATGGCAAATTCAAGATCAAGGTAATGGT
TTAGAAATAAAAAAAAGATTATATAAATTACCTAAAAAATTTACTTCATT
TAATGGGCGGGGTCTTTATATAATAAATGAATGTTTCGATGATATTAGAT
GGAGTAATAAGGGTAATCGGCTCCAATTAGCCTTAAAAAGATGA
>637686994 PMN2A_0138 140466..140858(+)(NC_007335) [Prochlorococcus marinus NATL2A]
GTGGATCCTTCTAAAAATTGGGCCGTATTTATTCATCCCTCTACCTTAAA
ACTAGCATCATTTGTTGAAACTCTTTTAGAGCCTGTAATATGTAAAGAAA
CTGCAAAAAAGATTGAATTGGGATTACATGAGGCTCTTGTTAATGCAGTA
GTTCATGGAAACTTATCGAATCCTAATAAAGTTATTCGTGTTAGAAGAAT
TCTTACTCCAAACTGGATTGTTTGGCAAATCCAAGATGAAGGTTTAGGCC
TAGTTGAAGATAAAAGAGTATGTTGTTTACCTTTGAATACTGATGTTAAT
AGTGGAAGAGGAATTTATTTAATTCATAAGTGTTTTGATGATGTGAGGTG
GAGTAGAAAAGGGAATAGACTTCAGTTGTCACTAAGGAAATAA
>640078650 A9601_09371 806613..807047(+)(NC_008816) [Prochlorococcus marinus AS9601]
ATGTCCTTATTCCGGGGCAAAAATATTTTAAAAAGATTTTTTAAAAGACC
AAAAATTGACTGGTCAAACTACGAATTCGAATCATCATTACAATTAAATG
AATTTGTCGATCAATTATTAGAACCTATTAAAAATACTCAATCAAGCTAT
CTTATAAAACTTGGTTTACATGAAGCTCTAGTTAATGCAGTAAAACATGG
AAATAAATTAGATCCTAAAAAAAATATTAGAGTAAGAAGAATAATTACTC
CTAATTGGTGTGTTTGGCAAATTCAAGATCAAGGTAATGGTTTAGAAATA
AAAAAAAGAGACTACACATTACCAAAAAAAATAAATAGTGTAAATGGGCG
TGGCCTATACATTATTAATGAATGTTTTGATGATATTAGATGGAGTAGTA
AAGGTAATAGGCTTCAGTTGGCTTTAAAAAGGTGA';
}

sub all_results {
	return
'>637449936 PMM0923 884216..884659(-)(NC_005072) [Prochlorococcus marinus pastoris CCMP 1986]
ATGTCCTTTTTTCAGGGCAAAATTCTTTTAAATTTTATTATTGATTTACT
TAATAAACCAGCAATTAACTGGTCTAATTTTGAATTAAATTCTTCACTAC
AATTAAATGATTTTGTTGATTTATTGTTAGAACCTTTAAATACTTCTCAA
TACAGCTACAACATAAAACTAGGTTTACATGAAGCACTTATAAATGCGGT
TACGCATGGCAACAAACTAGATCCTAATAAATCGATTAGAGTTCGAAGAA
TCATTACTCCTAACTGGTGTGTATGGCAAATTCAAGATCAAGGTAATGGT
TTAGAAATAAAAAAAAGATTATATAAATTACCTAAAAAATTTACTTCATT
TAATGGGCGGGGTCTTTATATAATAAATGAATGTTTCGATGATATTAGAT
GGAGTAATAAGGGTAATCGGCTCCAATTAGCCTTAAAAAGATGA
>637686988 PMN2A_0132 135913..136227(-)(NC_007335) [Prochlorococcus marinus NATL2A]
TTGGATGAAAATATATGTATGGATCAACAAAAAAGAAAAGACCTCAACCT
GAGGTTGGGCAATTTAATACTCGCAATATCACTTGCTACGGTTCCAACAG
CAATAACATATGGAACGCTTAGTATTCATGGATTAAATATTTGCAGGGAC
TTAAGCAGTAAAGTAAGTCCTCCAATTAAAATAAAAGAAGATTGTGATAA
AGCGGCTTGGGACACAACAAAAAGTTATATTATACTAATTGGTTTTTTTA
TTACTTTACCTACATGGATGTGGTTTTACTTATCAATGAAGAAAAAAGAT
ACCGATAAAAAATAA
>637686994 PMN2A_0138 140466..140858(+)(NC_007335) [Prochlorococcus marinus NATL2A]
GTGGATCCTTCTAAAAATTGGGCCGTATTTATTCATCCCTCTACCTTAAA
ACTAGCATCATTTGTTGAAACTCTTTTAGAGCCTGTAATATGTAAAGAAA
CTGCAAAAAAGATTGAATTGGGATTACATGAGGCTCTTGTTAATGCAGTA
GTTCATGGAAACTTATCGAATCCTAATAAAGTTATTCGTGTTAGAAGAAT
TCTTACTCCAAACTGGATTGTTTGGCAAATCCAAGATGAAGGTTTAGGCC
TAGTTGAAGATAAAAGAGTATGTTGTTTACCTTTGAATACTGATGTTAAT
AGTGGAAGAGGAATTTATTTAATTCATAAGTGTTTTGATGATGTGAGGTG
GAGTAGAAAAGGGAATAGACTTCAGTTGTCACTAAGGAAATAA
>640078650 A9601_09371 806613..807047(+)(NC_008816) [Prochlorococcus marinus AS9601]
ATGTCCTTATTCCGGGGCAAAAATATTTTAAAAAGATTTTTTAAAAGACC
AAAAATTGACTGGTCAAACTACGAATTCGAATCATCATTACAATTAAATG
AATTTGTCGATCAATTATTAGAACCTATTAAAAATACTCAATCAAGCTAT
CTTATAAAACTTGGTTTACATGAAGCTCTAGTTAATGCAGTAAAACATGG
AAATAAATTAGATCCTAAAAAAAATATTAGAGTAAGAAGAATAATTACTC
CTAATTGGTGTGTTTGGCAAATTCAAGATCAAGGTAATGGTTTAGAAATA
AAAAAAAGAGACTACACATTACCAAAAAAAATAAATAGTGTAAATGGGCG
TGGCCTATACATTATTAATGAATGTTTTGATGATATTAGATGGAGTAGTA
AAGGTAATAGGCTTCAGTTGGCTTTAAAAAGGTGA
';
}

sub fasta_hash_from_input {
	my $args = shift;
	my $expect_str = Bio::SeqIO->new(
		%$args,
		-format => 'fasta'
	);
	my $expect;
	while ( my $seq = $expect_str->next_seq() ) {
		$expect->{ $seq->primary_id } = $seq;
	}
	return $expect;
}

sub make_gt_file {

	my $arr = ProPortal::Controller::PhyloViewer::DemoData::gene_taxon_arr();
	my $str = join "\n", map { $_->{gene_oid} . "\t" . $_->{taxon_oid} } @{ $arr };

	return $str;

}

sub gene_taxon_file {
	return [
{ gene_oid => 637449936, taxon_oid => 637000214 },
{ gene_oid => 637686994, taxon_oid => 637000212 },
{ gene_oid => 640078650, taxon_oid => 640069321 },
{ gene_oid => 640080686, taxon_oid => 640069324 },
{ gene_oid => 640087144, taxon_oid => 640069323 },
{ gene_oid => 640160519, taxon_oid => 640069322 },
{ gene_oid => 640943573, taxon_oid => 640753041 },
{ gene_oid => 647673898, taxon_oid => 647533199 },
{ gene_oid => 2553536569, taxon_oid => 2551306553 },
{ gene_oid => 2553547864, taxon_oid => 2551306560 },
{ gene_oid => 2607022457, taxon_oid => 2606217312 },
{ gene_oid => 2607024285, taxon_oid => 2606217313 },
{ gene_oid => 2607027401, taxon_oid => 2606217314 },
{ gene_oid => 2607028865, taxon_oid => 2606217315 },
{ gene_oid => 2607031065, taxon_oid => 2606217316 },
{ gene_oid => 2607035406, taxon_oid => 2606217318 },
{ gene_oid => 2607361738, taxon_oid => 2606217419 },
{ gene_oid => 2607807999, taxon_oid => 2606217555 },
{ gene_oid => 2607811795, taxon_oid => 2606217557 },
{ gene_oid => 2607814158, taxon_oid => 2606217558 },
{ gene_oid => 2607816045, taxon_oid => 2606217559 },
{ gene_oid => 2607817870, taxon_oid => 2606217560 },
{ gene_oid => 2607980288, taxon_oid => 2606217606 },
{ gene_oid => 2608168136, taxon_oid => 2606217667 },
{ gene_oid => 2608172107, taxon_oid => 2606217668 },
{ gene_oid => 2608172520, taxon_oid => 2606217669 },
{ gene_oid => 2608199767, taxon_oid => 2606217677 },
{ gene_oid => 2608208874, taxon_oid => 2606217679 },
{ gene_oid => 2608211019, taxon_oid => 2606217680 },
{ gene_oid => 2608213837, taxon_oid => 2606217681 },
{ gene_oid => 2608216457, taxon_oid => 2606217682 },
{ gene_oid => 2608217268, taxon_oid => 2606217683 },
{ gene_oid => 2608221109, taxon_oid => 2606217684 },
{ gene_oid => 2608227678, taxon_oid => 2606217688 },
{ gene_oid => 2608229857, taxon_oid => 2606217689 },
{ gene_oid => 2608232869, taxon_oid => 2606217690 },
{ gene_oid => 2608233838, taxon_oid => 2606217691 },
{ gene_oid => 2608236697, taxon_oid => 2606217692 },
{ gene_oid => 2624147685, taxon_oid => 2623620345 },
{ gene_oid => 2624149569, taxon_oid => 2623620346 },
{ gene_oid => 2624151930, taxon_oid => 2623620347 },
{ gene_oid => 2624154139, taxon_oid => 2623620348 },
{ gene_oid => 2626312088, taxon_oid => 2623620961 },
{ gene_oid => 2626314409, taxon_oid => 2623620962 },
{ gene_oid => 2626316849, taxon_oid => 2623620963 },
{ gene_oid => 2626399128, taxon_oid => 2623620984 },
];

}

sub part_newick {
	return '( ( ( ( ( ( ( ( 2553536569:0.04806, 2553547864:0.02318) :0.13790, ( ( 2607817870:0.06292, ( ( 637686994:0.00904, 2607361738:0.00877) :0.00237, ( 2607811795:0.00000, 2624154139:0.00000) :0.01417) :0.04807) :0.11480, ( ( ( ( ( ( 640087144:0.00000, 2608168136:0.00000) :0.00000, 2624151930:0.00000) :0.00000, 2626314409:0.00000) :0.01710, ( ( 2608213837:0.00000, 2608216457:0.00000) :0.00000, 2608221109:0.00000) :0.02405) :0.19430, 2607807999:0.14371) :0.03774, ( ( 2607024285:0.00000, 2607027401:0.00000) :0.00000, 2607028865:0.00000) :0.15988) :0.01777) :0.06318) :0.04989, ( ( 637449936:0.00000, 2608229857:0.00000) :0.07062, ( ( ( 640080686:0.00000, 2608172520:0.00000) :0.00000, 2624147685:0.00000) :0.00000, 2626316849:0.00000) :0.07352) :0.0407';
}

sub newick {
	return '( ( ( ( ( ( ( ( 2553536569:0.04806, 2553547864:0.02318) :0.13790, ( ( 2607817870:0.06292, ( ( 637686994:0.00904, 2607361738:0.00877) :0.00237, ( 2607811795:0.00000, 2624154139:0.00000) :0.01417) :0.04807) :0.11480, ( ( ( ( ( ( 640087144:0.00000, 2608168136:0.00000) :0.00000, 2624151930:0.00000) :0.00000, 2626314409:0.00000) :0.01710, ( ( 2608213837:0.00000, 2608216457:0.00000) :0.00000, 2608221109:0.00000) :0.02405) :0.19430, 2607807999:0.14371) :0.03774, ( ( 2607024285:0.00000, 2607027401:0.00000) :0.00000, 2607028865:0.00000) :0.15988) :0.01777) :0.06318) :0.04989, ( ( 637449936:0.00000, 2608229857:0.00000) :0.07062, ( ( ( 640080686:0.00000, 2608172520:0.00000) :0.00000, 2624147685:0.00000) :0.00000, 2626316849:0.00000) :0.07352) :0.04076) :0.05631, ( ( ( 2607035406:0.00000, 2608232869:0.00000) :0.00000, 2608236697:0.00000) :0.05689, ( 2608211019:0.05840, 2608233838:0.03815) :0.00863) :0.00299) :0.01776, 2608227678:0.02635) :0.00949, 2608199767:0.02571) :0.00179, ( ( 640943573:0.00000, 2607816045:0.00000) :0.00474, ( ( 647673898:0.00000, 2608172107:0.00000) :0.00000, 2626399128:0.00000) :0.00675) :0.01606) :0.00164, ( ( 2607980288:0.04953, ( ( 2607031065:0.00000, 2608208874:0.00000) :0.00000, 2608217268:0.00000) :0.02254) :0.00228, 2607022457:0.01276) :0.00073, ( ( 640078650:0.00000, 2624149569:0.00000) :0.01460, ( ( 640160519:0.00000, 2607814158:0.00000) :0.00000, 2626312088:0.00000) :0.01298) :0.00794)';
}

sub tax_arr {
	return [ 637000212, 637000214, 640069321, 640069322, 640069323, 640069324, 640753041, 647533199, 2551306553, 2551306560, 2606217312, 2606217313, 2606217314, 2606217315, 2606217316, 2606217318, 2606217419, 2606217559, 2606217560, 2606217606, 2606217677, 2606217679, 2606217680, 2606217681, 2606217682, 2606217683, 2606217684, 2606217688, 2606217689, 2606217690, 2606217691, 2606217692, 2623620345, 2623620348, 2623620961, 2623620962, 2623620984 ];
}

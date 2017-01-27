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
use IMG::Util::Import 'Test';
use Dancer2;

use ProPortal::App::GeneIdToFasta;

my $msg;
my $app;
my $self = { choke => sub { err( @_ ) } };
my $args = script_prep();

sub new_app {
	return ProPortal::App::GeneIdToFasta->new( config => config, args => +shift );
}

subtest 'checking app initialisation and variable setting' => sub {

#	REQUIRED: infile, gene_taxon_file, outfile
	my ( $fh0, $fn0 ) = tempfile( UNLINK => 1 );
	my ( $fh1, $fn1 ) = tempfile( UNLINK => 1 );
	my ( $fh2, $fn2 ) = tempfile( UNLINK => 1 );

	subtest 'error states' => sub {

		$msg = err({
			err => 'not_found_in_file',
			subject => 'gene_oids',
			file => $fn0
		});
		# make sure gp_arr has some stuff in it
		$app = new_app({ infile => $fn0, gene_taxon_file => $fn1, outfile => $fn2 });
		throws_ok {
			$app->args->gene_oid;
		} qr[$msg];

		# can't read infile
		my $if = test_wo_file();
		$msg = err({
			err => 'not_readable',
			subject => $if
		});

		$app = new_app({ infile => $if, gene_taxon_file => $fn1, outfile => $fn2 });
		throws_ok {
			$app->args->gene_oid;
		} qr[$msg];

		my $of = test_ro_file();
		$msg = err({
			err => 'not_writable',
			subject => $of,
		});
		throws_ok {
			new_app({ infile => $fn0, gene_taxon_file => $of, outfile => $fn2 });
		} qr[$msg];
	};

	subtest 'valid' => sub {

		$app = new_app({
			gene_taxon_file => $fn1,
			outfile => $fn2,
			infile => $args->{no_seqs}
		});

		is_deeply(
	[ 2504649900, 2504649901, 2504649902, 2504649903, 2504649904, 2504649905 ],
	$app->args->gene_oid,
	'Checking that gene_oid is set correctly'
		);
	};

};

subtest 'run!' => sub {

	my ( $fh0, $fn0 ) = tempfile( UNLINK => 1 );
	my ( $fh1, $fn1 ) = tempfile( UNLINK => 1 );
	my ( $fh2, $fn2 ) = tempfile( UNLINK => 1 );

	subtest 'error states' => sub {
		# fails in first stage
		$msg = err({
			err => 'no_results',
			subject => 'gene_oids'
		});
		$app = new_app({
			gene_taxon_file => $fn1,
			outfile => $fn2,
			infile => $args->{not_fnd}
		});
		throws_ok {
			$app->run()
		} qr[$msg];

		# fails to create FASTA file
		$msg = err({
			err => 'no_results',
			subject => 'sequences'
		});
		$app = new_app({
			gene_taxon_file => $fn1,
			outfile => $fn2,
			infile => $args->{no_seqs}
		});
		throws_ok {
			$app->run()
		} qr[$msg];

		# missing results
		$msg = err({
			err => 'missing_results',
			subject => 'sequences',
			ids => [  ]
		});
		$app = new_app({
			gene_taxon_file => $fn1,
			outfile => $fn2,
			infile => $args->{missing_seqs}
		});
		throws_ok {
			$app->run()
		} qr[$msg];

	};

	subtest 'valid' => sub {

		$app = new_app({
			gene_taxon_file => $fn1,
			outfile => $fn2,
			infile => $args->{infile}
		});
		lives_ok {
			$app->run()
		};
		ok( -s $fn1 > 0, 'gene taxon file has non-zero size' );
		ok( -s $fn2 > 0, 'FASTA file has non-zero size' );
		say 'fn1: ' . $fn1;
		say 'fn2: ' . $fn2;

	};

};


done_testing();

sub script_prep {

	return {
		script   => 'script/img_gene_id_to_fasta.pl',
		infile   => test_make_files( \&input ),
		invalid  => test_make_files( \&invalid_input ),
		not_fnd  => test_make_files( \&not_fnd ),
		missing  => test_make_files( \&missing_genes ),
		no_seqs  => test_make_files( \&no_seqs ),
		no_files => test_make_files( \&no_files ),
		missing_seqs => test_make_files( \&missing_seqs ),
	};
}

sub no_files {
say 'no files';
	return
'641286000
641285000
640944000';
}


sub no_seqs {
say 'no seqs';
	return
'2504649900
2504649901
2504649902
2504649903
2504649904
2504649905';
}

sub missing_seqs {
say 'missing seqs';
	return
'2504649897
2504649898
2504649899
2504649900
2504649902
';
}

sub not_fnd {
say 'not fnd';
	return '
1
2
3
4
5
';
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

sub invalid_input {
	return '

	abc
def
ghi
';

}

sub missing_genes {
	return '
	637449936
637686988
637686994
666
640078650
';
}

sub results_fna {
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

# { gene_oid => 637449936, taxon_oid => 637000214, ext_acc => "NC_005072" },
# { gene_oid => 637686988, taxon_oid => 637000212, ext_acc => "NC_007335" },
# { gene_oid => 637686994, taxon_oid => 637000212, ext_acc => "NC_007335" },
# { gene_oid => 640078650, taxon_oid => 640069321, ext_acc => "NC_008816" },

sub results_faa {
	return
'>637449936 PMM0923 hypothetical protein [Prochlorococcus marinus pastoris CCMP 1986]
MSFFQGKILLNFIIDLLNKPAINWSNFELNSSLQLNDFVDLLLEPLNTSQ
YSYNIKLGLHEALINAVTHGNKLDPNKSIRVRRIITPNWCVWQIQDQGNG
LEIKKRLYKLPKKFTSFNGRGLYIINECFDDIRWSNKGNRLQLALKR
>637686994 PMN2A_0138 hypothetical protein [Prochlorococcus sp. NATL2A]
MDPSKNWAVFIHPSTLKLASFVETLLEPVICKETAKKIELGLHEALVNAV
VHGNLSNPNKVIRVRRILTPNWIVWQIQDEGLGLVEDKRVCCLPLNTDVN
SGRGIYLIHKCFDDVRWSRKGNRLQLSLRK
>640078650 A9601_09371 Anti-sigma regulatory factor (Ser/Thr protein kinase) [Prochlorococcus sp. AS9601]
MSLFRGKNILKRFFKRPKIDWSNYEFESSLQLNEFVDQLLEPIKNTQSSY
LIKLGLHEALVNAVKHGNKLDPKKNIRVRRIITPNWCVWQIQDQGNGLEI
KKRDYTLPKKINSVNGRGLYIINECFDDIRWSSKGNRLQLALKR
';
}

sub all_results_fna {
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

sub all_results_faa {
	return
'>637449936 PMM0923 hypothetical protein [Prochlorococcus marinus pastoris CCMP 1986]
MSFFQGKILLNFIIDLLNKPAINWSNFELNSSLQLNDFVDLLLEPLNTSQ
YSYNIKLGLHEALINAVTHGNKLDPNKSIRVRRIITPNWCVWQIQDQGNG
LEIKKRLYKLPKKFTSFNGRGLYIINECFDDIRWSNKGNRLQLALKR
>637686988 PMN2A_0132 hypothetical protein [Prochlorococcus sp. NATL2A]
MDENICMDQQKRKDLNLRLGNLILAISLATVPTAITYGTLSIHGLNICRD
LSSKVSPPIKIKEDCDKAAWDTTKSYIILIGFFITLPTWMWFYLSMKKKD
TDKK
>637686994 PMN2A_0138 hypothetical protein [Prochlorococcus sp. NATL2A]
MDPSKNWAVFIHPSTLKLASFVETLLEPVICKETAKKIELGLHEALVNAV
VHGNLSNPNKVIRVRRILTPNWIVWQIQDEGLGLVEDKRVCCLPLNTDVN
SGRGIYLIHKCFDDVRWSRKGNRLQLSLRK
>640078650 A9601_09371 Anti-sigma regulatory factor (Ser/Thr protein kinase) [Prochlorococcus sp. AS9601]
MSLFRGKNILKRFFKRPKIDWSNYEFESSLQLNEFVDQLLEPIKNTQSSY
LIKLGLHEALVNAVKHGNKLDPKKNIRVRRIITPNWCVWQIQDQGNGLEI
KKRDYTLPKKINSVNGRGLYIINECFDDIRWSSKGNRLQLALKR
';
}

sub test_make_files {

	my $to_do = shift;
	say 'to do: ' . Dumper $to_do;
	my ($fh, $fn) = tempfile();

	say 'to_do: ' . $to_do->();

	print { $fh } $to_do->();
	say 'fn: ' . $fn;
	return $fn;

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

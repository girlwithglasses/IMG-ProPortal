#!/usr/bin/env perl

BEGIN {
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	my $dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	our @dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib webui.cgi/t/lib );
}
use lib @dir_arr;
use FindBin qw/ $Bin /;
use IMG::Util::Base 'Test';

my $test_dir = $Bin;
my $test_gff = $test_dir .'/files/637000214/637000214.gff';
my $fake_gff = $test_dir .'/files/637000214/fake.gff';
my $test_cog = $test_dir .'/files/637000214/637000214.cog.tab.txt';
my $col_data = IMG::Util::Parser::TSV2GFF::_get_col_data();
my $gff_cols = IMG::Util::Parser::TSV2GFF::_get_gff_cols();

use File::Temp qw(tempfile tempdir);

use IMG::Util::Parser::TSV2GFF qw( prepare_parser tsv2gff get_seqid_from_gff );

use_ok( 'IMG::Util::Parser::TSV2GFF' );

subtest 'prepare parser' => sub {

	throws_ok { prepare_parser() } qr[No file type specified];

	throws_ok { prepare_parser('') } qr[No file type specified];

	throws_ok { prepare_parser('blob') } qr[No parsing information available for blob];

};

subtest 'specific parser tests' => sub {

	for my $fmt ( keys %$col_data ) {
		my $disp_h = prepare_parser( $fmt );
		# make sure we have all the cols present
		ok( 0 == scalar ( grep { not defined $disp_h->{$_} } @$gff_cols ), 'Checking subs for '. $fmt );
		run_parser_tests( $fmt, $disp_h );

	}

	# pfam tests

};

sub run_parser_tests {
	my $fmt = shift;

	my $tests = {
		cog => sub { cog_tests( @_ ); },
		ipr => sub { ipr_tests( @_ ); },
		kegg => sub { kegg_tests( @_ ); },
		kog => sub { kog_tests( @_ ); },
		pfam => sub { pfam_tests( @_ ); },
		tigrfam => sub { tigrfam_tests( @_ ); },
	};
}

sub cog_tests {
	my $disp_h = shift;
	subtest 'COG tests' => sub {
		ok( 'COG mapping from NCBI RPSBLAST' eq $disp_h->{source}->(), 'checking added sub' );

=cut
gene_oid	gene_length	percent_identity	query_start	query_end	subj_start	subj_end	evalue	bit_score	cog_id	cog_name	cog_length
637448992	385	31.33	1	383	1	364	1.0e-62	233	COG0592	DNA polymerase sliding clamp subunit (PCNA homolog)	364
637448994	779	43.71	21	769	24	739	0.0e+00	797	COG0046	Phosphoribosylformylglycinamidine (FGAM) synthase, synthetase domain	743
637448995	486	49.49	1	486	4	470	0.0e+00	559	COG0034	Glutamine phosphoribosylpyrophosphate amidotransferase	470
637448996	813	40.1	3	810	5	802	0.0e+00	656	COG0188	Type IIA topoisomerase (DNA gyrase/topo II, topoisomerase IV), A subunit	804
=cut



	};


}

sub ipr_tests {
	my $disp_h = shift;
	subtest 'InterPro tests' => sub {
		ok( 'InterPro' eq $disp_h->{source}->(), 'checking added sub' );
	};

=cut
gene_oid	gene_length	query_start	query_end	domaindb	domainid	iprid	iprdesc	go_info
637448992	385	17	379	SMART	SM00480	IPR001001	DNA polymerase III, beta chain	GO:0003677|GO:0003887|GO:0006260|GO:0008408|GO:0009360
637448992	385	1	124	SUPERFAMILY	SSF55979
637448992	385	127	259	SUPERFAMILY	SSF55979
637448992	385	261	383	SUPERFAMILY	SSF55979
=cut

}

sub kegg_tests {
	my $disp_h = shift;
	subtest 'KEGG tests' => sub {
		ok( 'NCBI BLASTP on KEGG genes' eq $disp_h->{source}->(), 'checking added sub' );
	};

=cut
gene_oid	gene_length	percent_identity	query_start	query_end	subj_start	subj_end	evalue	bit_score	ko_id	ko_name	EC	img_ko_flag
637448992	385	100	1	385	1	385	0.0e+00	740.3	KO:K02338	DNA polymerase III subunit beta [EC:2.7.7.7]	EC:2.7.7.7	Yes
637448994	779	100	1	779	1	779	0.0e+00	1550.4	KO:K01952	phosphoribosylformylglycinamidine synthase [EC:6.3.5.3]	EC:6.3.5.3	Yes
637448995	486	100	1	486	1	486	0.0e+00	972.6	KO:K00764	amidophosphoribosyltransferase [EC:2.4.2.14]	EC:2.4.2.14	Yes
637448996	813	100	1	813	1	813	0.0e+00	1590.1	KO:K02469	DNA gyrase subunit A [EC:5.99.1.3]	EC:5.99.1.3	Yes
=cut

}

sub kog_tests {
	my $disp_h = shift;
	subtest 'kog tests' => sub {

		ok( 'KOG mapping from NCBI RPSBLAST' eq $disp_h->{source}->(), 'checking added sub' );


	};
}

sub pfam_tests {
	my $disp_h = shift;
	subtest 'pfam tests' => sub {

		ok( 'Pfam from EBI pfam_scan (HMMER 3.0)' eq $disp_h->{source}->(), 'checking added sub' );

=cut
gene_oid	gene_length	query_start	query_end	subj_start	subj_end	evalue	bit_score	pfam_id	pfam_name	pfam_length
637448992	385	1	123	1	120	1.1e-29	102.7	pfam00712	DNA_pol3_beta	120
637448992	385	132	258	2	116	7.1e-23	80.8	pfam02767	DNA_pol3_beta_2	116
637448992	385	260	382	2	120	6.7e-27	93.4	pfam02768	DNA_pol3_beta_3	121
637448994	779	77	172	1	95	1.6e-25	89.1	pfam00586	AIRS	96
=cut


		my @headers = split "\t", 'gene_oid	gene_length	query_start	query_end	subj_start	subj_end	evalue	bit_score	pfam_id	pfam_name	pfam_length';
		my @data = split "\t", '637448992	385	132	258	2	116	7.1e-23	80.8	pfam02767	DNA_pol3_beta_2	116';
		my %input;
		@input{@headers} = @data;

		ok( 'ID:637448992;Length:385;Target:pfam02767 2 116;Target_name:DNA_pol3_beta_2;Target_length:116' eq $disp_h->{attributes}->(\%input), 'Checking attributes' ) or diag explain $disp_h->{attributes}->(\%input);
	};
}

sub tigrfam_tests {
	my $disp_h = shift;
	subtest 'tigrfam tests' => sub {

		ok( 'hmmscan HMMER3.0' eq $disp_h->{source}->(), 'checking added sub' );


=cut
gene_oid	gene_length	query_start	query_end	evalue	bit_score	tigrfam_id	tigrfam_name
637448992	385	1	383	2.2e-99	318.8	TIGR00663	DNA polymerase III, beta subunit
637448994	779	21	779	0.0e+00	857.8	TIGR01736	phosphoribosylformylglycinamidine synthase II
637448995	486	2	468	0.0e+00	472.7	TIGR01134	amidophosphoribosyltransferase
637448998	314	15	314	3.4e-84	268.7	TIGR00276	epoxyqueuosine reductase
=cut

		my @headers = split "\t", 'gene_oid	gene_length	query_start	query_end	subj_start	subj_end	evalue	bit_score	pfam_id	pfam_name	pfam_length';
		my @data = split "\t", '637448992	385	132	258	2	116	7.1e-23	80.8	pfam02767	DNA_pol3_beta_2	116';
		my %input;
		@input{@headers} = @data;

		ok( 'ID:637448992;Length:385;Target:pfam02767 2 116;Target_name:DNA_pol3_beta_2;Target_length:116' eq $disp_h->{attributes}->(\%input), 'Checking attributes' ) or diag explain $disp_h->{attributes}->(\%input);
	};
}

subtest 'Get GFF ID' => sub {

	throws_ok { get_seqid_from_gff() } qr[No GFF file specified];

	throws_ok { get_seqid_from_gff( $test_cog ) } qr[No GFF header found in ];

	throws_ok { get_seqid_from_gff( $fake_gff ) } qr[No seqID found in];

	ok( 'NC_005072' eq get_seqid_from_gff( $test_gff ), 'Correct seqID' );

};



done_testing();

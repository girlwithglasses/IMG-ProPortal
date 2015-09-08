#!/usr/bin/env perl

use strict;
use warnings;
use feature ':5.16';

use FindBin qw/ $Bin /;
use File::Basename;

use URI;
use URI::QueryParam;

use Data::Dumper::Concise;

# parent of parent dir of script
my $base = dirname( $Bin );

say "base: $base";

my $all_params;

my @params_to_ignore = qw(
cached_session
callid
clique_id
close
cluster_id
cnt
cog_id
compound_oid
coord1
coord2
data_type
domainfile
down_stream
ec_number
end_coord
ext_accession
extacc
family
fasta
file
filename
func
func_id
funcId
gene_count
gene_display_name
gene_oid
gene_oid
genePageGeneOid
genomeFilterSelection
genomeFilterSelections
genus
id
kegg_id
ko
ko_id
koid
map_id
marker_gene
open
openfile
page
pathway_id
pathway_oid
pfam_id
pidt
procId
pway_oid
range
rxn_oid
sample
sampleGoldId
scaffold_id
scaffold_oid
scf_length
selectedfile
selectid
seq_length
sid
species
start_coord
taxon
taxon_filter_oid
taxon_oid
taxonBin
taxons
tcfamid
term_oid
total_gene_count
total_genome_gene_count
unique_id
unselectid
up_stream
);

#my %ignore;
#undef @ignore{@params_to_ignore};
my $regex = "qr![\?&](" . join("|", @params_to_ignore) . ")=.*?([&$])!i";


#open my $in, "<", "$base/tmp/ga_stats_sorted.tsv" or die "Could not open file: $!";
#open my $out, ">", "$base/tmp/ga_stats-edit.tsv" or die "Could not open file: $!";
open my $in, "<", "$base/tmp/sorted_logs.txt" or die "Could not open file: $!";
open my $out, ">", "$base/tmp/sorted_logs-edit.txt" or die "Could not open file: $!";
my ($last_t, $last_n) = ( "", 'GET' );

while (<$in>) {
	next unless m!\?!;
	chomp;
	s!$regex!$1=$2!g;

	my ($n, $t) = split "\t", $_, 2;
#	say "line: $_; t: $t, n: $n";
	if ($last_t eq $t) {
		$last_n = $n;
	}
	else {
		($last_t, $last_n) = ($t, $n);
		print { $out } "$_\n";
	}

	my $ct = $t;
	$ct =~ s!.+?/([^/]+\.(cgi|pl))\?!!;
	my $cgi = $1;
	my @args = split '&', $ct;
	my %h;
	for (@args) {
		my ($key, $value) = split "=", $_, 2;
		$h{$key} = $value;
	}



	if ( $h{page} && $h{section} ) {

		my @keys;
		for my $k ( keys %h ) {
			next if 'page' eq $k || 'section' eq $k;
			push @keys, $k;
#			for my $v ( $h->query_param( $k ) ) {
#				$all_params->{combo}{$k.'='. $h{$k}} ++;
#				$all_params->{solo}{$k}{ $h{$k} } ++;
#			}
		}
		$all_params->{sect_page}{"$n $cgi"}{ $h{section} . "/" . $h{page} }{ join " ", map { "[$_]" } sort @keys }++;

	}
	else {
		# non-conforming URL
		$all_params->{noncon}{"$n $cgi"}{ join " ", map { "[$_]" } sort keys %h } ++;
	}

	for my $k (keys %h) {
#		$all_params->{combo}{"$n $cgi"}{$k.'='. $h{$k}} ++;
#		$all_params->{solo}{"$n $cgi"}{$k}{ ( $h{$k} || "" ) } ++;
		$all_params->{solo}{"$n $cgi"}{$k} ++;
	}
=cut

	my $u = URI->new( $t );

	if ( $u->query_param('page') && $u->query_param('section') ) {

		my @keys;
		for my $k ( $u->query_param ) {
			next if 'page' eq $k || 'section' eq $k;
			push @keys, $k;
			for my $v ( $u->query_param( $k ) ) {
				$all_params->{combo}{$k.'='.$v} ++;
				$all_params->{solo}{$k}{$v} ++;
			}
		}
		$all_params->{sect_page}{ $u->query_param('section') . "/" . $u->query_param('page') }{ join "", map { "[$_]" } sort @keys }++;

	}
	else {
		# non-conforming URL
		$all_params->{noncon}{ join "||", sort $u->query_param } ++;
	}
=cut
}
close $out;
close $in;
open ( my $out2, ">", "$base/tmp/log-parse-stats.txt" ) or die "Could not create file: $!";

# print section/page combos

print { $out2 } "Section / Page combos\n\n";

for my $r (sort keys %{$all_params->{sect_page}}) {
	print { $out2 } "$r\n";

	for my $sp ( sort keys %{$all_params->{sect_page}{$r}} ) {
		print { $out2 } "$sp\n";

		for ( sort keys %{$all_params->{sect_page}{$r}{$sp}} ) {
			print { $out2 } "\t$_\n";
		}
		print { $out2 } "\n";
	}
	print { $out2 } "\n";
}

#print { $out2 } join "\n", map {
#	my $req = $_;
#	my $sp = $_;
#	$_ = join "\n", ( $sp, map { "\t" . $_ . "\t" . $all_params->{sect_page}{$sp}{$_} } sort keys %{$all_params->{sect_page}{$sp}} );
#	} sort keys %{$all_params->{sect_page}};

# print non-conforming URLs

print { $out2 } "\n\nNon-conforming\n\n";

for my $r (sort keys %{$all_params->{noncon}}) {
	print { $out2 } "$r\n";
	for my $sp ( sort keys %{$all_params->{noncon}{$r}} ) {
		print { $out2 } "$sp\n";
	}
	print { $out2 } "\n";
}

#
#print { $out2 } "\n\nParam variability / frequency\n\n";

#for my $p (sort { scalar keys %{$all_params->{solo}{$b}} <=> scalar keys %{$all_params->{solo}{$a}} } keys %{$all_params->{solo}}) {
#	print { $out2 } $p ."\t". ( scalar keys %{$all_params->{solo}{$p}} ) . "\n";
#}




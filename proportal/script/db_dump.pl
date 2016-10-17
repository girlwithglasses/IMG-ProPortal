#!/usr/bin/env perl
use strict;
use warnings;
use feature ':5.10';
use Data::Dumper;
use IMG::App::Role::ErrorMessages qw( err );
use Text::CSV_XS qw( csv );
use DBI;

my $dbs = {
	sgdev => {
		dsn => 'dbi:Oracle:imgiprd',
		user => 'imgsg_dev',
		password => 'Tuesday',
		options => { RaiseError => 1 },
    },
	imgcore => {
		dsn => 'dbi:Oracle:gemini1',
		user => 'img_core_v400',
		password => 'imgCoreC0sM0s1',
		options => { RaiseError => 1 },
	},
};

my $dbh = DBI->connect(
	$dbs->{imgcore}{dsn},
	$dbs->{imgcore}{user},
	$dbs->{imgcore}{password},
	$dbs->{imgcore}{options}) or die err({
		err => 'db_conn_err',
		msg => $DBI::errstr
	});

my $sql = "select * from taxon
WHERE obsolete_flag = 'No' and is_public = 'Yes'
AND
( ( ( lower(genus) like '%prochlorococcus%' OR lower(genus) like '%synechococcus%') and
sequencing_gold_id in (select gold_id from gold_sequencing_project\@imgsg_dev where ecosystem_type = 'Marine') )
OR
(lower(taxon_display_name) like '%cyanophage%' or lower(taxon_display_name) like '%prochlorococcus phage%' or
lower(taxon_display_name) like '%synechococcus phage%')
OR
(genome_type = 'metagenome' AND ir_order = 'Marine' AND ( combined_sample_flag = 'No' OR combined_sample_flag IS NULL ) )
)";

my $output = 'data/taxon.csv';
open my $fh, ">", $output or die "$output: $!\n";
my $csv = Text::CSV_XS->new ({ binary => 1, eol => "\r\n", sep_char => "\t" });
my $sth = $dbh->prepare('select * from taxon');
$sth->execute;
#$csv->print ($fh, $sth->{NAME});
while (my $row = $sth->fetch) {
	$csv->print($fh, $row);
}
$dbh->disconnect;
say "Dumped taxon info";

## gold_analysis_project
$dbh = DBI->connect(
	$dbs->{sgdev}{dsn}, $dbs->{sgdev}{user},
	$dbs->{sgdev}{password},
	$dbs->{sgdev}{options}
) or die $DBI::errstr;

my @tables = qw( gold_analysis_project gold_sequencing_project gold_analysis_project_lookup2 gold_ap_genbank img_group img_group_news );

push @tables,
map { lc( "gold_sp_$_" ) } qw (
cell_arrangement
collaborator
disease
energy_source
genome_publications
habitat
metabolism
phenotype
relevance
seq_center
seq_method
study_gold_id );

for my $t (@tables) {
	$output = "data/$t.csv";
	open my $fh, ">", $output or die "$output: $!\n";
	my $sth = $dbh->prepare ( "select * from $t" );
	$sth->execute;
#	$csv->print ($fh, $sth->{NAME});
	while (my $row = $sth->fetch) {
		$csv->print ($fh, $row);
	}
}

say "Work complete!";

say 'Build the DB schema:

export DBIC_MIGRATION_SCHEMA_CLASS=DbSchema::IMG_Core
dbic-migration -Ilib install
sqlite3 share/dbschema-img_core.db

Now open up the database and run the following commands:

.separator "\t"
.import data/taxon.csv TAXON';

for (@tables) {
	say ".import data/$_.csv " . uc($_);
}

#!/usr/bin/env perl
# NOT IN USE!


use strict;
use warnings;
use feature ':5.10';

use File::Basename;
use FindBin qw/ $Bin /;
use lib "$Bin/../lib";
my $base = dirname( $FindBin::Bin );

use Test::More;
use Data::Dumper;

use Template;
use Carp;
use Config::Any;

use ProPortal::IO::DBIC;
use DbSchema::IMG_Core;

$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = 1;
# $ENV{DBI_TRACE} = 3;
$ENV{DBIC_TRACE} = 1;

# read in the config file, get the DB schema
my $cfg = $base . '/environments/development';
my $conf = Config::Any->load_stems( { stems => [ $cfg ], use_ext => 1, flatten_to_hash => 1 } );

if (scalar keys %$conf == 1) {
#	my @arr = values %$conf;
#	$conf = $arr[0];
	$conf = ( values %$conf )[0];
}

# my $schema = get_schema( $conf );

my $dbic = ProPortal::IO::DBIC->new( $conf );

my $q = $dbic->run_query(
	query => 'genome_details',
	input => 'Gp0037573'
);

say "query: " . Dumper $q;

exit;
my $dbh;
say "dbh: " . Dumper($dbh);

my $res = $dbh->do('ALTER SESSION SET NLS_COMP=LINGUISTIC') or die $dbh->errstr;
$dbh->do('ALTER SESSION SET NLS_SORT=BINARY_CI') or die $dbh->errstr;

my $schema;
#	'prochlorococcus' => qq{ lower(t.GENUS) LIKE '%prochlorococcus%' AND t.sequencing_gold_id IN (SELECT gold_id FROM gold_sequencing_project\@imgsg_dev WHERE ecosystem_type = 'Marine') },

# select t.taxon_oid, t.taxon_display_name from taxon t WHERE
# ( t.taxon_display_name like '%cyanophage%' or
# t.taxon_display_name like '%prochlorococcus phage%' or
# t.taxon_display_name like '%synechococcus phage%')
# and t.obsolete_flag = 'No' and t.is_public = 'Yes' ORDER BY t.taxon_display_name

# set case-insensitivity
$schema->storage->on_connect_do("ALTER SESSION SET NLS_SORT=BINARY_CI");
$schema->storage->on_connect_do("ALTER SESSION SET NLS_COMP=LINGUISTIC");
$schema->storage->on_connect_do("ALTER SESSION SET NLS_SORT=BINARY_CI");

my $sql = ProPortal::IO::DBI->taxon_oid_display_name('cyanophage');
$res = $dbh->selectall_arrayref( $sql );

my $pp = ProPortal::IO::DBIC->new( schema => $schema );

my @queries = qw( taxon_oid_display_name taxon_marine_metagenome depth_graph clade_graph tax_count depth_clade depth_ecotype location stats role news );




my @phages = $schema->resultset('Taxon')->public_extant->phage->search(undef,{
	columns =>  [ qw( taxon_display_name taxon_oid ) ],
	order_by => [ qw( taxon_display_name taxon_oid ) ]
});


my $res_str = join("\n", map { $_->[0] . "\t" . $_->[1] } @$res);
my $res_str2 = join("\n", map { $_->taxon_oid ."\t". $_->taxon_display_name } @phages);

if ($res_str ne $res_str2) {
	say "DBH results: $res_str";
	say "DBIC results: $res_str2";
}

ok(
	$res_str
		eq
	$res_str2,
	"Checking that DBIC and DBH returns the same results");


# select t.taxon_oid, t.taxon_display_name from taxon t where (lower(t.GENUS) like '%prochlorococcus%' and t.sequencing_gold_id in (select gold_id from gold_sequencing_project@imgsg_dev where ecosystem_type = 'Marine')) and t.obsolete_flag = 'No' and t.is_public = 'Yes' order by 2

my $res2 = $dbh->selectall_arrayref( "select t.taxon_oid, t.taxon_display_name from taxon t where (lower(t.GENUS) like '%prochlorococcus%' and t.sequencing_gold_id in (select gold_id from gold_sequencing_project\@imgsg_dev where ecosystem_type = 'Marine')) and t.obsolete_flag = 'No' and t.is_public = 'Yes' order by t.taxon_display_name, t.taxon_oid" );

my @prococ = $schema->resultset('Taxon')->public_extant->genus('prochloro')->search({

	sequencing_gold_id => { in => $schema->resultset('GoldSequencingProject')->marine_eco->get_column('gold_id')->as_query }

},{
	columns => [ qw( taxon_oid taxon_display_name ) ],
	order_by => [ qw( taxon_display_name taxon_oid ) ]
});

$res_str = join("\n", map { $_->[0] . "\t" . $_->[1] } @$res2);
$res_str2 = join("\n", map { $_->taxon_oid ."\t". $_->taxon_display_name } @prococ);

if ($res_str ne $res_str2) {
	say "DBH results: $res_str";
	say "DBIC results: $res_str2";
}

ok(
	join("\n", map { $_->[0] . "\t" . $_->[1] } @$res2)
		eq
	join("\n", map { $_->taxon_oid ."\t". $_->taxon_display_name } @prococ),
	"Checking that DBIC and DBH returns the same results");

done_testing();


sub get_schema {
	my $cfg = shift;

	if (scalar keys %$cfg == 1) {
		my @arr = values %$cfg;
		$cfg = $arr[0];
	}
	say Dumper $cfg;

	my $args = $cfg->{plugins}{DBIC}{default} || confess "Unexpected config format!";

	say "Running schema init";

	if ( try_load_class $args->{schema_class} ) {

		my $class = $args->{schema_class};
		my $schema = $class->connect(
			$args->{dsn},
			$args->{user} || undef,
			$args->{password} || undef,
			$args->{options} || { RaiseError => 1 }
		) or die $DBI::errstr;

		return $schema;
	}

	confess "Could not load schema class " . $args->{schema_class};

}

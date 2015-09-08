#!/usr/bin/env perl

use strict;
use warnings;
use feature ':5.10';
use Data::Dumper;

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";
use File::Basename;

use DBI;
use DBIC::IMG_Core;
use DataModel::IMG_Core;
use Util::DB;
use File::Path qw( make_path );

my $base = dirname( $Bin );

my $target = $base . '/tmp/img_core.db';

# make sure we have a tmp dir!
if (! -e $base.'/tmp') {
	make_path "$base/tmp";
}

if (-e $target) {
	unlink $target;
}

my $sqlite_params = [ 'dbi:SQLite:dbname=' . $target, undef, undef, { RaiseError => 1, FetchHashKeyName => 'NAME_lc' } ];

my $target_dbh = DBI->connect( @$sqlite_params ) or die $DBI::errstr;

my $dbic_sch = deploy_new_db( $sqlite_params );

# get the oracle dbh params
my $source_dbh = Util::DB::get_oracle_dbh({ database => 'img_core' });

copy_data( $source_dbh, $target_dbh, $dbic_sch );

say "Work complete!";

sub copy_data {
	my $dbh1 = shift;
	my $dbh2 = shift;
	my $schema = shift;

	# get all the tables in $schema
#	my @t_arr = $schema->

	my $tables = {
#		taxon => " INNER JOIN GOLD_SEQUENCING_PROJECT g ON t.sequencing_gold_id=g.gold_id where g.ecosystem_type = 'Marine'",
		gold_sequencing_project => " where t.ecosystem_type = 'Marine'",
		gold_sp_collaborator => undef,
		gold_ap_genbank => undef,
		gold_sp_relevance => undef,
		gold_sp_disease => undef,
		gold_sp_phenotype => undef,
		gold_sp_metabolism => undef,
		gold_sp_seq_method => undef,
		img_group_news => undef,
#		gold_sequencing_project => undef,
		gold_analysis_project_lookup2 => undef,
#		taxon => undef,
		gold_sp_energy_source => undef,
		gold_analysis_project => undef,
		gold_sp_genome_publications => undef,
		img_group => undef,
		gold_sp_cell_arrangement => undef,
		gold_sp_habitat => undef,
		gold_sp_study_gold_id => undef,
		gold_sp_seq_center => undef,
	};

	for my $t (sort keys %$tables) {

		say "Copying $t table";
		my $sql = "select t.* from $t t ";
		if ($tables->{$t}) {
			$sql .= $tables->{$t};
		}
		my $sel = $dbh1->prepare($sql);

		# prep the col names/values
		my %q;
		@q{ @{$sel->{NAME_lc} } } = ('?') x scalar(@{$sel->{NAME}});
		my $q_str  = join ',', values %q;
		my $fields = join ',', keys %q;

		say "fields: $fields";
		say "q_str: $q_str";

		$sel->execute;

		my $ins = $dbh2->prepare("insert into $t ($fields) values ($q_str)");
		my $fetch_tuple_sub = sub { $sel->fetchrow_arrayref };

		my @tuple_status;
		my $rc = $ins->execute_for_fetch($fetch_tuple_sub, \@tuple_status);
		my @errors = grep { ref $_ } @tuple_status;

		say "Errors: " . Dumper [@errors] if @errors;

	}

}

sub deploy_new_db {
	my $conn_params = shift;
	my $schema = DBIC::IMG_Core->connect( @$conn_params );
	$schema->deploy({ add_drop_table => 1 });
	return $schema;
}

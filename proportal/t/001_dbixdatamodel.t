#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";
use IMG::Util::Base 'Test';

use DBIx::DataModel;


# Schema definition: two tables with a simple join

DBIx::DataModel->Schema('DataModel::IMG_Core');

DataModel::IMG_Core->metadm->define_table(
  class       => 'Fruit',
  db_name     => 'FRUIT',
  primary_key => 'id',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'Taxon',
  db_name     => 'TAXON',
  primary_key => 'taxon_oid',
);

DataModel::IMG_Core
->Association(
  [qw/Fruit      fruit                  1    id            /],
  [qw/Taxon      taxa                   *    fruit_id      /]);

DataModel::IMG_Core->metadm->define_table(
	class => 'FullQuotes',
	db_name => '"FRUIT" INNER JOIN "TAXON" ON "FRUIT"."id" = "TAXON"."fruit_id"',
);

DataModel::IMG_Core->metadm->define_table(
	class => 'InnerQuotes',
	db_name => 'FRUIT" INNER JOIN "TAXON" ON "FRUIT"."id" = "TAXON"."fruit_id',
);


DataModel::IMG_Core->metadm->define_table(
	class => 'NoQuotes',
	db_name => 'FRUIT INNER JOIN TAXON ON FRUIT.id = TAXON.fruit_id',
);

# feed the schema with a custom instance of SQL::Abstract::More
my $sqlam = SQL::Abstract::More->new(quote_char => '"', name_sep => '.');
DataModel::IMG_Core->singleton->sql_abstract($sqlam);

for ('FullQuotes','InnerQuotes','NoQuotes') { #, 'TableJoin') {

	my ($sql, @bind) = DataModel::IMG_Core->table($_)
		->select(
			-columns => [ qw( apple banana clementine ) ],
			-result_as => 'sql',
		);

	say "$_: " . $sql;
}

say "join version: " . DataModel::IMG_Core->join( qw#Fruit <=> taxa# )
		->select(
			-columns => [ qw( apple banana clementine ) ],
			-result_as => 'sql',
		);

my $sqla = SQL::Abstract::More->new( quote_char => '"', name_sep => '.', sql_dialect => 'Oracle');

my $d = $sqla->select(
	-columns => [ qw( apple banana clementine ) ],
	-from => [ -join => qw/ FRUIT id=fruit_id  TAXON/ ],
	-want_details => 1
);

say "SQL Abstract More join: " . $d->{sql};

my $d2 = $sqla->select(
	-columns => [ qw( apple banana clementine ) ],
	-from => [  qw/ FRUIT TAXON/ ],
	-where => { 'FRUIT.id' => 'TAXON.fruit_id' },
	-want_details => 1
);

say "SQL Abstract More where: " . $d2->{sql};


my $sa = SQL::Abstract->new( quote_char => '"', name_sep => '.');
my $q = $sa->select(
	[ qw( FRUIT TAXON ) ],
	[ qw( apple banana clementine ) ],
	{ 'FRUIT.id' => 'TAXON.fruit_id' }
);
say "SQL Abstract: " . $q;

package DataModel::IMG_Gold;

use IMG::Util::Import;
use DBIx::DataModel;
use IMG::Model::UnitConverter;

DBIx::DataModel  # no semicolon (intentional)

#---------------------------------------------------------------------#
#                         SCHEMA DECLARATION                          #
#---------------------------------------------------------------------#
->Schema('DataModel::IMG_CyCOG')

#---------------------------------------------------------------------#
#                         TABLE DECLARATIONS                          #
#---------------------------------------------------------------------#
#          Class                      Table                         PK
#          =====                      =====                         ==
->Table(qw/GeneCycogGroups            GENE_CYCOG_GROUPS             unknown_pk         /)
->Table(qw/Cycog                      CYCOG                         cycog_oid          /)
->Table(qw/CycogRelease               CYCOG_RELEASE                 cycog_version      /)
->Table(qw/CurrentCycogVersion        CURRENT_CYCOG_VERSION         cycog_version      /)
->Table(qw/CycogTaxon                 CYCOG_TAXON                   unknown_pk         /)

->Association(
  [qw/Cycog                           cycog                    1    cycog_oid          /],
  [qw/GeneCycogGroups                 cycog_genes              1    cycog_oid          /])

->Association(
  [qw/CycogRelease                    release                  1    cycog_version      /],
  [qw/CycogTaxon                      taxa                     *    cycog_version      /])

->Association(
  [qw/CurrentCycogVersion             current               0..1    cycog_version      /],
  [qw/CycogRelease                    release                  *    cycog_version      /])
;

# DBIx::DataModel->Schema('DataModel::IMG_CyCOG')->View(
# 	$class_name,
# 	$default_columns,
# 	$sql,
# 	\%where,
# 	@parent_tables);

# $meta_schema->define_table(
#   name     => 'MyView',
#   db_table => 'TABLE1 EXOTIC JOIN TABLE2 ON ...',
#   where    => {col1 => $filter1, col2 => $filter2}
#   parents  => [map { $meta_schema->table($_) } qw/Table1 Table2/],
# );

#->View('GeneCycogGroups=>cycog', '*', '', {}, [ qw[ GeneCycogGroups Cycog ] ] )

#   "cycog_oid" TEXT,
#   "name" TEXT,
#   "cluster_size" TEXT,
#   "unique_taxa" TEXT,
#   "duplication_events" TEXT,
#   "description" TEXT

# 	default_columns => [ qw( gene_oid cycog.cycog_oid cycog.name cycog.description
# 	parent_tables => [ qw( Cycog GeneCycogGroups ) ]
# 	sql =>
# $schema->View("Department=>activities=>employee", '*', $sql,
#               qw/Department Activity Employee/);
# my @parents = map {$meta_schema->table($_)} @parent_tables;
# $schema->metadm->define_table(class           => $class_name,
#                               db_name         => $sql,
#                               where           => \%where,
#                               default_columns => $default_columns,
#                               parents         => \@parents);
#
#
# $schema_class->Table($class_name, $db_name, @primary_key, \%options);
# See "define_table()". The call above is equivalent to
#
# $meta_schema->define_table(class       => $class_name,
#                            db_name     => $db_name,
#                            primary_key => \@primary_key,
#                            %options);

DataModel::IMG_CyCOG->metadm->define_table(
	class       => 'GeneCycog',
	db_name     => 'gene_cycog_groups INNER JOIN CYCOG ON gene_cycog_groups.cycog_oid = cycog.cycog_oid',
#	where       => 'gene_cycog_groups.cycog_oid = cycog.cycog_oid'
	default_columns => join ", ", qw( gene_cycog_groups.gene_oid cycog.cycog_oid cycog.name cycog.description ) ,
	parents     => [ map { DataModel::IMG_CyCOG->metadm->table($_) } qw( GeneCycogGroups Cycog ) ]
);


# CREATE TABLE CYCOG(
#   "cycog_oid" TEXT,
#   "name" TEXT,
#   "cluster_size" TEXT,
#   "unique_taxa" TEXT,
#   "duplication_events" TEXT,
#   "description" TEXT
# );
# CREATE TABLE GENE_CYCOG_GROUPS(
#   "cycog_oid" TEXT,
#   "gene_oid" TEXT,
#   "taxon_oid" TEXT,
#   "cycog_version" TEXT,
#   "gene_display_name" TEXT,
#   "taxon_display_name" TEXT,
#   "paralogs" TEXT
# );
# CREATE TABLE CURRENT_CYCOG_VERSION(
#   "cycog_version" TEXT
# );
# CREATE TABLE CYCOG_RELEASE(
#   "cycog_version" TEXT,
#   "date_created" TEXT,
#   "comments" TEXT
# );
# CREATE TABLE CYCOG_TAXON(
#   "cycog_version" TEXT,
#   "taxon_oid" TEXT
# );



1;

package DataModel::CyCOG;

use IMG::Util::Import 'LogErr';
use DBIx::DataModel;
use IMG::Model::UnitConverter;
use Time::Piece;

DBIx::DataModel  # no semicolon (intentional)

#---------------------------------------------------------------------#
#                         SCHEMA DECLARATION                          #
#---------------------------------------------------------------------#
->Schema('DataModel::CyCOG')

#---------------------------------------------------------------------#
#                         TABLE DECLARATIONS                          #
#---------------------------------------------------------------------#
#          Class                      Table                         PK
#          =====                      =====                         ==
->Table(qw/GeneCycogGroups            GENE_CYCOG_GROUPS             unknown_pk   /)
->Table(qw/Cycog                      CYCOG                         id    /)
->Table(qw/CycogRelease               CYCOG_RELEASE                 version      /)
->Table(qw/CurrentCycogRelease        CURRENT_CYCOG_RELEASE         version      /)
->Table(qw/CycogTaxon                 CYCOG_TAXON                   unknown_pk   /)

->Association(
  [qw/Cycog                           cycog                    1    id    /],
  [qw/GeneCycogGroups                 cycog_genes              *    id    /])

->Association(
  [qw/CycogRelease                    release                  1    version      /],
  [qw/CycogTaxon                      taxa                     *    version      /])

->Association(
  [qw/CurrentCycogRelease             current                  1    version      /],
  [qw/CycogRelease                    release               0..1    version      /])

->Association(
  [qw/GeneCycogGroups                 cycog_genes              *    version      /],
  [qw/CycogRelease                    release                  1    version      /])
;

DataModel::CyCOG->metadm->define_table(
	class       => 'GeneCycog',
	db_name     => 'gene_cycog_groups INNER JOIN CYCOG ON gene_cycog_groups.cycog_oid = cycog.cycog_oid',
	default_columns => join ", ", qw( gene_cycog_groups.gene_oid gene_cycog_groups.taxon_oid cycog.cycog_oid cycog.description ) ,
	parents     => [ map { DataModel::CyCOG->metadm->table($_) } qw( GeneCycogGroups Cycog ) ]
);

# DBIx::DataModel->Schema('DataModel::CyCOG')->Association(
#   [qw/CycogRelease                    version                  1    cycog_version      /],
#   [qw/GeneCycog                       cycogs                   *    cycog_version      /]);

DataModel::CyCOG->Type( Date =>
	fromDB => sub {
		my $t = Time::Piece->strptime( shift, '%Y-%m-%d' );
		return $t->strftime('%d %b %Y');
	}
);

#                                           type name  => applied_to_columns
#                                           =========     ==================
DataModel::CyCOG::CycogRelease->metadm->define_column_type( Date    => qw/ date_created /);

package DataModel::CyCOG::Cycog;

sub in_versions {
	my $self = shift;
	if ( ! $self->{in_versions} ) {

		if ( ! $self->{cycog_genes} ) {
			$self->expand( 'cycog_genes' );
		}
		my $vers_h;
		for ( @{$self->{cycog_genes}} ) {
			$vers_h->{ $_->{version} }++;
		}
		$self->{in_versions} = [ sort keys %$vers_h ];
	}
	return $self->{in_versions};
}

1;

package DataModel::CyCOG::GeneCycogGroups;

sub get_paralogs {
	my $self = shift;
	return [ split ",", ( $self->{paralogs} || '' ) ];
}

1;


# CREATE TABLE CYCOG(
#   "id" TEXT,
#   "cluster_size" TEXT,
#   "unique_taxa" TEXT,
#   "duplication_events" TEXT,
#   "description" TEXT
# );
# CREATE TABLE GENE_CYCOG_GROUPS(
#   "id" TEXT,
#   "gene_oid" TEXT,
#   "taxon_oid" TEXT,
#   "version" TEXT,
#   "paralogs" TEXT
# );
# CREATE TABLE CURRENT_CYCOG_VERSION(
#   "version" TEXT
# );
# CREATE TABLE CYCOG_RELEASE(
#   "version" TEXT,
#   "date_created" TEXT,
#   "comments" TEXT
# );
# CREATE TABLE CYCOG_TAXON(
#   "version" TEXT,
#   "taxon_oid" TEXT
# );

# cycog version details

1;

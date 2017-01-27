package DataModel::IMG_Gold;

use IMG::Util::Import;
use DBIx::DataModel;
use IMG::Model::UnitConverter;

DBIx::DataModel  # no semicolon (intentional)

#---------------------------------------------------------------------#
#                         SCHEMA DECLARATION                          #
#---------------------------------------------------------------------#
->Schema('DataModel::IMG_Gold');

#---------------------------------------------------------------------#
#                         TABLE DECLARATIONS                          #
#---------------------------------------------------------------------#
#          Class                      Table                         PK
#          =====                      =====                         ==
DataModel::IMG_Gold->metadm->define_table(
  class       => 'CancelledUser',
  db_name     => 'CANCELLED_USER',
#  primary_key => '',
);

sub schema_id {
	return 'IMG_Gold';
}

1;

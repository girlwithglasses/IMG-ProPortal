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
->Table(qw/GeneCyCogGroups            GENE_CYCOG_GROUPS             unknown_pk         /)
->Table(qw/DtCyCog                    DT_CYCOG                      cycog_oid          /)

->Association(
  [qw/DtCyCog                         cycog                    1    cycog_oid             /],
  [qw/GeneCyCogGroups                 cycog_genes              *    cycog_oid             /])
;

1;

package DataModel::IMG_Test;
use strict;
use warnings;
use DBIx::DataModel;

DBIx::DataModel->Schema('DataModel::IMG_Test');
DataModel::IMG_Test->metadm->define_table(
  class       => 'Contact',
  db_name     => 'CONTACT',
  primary_key => 'contact_oid',
);
DataModel::IMG_Test->metadm->define_table(
  class       => 'CancelledUser',
  db_name     => 'CANCELLED_USER',
  primary_key => 'email',
);

1;

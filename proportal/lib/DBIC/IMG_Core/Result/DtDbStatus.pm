use utf8;
package DBIC::IMG_Core::Result::DtDbStatus;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::DtDbStatus

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DT_DB_STATUS>

=cut

__PACKAGE__->table("DT_DB_STATUS");

=head1 ACCESSORS

=head2 tag

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 val

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "tag",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "val",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GSEwqI2Av1mex6W8fPJDIA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

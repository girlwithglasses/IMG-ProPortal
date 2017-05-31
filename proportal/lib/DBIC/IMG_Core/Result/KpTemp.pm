use utf8;
package DBIC::IMG_Core::Result::KpTemp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::KpTemp

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<KP_TEMP>

=cut

__PACKAGE__->table("KP_TEMP");

=head1 ACCESSORS

=head2 sequencing_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=cut

__PACKAGE__->add_columns(
  "sequencing_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:H71FZmUMAWQwsuXImbVfIA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

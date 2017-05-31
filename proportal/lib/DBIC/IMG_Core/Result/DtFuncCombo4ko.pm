use utf8;
package DBIC::IMG_Core::Result::DtFuncCombo4ko;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::DtFuncCombo4ko

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DT_FUNC_COMBO_4KO>

=cut

__PACKAGE__->table("DT_FUNC_COMBO_4KO");

=head1 ACCESSORS

=head2 combo_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 cog_ids

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 pfam_ids

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 tigrfam_ids

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=cut

__PACKAGE__->add_columns(
  "combo_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "cog_ids",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "pfam_ids",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "tigrfam_ids",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QIYGSXSs9HZSHM0b++8UIQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

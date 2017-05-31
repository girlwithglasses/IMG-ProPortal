use utf8;
package DBIC::IMG_Sat::Result::MpwPglPathway;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::MpwPglPathway

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<MPW_PGL_PATHWAY>

=cut

__PACKAGE__->table("MPW_PGL_PATHWAY");

=head1 ACCESSORS

=head2 pathway_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 pathway_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 800

=head2 file_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 add_date

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 mpw_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 overall_reaction

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=cut

__PACKAGE__->add_columns(
  "pathway_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "pathway_name",
  { data_type => "varchar2", is_nullable => 1, size => 800 },
  "file_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "add_date",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "mpw_id",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "overall_reaction",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Xg+410DgQxL08j3viMRDbg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

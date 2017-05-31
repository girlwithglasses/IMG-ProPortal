use utf8;
package DBIC::IMG_Sat::Result::TcFamilyTfams;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::TcFamilyTfams

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TC_FAMILY_TFAMS>

=cut

__PACKAGE__->table("TC_FAMILY_TFAMS");

=head1 ACCESSORS

=head2 tc_family_num

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 tfams

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 50

=head2 exceptions

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 tc_num

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "tc_family_num",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "tfams",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 50 },
  "exceptions",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "tc_num",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);

=head1 RELATIONS

=head2 tfam

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::Tigrfam>

=cut

__PACKAGE__->belongs_to(
  "tfam",
  "DBIC::IMG_Sat::Result::Tigrfam",
  { ext_accession => "tfams" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8sSSuXhjiD9MwGO/xTbvAw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

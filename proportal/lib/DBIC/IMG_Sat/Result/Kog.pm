use utf8;
package DBIC::IMG_Sat::Result::Kog;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::Kog

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<KOG>

=cut

__PACKAGE__->table("KOG");

=head1 ACCESSORS

=head2 kog_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 kog_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 db_source

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 255

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 seq_length

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "kog_id",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "kog_name",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "db_source",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 255 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "seq_length",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</kog_id>

=back

=cut

__PACKAGE__->set_primary_key("kog_id");

=head1 RELATIONS

=head2 kog_families

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KogFamilies>

=cut

__PACKAGE__->has_many(
  "kog_families",
  "DBIC::IMG_Sat::Result::KogFamilies",
  { "foreign.kog_id" => "self.kog_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 kog_functions

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KogFunctions>

=cut

__PACKAGE__->has_many(
  "kog_functions",
  "DBIC::IMG_Sat::Result::KogFunctions",
  { "foreign.kog_id" => "self.kog_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 kog_pathway_kog_members

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KogPathwayKogMembers>

=cut

__PACKAGE__->has_many(
  "kog_pathway_kog_members",
  "DBIC::IMG_Sat::Result::KogPathwayKogMembers",
  { "foreign.kog_members" => "self.kog_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:43:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mmQXANqaH9I61Sk2rixCqw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

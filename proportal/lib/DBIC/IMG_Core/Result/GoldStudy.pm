use utf8;
package DBIC::IMG_Core::Result::GoldStudy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GoldStudy

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GOLD_STUDY>

=cut

__PACKAGE__->table("GOLD_STUDY");

=head1 ACCESSORS

=head2 study_id

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 gold_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 study_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 contact_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 contact_email

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 ecosystem_category

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 ecosystem_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 ecosystem_subtype

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 specific_ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "study_id",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "gold_id",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "study_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "contact_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "contact_email",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem_category",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem_type",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem_subtype",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "specific_ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</study_id>

=back

=cut

__PACKAGE__->set_primary_key("study_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-07-13 15:21:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+TBTxCs/IAEYgMSd+S+SfQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

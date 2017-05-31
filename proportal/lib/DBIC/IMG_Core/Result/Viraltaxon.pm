use utf8;
package DBIC::IMG_Core::Result::Viraltaxon;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::Viraltaxon

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<VIRALTAXONS>

=cut

__PACKAGE__->table("VIRALTAXONS");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 mol_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 scaffold_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 accession_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 type

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 bioproject_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 scaffold_source

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 project_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 gold_stamp_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "mol_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "scaffold_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "accession_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "type",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "bioproject_accession",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "scaffold_source",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "project_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "gold_stamp_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SvoreEDjlZ/lRDpL+mlXRg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

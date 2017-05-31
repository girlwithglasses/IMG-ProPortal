use utf8;
package DBIC::IMG_Sat::Result::Tigrfam;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::Tigrfam

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TIGRFAM>

=cut

__PACKAGE__->table("TIGRFAM");

=head1 ACCESSORS

=head2 ext_accession

  data_type: 'varchar2'
  is_nullable: 0
  size: 50

=head2 abbr_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 expanded_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 isology_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 gene_symbol

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ls_nc_model

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=head2 ls_nc_domain

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=head2 ls_ga_model

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=head2 ls_ga_domain

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=head2 ls_tc_model

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=head2 ls_tc_domain

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=cut

__PACKAGE__->add_columns(
  "ext_accession",
  { data_type => "varchar2", is_nullable => 0, size => 50 },
  "abbr_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "expanded_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "isology_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "gene_symbol",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ls_nc_model",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 5],
  },
  "ls_nc_domain",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 5],
  },
  "ls_ga_model",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 5],
  },
  "ls_ga_domain",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 5],
  },
  "ls_tc_model",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 5],
  },
  "ls_tc_domain",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 5],
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</ext_accession>

=back

=cut

__PACKAGE__->set_primary_key("ext_accession");

=head1 RELATIONS

=head2 tc_family_tfams

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::TcFamilyTfams>

=cut

__PACKAGE__->has_many(
  "tc_family_tfams",
  "DBIC::IMG_Sat::Result::TcFamilyTfams",
  { "foreign.tfams" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tigrfam_enzymes

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::TigrfamEnzymes>

=cut

__PACKAGE__->has_many(
  "tigrfam_enzymes",
  "DBIC::IMG_Sat::Result::TigrfamEnzymes",
  { "foreign.ext_accession" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tigrfam_genome_properties

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::TigrfamGenomeProperties>

=cut

__PACKAGE__->has_many(
  "tigrfam_genome_properties",
  "DBIC::IMG_Sat::Result::TigrfamGenomeProperties",
  { "foreign.ext_accession" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tigrfam_roles

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::TigrfamRoles>

=cut

__PACKAGE__->has_many(
  "tigrfam_roles",
  "DBIC::IMG_Sat::Result::TigrfamRoles",
  { "foreign.ext_accession" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9AXzAmSbGbparvbQlZWvSw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

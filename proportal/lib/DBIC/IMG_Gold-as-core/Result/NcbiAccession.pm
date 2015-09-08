use utf8;
package DbSchema::IMG_Core::Result::NcbiAccession;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::NcbiAccession

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<NCBI_ACCESSIONS>

=cut

__PACKAGE__->table("NCBI_ACCESSIONS");

=head1 ACCESSORS

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

=head2 assembly_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 gold_analysis_project_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
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
  "assembly_accession",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "gold_analysis_project_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<unique_scaffold_id>

=over 4

=item * L</accession_id>

=back

=cut

__PACKAGE__->add_unique_constraint("unique_scaffold_id", ["accession_id"]);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SwX7wyoic1jD3dklts5sdQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

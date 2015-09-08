use utf8;
package DbSchema::IMG_Core::Result::Biosample;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::Biosample

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<BIOSAMPLE>

=cut

__PACKAGE__->table("BIOSAMPLE");

=head1 ACCESSORS

=head2 biosample_id

  data_type: 'numeric'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number"}
  sequence: 'biosample_pk_seq'
  size: 126

=head2 biosample_accession

  data_type: 'varchar2'
  is_nullable: 0
  size: 120

=head2 migs_model

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 ncbi_biosample_id

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 sra_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 biosample_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 1000

=head2 project_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 ncbi_bioproject_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=cut

__PACKAGE__->add_columns(
  "biosample_id",
  {
    data_type => "numeric",
    is_auto_increment => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    sequence => "biosample_pk_seq",
    size => 126,
  },
  "biosample_accession",
  { data_type => "varchar2", is_nullable => 0, size => 120 },
  "migs_model",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "ncbi_biosample_id",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "sra_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "biosample_name",
  { data_type => "varchar2", is_nullable => 0, size => 1000 },
  "project_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "ncbi_bioproject_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</biosample_id>

=back

=cut

__PACKAGE__->set_primary_key("biosample_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<biosample_uk1>

=over 4

=item * L</biosample_accession>

=back

=cut

__PACKAGE__->add_unique_constraint("biosample_uk1", ["biosample_accession"]);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4iCmYiOIgCIEQ79l0JvnPg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

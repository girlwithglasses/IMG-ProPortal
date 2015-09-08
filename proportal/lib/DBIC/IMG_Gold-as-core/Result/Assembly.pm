use utf8;
package DbSchema::IMG_Core::Result::Assembly;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::Assembly

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ASSEMBLY>

=cut

__PACKAGE__->table("ASSEMBLY");

=head1 ACCESSORS

=head2 assembly_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 its_spid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 pmo_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 organism_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 library_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 24

=head2 genome_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 assembly_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 analyst_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 release_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 3000

=head2 dir_num

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 rqc_assembly_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 assembly_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 qc_report_location

  data_type: 'varchar2'
  is_nullable: 1
  size: 2000

=cut

__PACKAGE__->add_columns(
  "assembly_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "its_spid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "pmo_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "organism_name",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "library_name",
  { data_type => "varchar2", is_nullable => 1, size => 24 },
  "genome_type",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "assembly_type",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "analyst_name",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "release_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 3000 },
  "dir_num",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "rqc_assembly_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "assembly_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "qc_report_location",
  { data_type => "varchar2", is_nullable => 1, size => 2000 },
);

=head1 PRIMARY KEY

=over 4

=item * L</assembly_id>

=back

=cut

__PACKAGE__->set_primary_key("assembly_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UrNGzYa3YVKq059lgOepIQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

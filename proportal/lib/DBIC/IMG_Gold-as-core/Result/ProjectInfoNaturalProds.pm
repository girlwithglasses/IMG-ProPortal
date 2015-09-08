use utf8;
package DbSchema::IMG_Core::Result::ProjectInfoNaturalProds;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ProjectInfoNaturalProds

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<PROJECT_INFO_NATURAL_PRODS>

=cut

__PACKAGE__->table("PROJECT_INFO_NATURAL_PRODS");

=head1 ACCESSORS

=head2 gold_np_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 np_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 project_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 img_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 bio_cluster_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 genbank_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 evidence

  data_type: 'varchar2'
  default_value: 'Experimental'
  is_nullable: 0
  size: 20

=head2 activity

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 modified_by

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "gold_np_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "np_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "project_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "img_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "bio_cluster_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "genbank_id",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "evidence",
  {
    data_type => "varchar2",
    default_value => "Experimental",
    is_nullable => 0,
    size => 20,
  },
  "activity",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "modified_by",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</gold_np_id>

=back

=cut

__PACKAGE__->set_primary_key("gold_np_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:puhddNpB0SQlQ+LSTIJRkQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

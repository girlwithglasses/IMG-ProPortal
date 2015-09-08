use utf8;
package DbSchema::IMG_Core::Result::ProjectInfoNprodsMetadata;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ProjectInfoNprodsMetadata

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<PROJECT_INFO_NPRODS_METADATA>

=cut

__PACKAGE__->table("PROJECT_INFO_NPRODS_METADATA");

=head1 ACCESSORS

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

=head2 np_product_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 np_product_link

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 np_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 np_activity

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 bio_clusters

  data_type: 'varchar2'
  is_nullable: 1
  size: 4

=head2 genbank_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 img_biocluster_link

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 evidence

  data_type: 'varchar2'
  default_value: 'Experimental'
  is_nullable: 0
  size: 20

=cut

__PACKAGE__->add_columns(
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
  "np_product_name",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "np_product_link",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "np_type",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "np_activity",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "bio_clusters",
  { data_type => "varchar2", is_nullable => 1, size => 4 },
  "genbank_id",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "img_biocluster_link",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "evidence",
  {
    data_type => "varchar2",
    default_value => "Experimental",
    is_nullable => 0,
    size => 20,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</np_id>

=back

=cut

__PACKAGE__->set_primary_key("np_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RgRM34yEccAYRor1MB84HA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

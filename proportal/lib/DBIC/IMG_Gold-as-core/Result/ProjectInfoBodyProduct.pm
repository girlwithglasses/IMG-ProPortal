use utf8;
package DbSchema::IMG_Core::Result::ProjectInfoBodyProduct;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ProjectInfoBodyProduct

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<PROJECT_INFO_BODY_PRODUCTS>

=cut

__PACKAGE__->table("PROJECT_INFO_BODY_PRODUCTS");

=head1 ACCESSORS

=head2 pibp_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}
  sequence: 'pibp_id_seq'

=head2 project_oid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 body_product

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "pibp_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    original          => { data_type => "number", size => [38, 0] },
    sequence          => "pibp_id_seq",
  },
  "project_oid",
  {
    data_type      => "integer",
    is_foreign_key => 1,
    is_nullable    => 0,
    original       => { data_type => "number", size => [38, 0] },
  },
  "body_product",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</pibp_id>

=back

=cut

__PACKAGE__->set_primary_key("pibp_id");

=head1 RELATIONS

=head2 project_oid

Type: belongs_to

Related object: L<DbSchema::IMG_Core::Result::ProjectInfo>

=cut

__PACKAGE__->belongs_to(
  "project_oid",
  "DbSchema::IMG_Core::Result::ProjectInfo",
  { project_oid => "project_oid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xfi4xlNFEjF1m20GMHZPJg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

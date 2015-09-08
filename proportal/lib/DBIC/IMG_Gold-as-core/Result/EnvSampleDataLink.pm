use utf8;
package DbSchema::IMG_Core::Result::EnvSampleDataLink;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::EnvSampleDataLink

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ENV_SAMPLE_DATA_LINKS>

=cut

__PACKAGE__->table("ENV_SAMPLE_DATA_LINKS");

=head1 ACCESSORS

=head2 sample_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 db_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 id

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 url

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 link_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "sample_oid",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "db_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "id",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "url",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "link_type",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);

=head1 RELATIONS

=head2 sample_oid

Type: belongs_to

Related object: L<DbSchema::IMG_Core::Result::EnvSample>

=cut

__PACKAGE__->belongs_to(
  "sample_oid",
  "DbSchema::IMG_Core::Result::EnvSample",
  { sample_oid => "sample_oid" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:beNawq9USXKxvSVPWJ1RXg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

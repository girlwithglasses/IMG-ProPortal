use utf8;
package DbSchema::IMG_Core::Result::OraAspnetSitemap;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraAspnetSitemap

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ORA_ASPNET_SITEMAP>

=cut

__PACKAGE__->table("ORA_ASPNET_SITEMAP");

=head1 ACCESSORS

=head2 applicationid

  data_type: 'raw'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [10,0]

=head2 title

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 32

=head2 description

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 512

=head2 url

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 512

=head2 roles

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 512

=head2 parent

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [10,0]

=cut

__PACKAGE__->add_columns(
  "applicationid",
  { data_type => "raw", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [10, 0],
  },
  "title",
  { data_type => "nvarchar2", is_nullable => 1, size => 32 },
  "description",
  { data_type => "nvarchar2", is_nullable => 1, size => 512 },
  "url",
  { data_type => "nvarchar2", is_nullable => 1, size => 512 },
  "roles",
  { data_type => "nvarchar2", is_nullable => 1, size => 512 },
  "parent",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [10, 0],
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</applicationid>

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("applicationid", "id");

=head1 RELATIONS

=head2 applicationid

Type: belongs_to

Related object: L<DbSchema::IMG_Core::Result::OraAspnetApplication>

=cut

__PACKAGE__->belongs_to(
  "applicationid",
  "DbSchema::IMG_Core::Result::OraAspnetApplication",
  { applicationid => "applicationid" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DR4N52wKOXRnm3WPc91ZQA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

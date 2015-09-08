use utf8;
package DbSchema::IMG_Core::Result::OraAspnetPersonaliznperuser;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraAspnetPersonaliznperuser

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ORA_ASPNET_PERSONALIZNPERUSER>

=cut

__PACKAGE__->table("ORA_ASPNET_PERSONALIZNPERUSER");

=head1 ACCESSORS

=head2 id

  data_type: 'raw'
  default_value: SYS_GUID()
  is_nullable: 0
  size: 16

=head2 pathid

  data_type: 'raw'
  is_foreign_key: 1
  is_nullable: 1
  size: 16

=head2 userid

  data_type: 'raw'
  is_foreign_key: 1
  is_nullable: 1
  size: 16

=head2 pagesettings

  data_type: 'blob'
  is_nullable: 0

=head2 lastupdateddate

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "raw",
    default_value => \"SYS_GUID()",
    is_nullable => 0,
    size => 16,
  },
  "pathid",
  { data_type => "raw", is_foreign_key => 1, is_nullable => 1, size => 16 },
  "userid",
  { data_type => "raw", is_foreign_key => 1, is_nullable => 1, size => 16 },
  "pagesettings",
  { data_type => "blob", is_nullable => 0 },
  "lastupdateddate",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 pathid

Type: belongs_to

Related object: L<DbSchema::IMG_Core::Result::OraAspnetPath>

=cut

__PACKAGE__->belongs_to(
  "pathid",
  "DbSchema::IMG_Core::Result::OraAspnetPath",
  { pathid => "pathid" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 userid

Type: belongs_to

Related object: L<DbSchema::IMG_Core::Result::OraAspnetUser>

=cut

__PACKAGE__->belongs_to(
  "userid",
  "DbSchema::IMG_Core::Result::OraAspnetUser",
  { userid => "userid" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:i3jHoGU6I4RZIkugd4zWtg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

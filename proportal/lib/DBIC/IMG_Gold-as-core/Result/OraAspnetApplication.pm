use utf8;
package DbSchema::IMG_Core::Result::OraAspnetApplication;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraAspnetApplication

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ORA_ASPNET_APPLICATIONS>

=cut

__PACKAGE__->table("ORA_ASPNET_APPLICATIONS");

=head1 ACCESSORS

=head2 applicationname

  data_type: 'nvarchar2'
  is_nullable: 0
  size: 256

=head2 loweredapplicationname

  data_type: 'nvarchar2'
  is_nullable: 0
  size: 256

=head2 applicationid

  data_type: 'raw'
  default_value: SYS_GUID()
  is_nullable: 0
  size: 16

=head2 description

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 256

=cut

__PACKAGE__->add_columns(
  "applicationname",
  { data_type => "nvarchar2", is_nullable => 0, size => 256 },
  "loweredapplicationname",
  { data_type => "nvarchar2", is_nullable => 0, size => 256 },
  "applicationid",
  {
    data_type => "raw",
    default_value => \"SYS_GUID()",
    is_nullable => 0,
    size => 16,
  },
  "description",
  { data_type => "nvarchar2", is_nullable => 1, size => 256 },
);

=head1 PRIMARY KEY

=over 4

=item * L</applicationid>

=back

=cut

__PACKAGE__->set_primary_key("applicationid");

=head1 UNIQUE CONSTRAINTS

=head2 C<sys_c0034003>

=over 4

=item * L</applicationname>

=back

=cut

__PACKAGE__->add_unique_constraint("sys_c0034003", ["applicationname"]);

=head2 C<sys_c0034004>

=over 4

=item * L</loweredapplicationname>

=back

=cut

__PACKAGE__->add_unique_constraint("sys_c0034004", ["loweredapplicationname"]);

=head1 RELATIONS

=head2 ora_aspnet_memberships

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::OraAspnetMembership>

=cut

__PACKAGE__->has_many(
  "ora_aspnet_memberships",
  "DbSchema::IMG_Core::Result::OraAspnetMembership",
  { "foreign.applicationid" => "self.applicationid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ora_aspnet_paths

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::OraAspnetPath>

=cut

__PACKAGE__->has_many(
  "ora_aspnet_paths",
  "DbSchema::IMG_Core::Result::OraAspnetPath",
  { "foreign.applicationid" => "self.applicationid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ora_aspnet_roles

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::OraAspnetRole>

=cut

__PACKAGE__->has_many(
  "ora_aspnet_roles",
  "DbSchema::IMG_Core::Result::OraAspnetRole",
  { "foreign.applicationid" => "self.applicationid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ora_aspnet_sitemaps

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::OraAspnetSitemap>

=cut

__PACKAGE__->has_many(
  "ora_aspnet_sitemaps",
  "DbSchema::IMG_Core::Result::OraAspnetSitemap",
  { "foreign.applicationid" => "self.applicationid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ora_aspnet_users

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::OraAspnetUser>

=cut

__PACKAGE__->has_many(
  "ora_aspnet_users",
  "DbSchema::IMG_Core::Result::OraAspnetUser",
  { "foreign.applicationid" => "self.applicationid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:10SZdG4p9Wb4Cfzz/Rpa4A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

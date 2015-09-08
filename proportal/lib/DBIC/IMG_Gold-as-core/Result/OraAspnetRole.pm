use utf8;
package DbSchema::IMG_Core::Result::OraAspnetRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraAspnetRole

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ORA_ASPNET_ROLES>

=cut

__PACKAGE__->table("ORA_ASPNET_ROLES");

=head1 ACCESSORS

=head2 applicationid

  data_type: 'raw'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 roleid

  data_type: 'raw'
  default_value: SYS_GUID()
  is_nullable: 0
  size: 16

=head2 rolename

  data_type: 'nvarchar2'
  is_nullable: 0
  size: 256

=head2 loweredrolename

  data_type: 'nvarchar2'
  is_nullable: 0
  size: 256

=head2 description

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 256

=cut

__PACKAGE__->add_columns(
  "applicationid",
  { data_type => "raw", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "roleid",
  {
    data_type => "raw",
    default_value => \"SYS_GUID()",
    is_nullable => 0,
    size => 16,
  },
  "rolename",
  { data_type => "nvarchar2", is_nullable => 0, size => 256 },
  "loweredrolename",
  { data_type => "nvarchar2", is_nullable => 0, size => 256 },
  "description",
  { data_type => "nvarchar2", is_nullable => 1, size => 256 },
);

=head1 PRIMARY KEY

=over 4

=item * L</roleid>

=back

=cut

__PACKAGE__->set_primary_key("roleid");

=head1 RELATIONS

=head2 applicationid

Type: belongs_to

Related object: L<DbSchema::IMG_Core::Result::OraAspnetApplication>

=cut

__PACKAGE__->belongs_to(
  "applicationid",
  "DbSchema::IMG_Core::Result::OraAspnetApplication",
  { applicationid => "applicationid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 ora_aspnet_usersinroles

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::OraAspnetUsersinrole>

=cut

__PACKAGE__->has_many(
  "ora_aspnet_usersinroles",
  "DbSchema::IMG_Core::Result::OraAspnetUsersinrole",
  { "foreign.roleid" => "self.roleid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 userids

Type: many_to_many

Composing rels: L</ora_aspnet_usersinroles> -> userid

=cut

__PACKAGE__->many_to_many("userids", "ora_aspnet_usersinroles", "userid");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:c0ARC5YzL09i6g0qGEe1SQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DbSchema::IMG_Core::Result::OraAspnetUser;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraAspnetUser

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ORA_ASPNET_USERS>

=cut

__PACKAGE__->table("ORA_ASPNET_USERS");

=head1 ACCESSORS

=head2 applicationid

  data_type: 'raw'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 userid

  data_type: 'raw'
  default_value: SYS_GUID()
  is_nullable: 0
  size: 16

=head2 username

  data_type: 'nvarchar2'
  is_nullable: 0
  size: 256

=head2 loweredusername

  data_type: 'nvarchar2'
  is_nullable: 0
  size: 256

=head2 mobilealias

  data_type: 'nvarchar2'
  default_value: null
  is_nullable: 1
  size: 16

=head2 isanonymous

  data_type: 'integer'
  default_value: 0
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 lastactivitydate

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "applicationid",
  { data_type => "raw", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "userid",
  {
    data_type => "raw",
    default_value => \"SYS_GUID()",
    is_nullable => 0,
    size => 16,
  },
  "username",
  { data_type => "nvarchar2", is_nullable => 0, size => 256 },
  "loweredusername",
  { data_type => "nvarchar2", is_nullable => 0, size => 256 },
  "mobilealias",
  {
    data_type => "nvarchar2",
    default_value => \"null",
    is_nullable => 1,
    size => 16,
  },
  "isanonymous",
  {
    data_type     => "integer",
    default_value => 0,
    is_nullable   => 0,
    original      => { data_type => "number", size => [38, 0] },
  },
  "lastactivitydate",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</userid>

=back

=cut

__PACKAGE__->set_primary_key("userid");

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

=head2 ora_aspnet_membership

Type: might_have

Related object: L<DbSchema::IMG_Core::Result::OraAspnetMembership>

=cut

__PACKAGE__->might_have(
  "ora_aspnet_membership",
  "DbSchema::IMG_Core::Result::OraAspnetMembership",
  { "foreign.userid" => "self.userid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ora_aspnet_personaliznperusers

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::OraAspnetPersonaliznperuser>

=cut

__PACKAGE__->has_many(
  "ora_aspnet_personaliznperusers",
  "DbSchema::IMG_Core::Result::OraAspnetPersonaliznperuser",
  { "foreign.userid" => "self.userid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ora_aspnet_profile

Type: might_have

Related object: L<DbSchema::IMG_Core::Result::OraAspnetProfile>

=cut

__PACKAGE__->might_have(
  "ora_aspnet_profile",
  "DbSchema::IMG_Core::Result::OraAspnetProfile",
  { "foreign.userid" => "self.userid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ora_aspnet_usersinroles

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::OraAspnetUsersinrole>

=cut

__PACKAGE__->has_many(
  "ora_aspnet_usersinroles",
  "DbSchema::IMG_Core::Result::OraAspnetUsersinrole",
  { "foreign.userid" => "self.userid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roleids

Type: many_to_many

Composing rels: L</ora_aspnet_usersinroles> -> roleid

=cut

__PACKAGE__->many_to_many("roleids", "ora_aspnet_usersinroles", "roleid");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aapL4+fluT6uzx62itbFbA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

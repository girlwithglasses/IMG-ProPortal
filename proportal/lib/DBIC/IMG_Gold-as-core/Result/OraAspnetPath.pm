use utf8;
package DbSchema::IMG_Core::Result::OraAspnetPath;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraAspnetPath

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ORA_ASPNET_PATHS>

=cut

__PACKAGE__->table("ORA_ASPNET_PATHS");

=head1 ACCESSORS

=head2 applicationid

  data_type: 'raw'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 pathid

  data_type: 'raw'
  default_value: SYS_GUID()
  is_nullable: 0
  size: 16

=head2 path

  data_type: 'nvarchar2'
  is_nullable: 0
  size: 256

=head2 loweredpath

  data_type: 'nvarchar2'
  is_nullable: 0
  size: 256

=cut

__PACKAGE__->add_columns(
  "applicationid",
  { data_type => "raw", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "pathid",
  {
    data_type => "raw",
    default_value => \"SYS_GUID()",
    is_nullable => 0,
    size => 16,
  },
  "path",
  { data_type => "nvarchar2", is_nullable => 0, size => 256 },
  "loweredpath",
  { data_type => "nvarchar2", is_nullable => 0, size => 256 },
);

=head1 PRIMARY KEY

=over 4

=item * L</pathid>

=back

=cut

__PACKAGE__->set_primary_key("pathid");

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

=head2 ora_aspnet_personaliznallusers

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::OraAspnetPersonaliznalluser>

=cut

__PACKAGE__->has_many(
  "ora_aspnet_personaliznallusers",
  "DbSchema::IMG_Core::Result::OraAspnetPersonaliznalluser",
  { "foreign.pathid" => "self.pathid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ora_aspnet_personaliznperusers

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::OraAspnetPersonaliznperuser>

=cut

__PACKAGE__->has_many(
  "ora_aspnet_personaliznperusers",
  "DbSchema::IMG_Core::Result::OraAspnetPersonaliznperuser",
  { "foreign.pathid" => "self.pathid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iRX9hmr3IKtq0R8fv1OAaQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

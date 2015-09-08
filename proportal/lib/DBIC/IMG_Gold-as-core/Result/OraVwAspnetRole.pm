use utf8;
package DbSchema::IMG_Core::Result::OraVwAspnetRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraVwAspnetRole

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<ORA_VW_ASPNET_ROLES>

=cut

__PACKAGE__->table("ORA_VW_ASPNET_ROLES");

=head1 ACCESSORS

=head2 applicationid

  data_type: 'raw'
  is_nullable: 0
  size: 16

=head2 roleid

  data_type: 'raw'
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
  { data_type => "raw", is_nullable => 0, size => 16 },
  "roleid",
  { data_type => "raw", is_nullable => 0, size => 16 },
  "rolename",
  { data_type => "nvarchar2", is_nullable => 0, size => 256 },
  "loweredrolename",
  { data_type => "nvarchar2", is_nullable => 0, size => 256 },
  "description",
  { data_type => "nvarchar2", is_nullable => 1, size => 256 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:erT3VOqW0zi76iqCdwIhHQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

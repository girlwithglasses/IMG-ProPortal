use utf8;
package DbSchema::IMG_Core::Result::OraVwAspnetUser;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraVwAspnetUser

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<ORA_VW_ASPNET_USERS>

=cut

__PACKAGE__->table("ORA_VW_ASPNET_USERS");

=head1 ACCESSORS

=head2 applicationid

  data_type: 'raw'
  is_nullable: 0
  size: 16

=head2 userid

  data_type: 'raw'
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
  is_nullable: 1
  size: 16

=head2 isanonymous

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 lastactivitydate

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "applicationid",
  { data_type => "raw", is_nullable => 0, size => 16 },
  "userid",
  { data_type => "raw", is_nullable => 0, size => 16 },
  "username",
  { data_type => "nvarchar2", is_nullable => 0, size => 256 },
  "loweredusername",
  { data_type => "nvarchar2", is_nullable => 0, size => 256 },
  "mobilealias",
  { data_type => "nvarchar2", is_nullable => 1, size => 16 },
  "isanonymous",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "lastactivitydate",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1r1tgiPwm+cOz52tcFCvJg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

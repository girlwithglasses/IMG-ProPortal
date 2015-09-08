use utf8;
package DbSchema::IMG_Core::Result::OraAspnetProfile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraAspnetProfile

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ORA_ASPNET_PROFILE>

=cut

__PACKAGE__->table("ORA_ASPNET_PROFILE");

=head1 ACCESSORS

=head2 userid

  data_type: 'raw'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 propertynames

  data_type: 'nclob'
  is_nullable: 0

=head2 propertyvaluesstring

  data_type: 'nclob'
  is_nullable: 0

=head2 propertyvaluesbinary

  data_type: 'blob'
  is_nullable: 0

=head2 lastupdateddate

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "userid",
  { data_type => "raw", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "propertynames",
  { data_type => "nclob", is_nullable => 0 },
  "propertyvaluesstring",
  { data_type => "nclob", is_nullable => 0 },
  "propertyvaluesbinary",
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

=item * L</userid>

=back

=cut

__PACKAGE__->set_primary_key("userid");

=head1 RELATIONS

=head2 userid

Type: belongs_to

Related object: L<DbSchema::IMG_Core::Result::OraAspnetUser>

=cut

__PACKAGE__->belongs_to(
  "userid",
  "DbSchema::IMG_Core::Result::OraAspnetUser",
  { userid => "userid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YF3X/HUObe71GZoM0JD0JQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

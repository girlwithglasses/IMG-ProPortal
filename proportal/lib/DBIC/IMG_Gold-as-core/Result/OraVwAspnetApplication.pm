use utf8;
package DbSchema::IMG_Core::Result::OraVwAspnetApplication;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraVwAspnetApplication

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<ORA_VW_ASPNET_APPLICATIONS>

=cut

__PACKAGE__->table("ORA_VW_ASPNET_APPLICATIONS");

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
  { data_type => "raw", is_nullable => 0, size => 16 },
  "description",
  { data_type => "nvarchar2", is_nullable => 1, size => 256 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZOTGP/tgnrX3Jq5QsnDtcg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DbSchema::IMG_Core::Result::OraVwAspnetUir;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraVwAspnetUir

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<ORA_VW_ASPNET_UIR>

=cut

__PACKAGE__->table("ORA_VW_ASPNET_UIR");

=head1 ACCESSORS

=head2 userid

  data_type: 'raw'
  is_nullable: 0
  size: 16

=head2 roleid

  data_type: 'raw'
  is_nullable: 0
  size: 16

=cut

__PACKAGE__->add_columns(
  "userid",
  { data_type => "raw", is_nullable => 0, size => 16 },
  "roleid",
  { data_type => "raw", is_nullable => 0, size => 16 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gPAdakWLO5Ujc1iE2s2Pyg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

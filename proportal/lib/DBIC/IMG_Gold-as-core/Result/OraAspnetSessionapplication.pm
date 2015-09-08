use utf8;
package DbSchema::IMG_Core::Result::OraAspnetSessionapplication;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraAspnetSessionapplication

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ORA_ASPNET_SESSIONAPPLICATIONS>

=cut

__PACKAGE__->table("ORA_ASPNET_SESSIONAPPLICATIONS");

=head1 ACCESSORS

=head2 appid

  data_type: 'raw'
  is_nullable: 0
  size: 16

=head2 appname

  data_type: 'nvarchar2'
  is_nullable: 0
  size: 280

=cut

__PACKAGE__->add_columns(
  "appid",
  { data_type => "raw", is_nullable => 0, size => 16 },
  "appname",
  { data_type => "nvarchar2", is_nullable => 0, size => 280 },
);

=head1 PRIMARY KEY

=over 4

=item * L</appid>

=back

=cut

__PACKAGE__->set_primary_key("appid");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gpXChjCILnvsBQyP5TluGA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

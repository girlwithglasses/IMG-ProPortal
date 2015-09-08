use utf8;
package DbSchema::IMG_Core::Result::ContactSamplePermission;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ContactSamplePermission

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<CONTACT_SAMPLE_PERMISSIONS>

=cut

__PACKAGE__->table("CONTACT_SAMPLE_PERMISSIONS");

=head1 ACCESSORS

=head2 contact_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 sample_permissions

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "contact_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "sample_permissions",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:48O8CkIlFzttz4zwetKpdA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DbSchema::IMG_Core::Result::ContactImgGroup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ContactImgGroup

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<CONTACT_IMG_GROUPS>

=cut

__PACKAGE__->table("CONTACT_IMG_GROUPS");

=head1 ACCESSORS

=head2 contact_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 img_group

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 role

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "contact_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "img_group",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "role",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZQfWMcH4D0ITdhQavWwunA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DbSchema::IMG_Core::Result::WebPageCodecv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::WebPageCodecv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<WEB_PAGE_CODECV>

=cut

__PACKAGE__->table("WEB_PAGE_CODECV");

=head1 ACCESSORS

=head2 term_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=cut

__PACKAGE__->add_columns(
  "term_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
);

=head1 PRIMARY KEY

=over 4

=item * L</term_oid>

=back

=cut

__PACKAGE__->set_primary_key("term_oid");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YsUHzTeLpNZNj2ld6u2E1w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

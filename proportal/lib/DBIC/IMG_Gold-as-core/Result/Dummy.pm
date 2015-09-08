use utf8;
package DbSchema::IMG_Core::Result::Dummy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::Dummy

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<DUMMY>

=cut

__PACKAGE__->table("DUMMY");

=head1 ACCESSORS

=head2 a

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "a",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:93wSdlLnjnpbPB49N3X5+A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

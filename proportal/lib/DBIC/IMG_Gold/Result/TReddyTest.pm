use utf8;
package DBIC::IMG_Gold::Result::TReddyTest;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::TReddyTest

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<T_REDDY_TEST>

=cut

__PACKAGE__->table("T_REDDY_TEST");

=head1 ACCESSORS

=head2 id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 name

  data_type: 'char'
  is_nullable: 1
  size: 22

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "name",
  { data_type => "char", is_nullable => 1, size => 22 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XV8qJ+NKTO4YvzxXyA0t6Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

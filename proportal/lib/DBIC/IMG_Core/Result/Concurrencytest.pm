use utf8;
package DBIC::IMG_Core::Result::Concurrencytest;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::Concurrencytest

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<CONCURRENCYTEST>

=cut

__PACKAGE__->table("CONCURRENCYTEST");

=head1 ACCESSORS

=head2 a

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
  "a",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:d8AGr0xDK8ZnQ2RKxykYEA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

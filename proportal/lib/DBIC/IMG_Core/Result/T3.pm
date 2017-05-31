use utf8;
package DBIC::IMG_Core::Result::T3;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::T3

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<T3>

=cut

__PACKAGE__->table("T3");

=head1 ACCESSORS

=head2 f1

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 f2

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 f3

  data_type: 'varchar2'
  is_nullable: 1
  size: 40

=cut

__PACKAGE__->add_columns(
  "f1",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "f2",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "f3",
  { data_type => "varchar2", is_nullable => 1, size => 40 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YWcmaWp44JMmsaN/fTtCsQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

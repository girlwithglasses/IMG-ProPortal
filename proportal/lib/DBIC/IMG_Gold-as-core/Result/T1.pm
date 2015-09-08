use utf8;
package DbSchema::IMG_Core::Result::T1;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::T1

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<T1>

=cut

__PACKAGE__->table("T1");

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
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kn6lHwzkYPFO+d7vH1xNUg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

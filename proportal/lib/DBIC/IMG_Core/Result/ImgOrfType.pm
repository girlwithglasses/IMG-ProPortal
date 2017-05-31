use utf8;
package DBIC::IMG_Core::Result::ImgOrfType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::ImgOrfType

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<IMG_ORF_TYPE>

=cut

__PACKAGE__->table("IMG_ORF_TYPE");

=head1 ACCESSORS

=head2 orf_type

  data_type: 'varchar2'
  is_nullable: 0
  size: 100

=head2 definition

  data_type: 'varchar2'
  is_nullable: 0
  size: 4000

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=head2 modified_by

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "orf_type",
  { data_type => "varchar2", is_nullable => 0, size => 100 },
  "definition",
  { data_type => "varchar2", is_nullable => 0, size => 4000 },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
  "modified_by",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</orf_type>

=back

=cut

__PACKAGE__->set_primary_key("orf_type");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hN6oP5ViQ5XejvQWAPJqqg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

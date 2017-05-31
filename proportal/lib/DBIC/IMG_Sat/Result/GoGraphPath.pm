use utf8;
package DBIC::IMG_Sat::Result::GoGraphPath;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::GoGraphPath

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GO_GRAPH_PATH>

=cut

__PACKAGE__->table("GO_GRAPH_PATH");

=head1 ACCESSORS

=head2 graph_path_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 term_1

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 255

=head2 term_2

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 255

=head2 distance

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "graph_path_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "term_1",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 255 },
  "term_2",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 255 },
  "distance",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</graph_path_id>

=back

=cut

__PACKAGE__->set_primary_key("graph_path_id");

=head1 RELATIONS

=head2 term_1

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::GoTerm>

=cut

__PACKAGE__->belongs_to(
  "term_1",
  "DBIC::IMG_Sat::Result::GoTerm",
  { go_id => "term_1" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 term_2

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::GoTerm>

=cut

__PACKAGE__->belongs_to(
  "term_2",
  "DBIC::IMG_Sat::Result::GoTerm",
  { go_id => "term_2" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ioTlUSUhbC+HeHG0jrTH8A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

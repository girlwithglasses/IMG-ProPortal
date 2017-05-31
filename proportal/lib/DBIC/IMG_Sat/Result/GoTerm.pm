use utf8;
package DBIC::IMG_Sat::Result::GoTerm;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::GoTerm

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GO_TERM>

=cut

__PACKAGE__->table("GO_TERM");

=head1 ACCESSORS

=head2 go_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 go_term

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 go_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 definition

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 is_root

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 is_obsolete

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 db_source

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 255

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "go_id",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "go_term",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "go_type",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "definition",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "is_root",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "is_obsolete",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "db_source",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 255 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</go_id>

=back

=cut

__PACKAGE__->set_primary_key("go_id");

=head1 RELATIONS

=head2 go_graph_path_term_1s

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::GoGraphPath>

=cut

__PACKAGE__->has_many(
  "go_graph_path_term_1s",
  "DBIC::IMG_Sat::Result::GoGraphPath",
  { "foreign.term_1" => "self.go_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 go_graph_path_term_2s

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::GoGraphPath>

=cut

__PACKAGE__->has_many(
  "go_graph_path_term_2s",
  "DBIC::IMG_Sat::Result::GoGraphPath",
  { "foreign.term_2" => "self.go_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 go_term_parents_go

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::GoTermParents>

=cut

__PACKAGE__->has_many(
  "go_term_parents_go",
  "DBIC::IMG_Sat::Result::GoTermParents",
  { "foreign.go_id" => "self.go_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 go_term_parents_parents

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::GoTermParents>

=cut

__PACKAGE__->has_many(
  "go_term_parents_parents",
  "DBIC::IMG_Sat::Result::GoTermParents",
  { "foreign.parent" => "self.go_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 go_term_synonyms

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::GoTermSynonyms>

=cut

__PACKAGE__->has_many(
  "go_term_synonyms",
  "DBIC::IMG_Sat::Result::GoTermSynonyms",
  { "foreign.go_id" => "self.go_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:43:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/nvX0omD7Q8TnqI7cQgBjQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

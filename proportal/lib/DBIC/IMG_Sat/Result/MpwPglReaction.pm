use utf8;
package DBIC::IMG_Sat::Result::MpwPglReaction;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::MpwPglReaction

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<MPW_PGL_REACTION>

=cut

__PACKAGE__->table("MPW_PGL_REACTION");

=head1 ACCESSORS

=head2 reaction_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 condition

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 equation

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 ec

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=cut

__PACKAGE__->add_columns(
  "reaction_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "condition",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "equation",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "ec",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:otwmtG2E8iWIv7XgWOgUCw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

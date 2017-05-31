use utf8;
package DBIC::IMG_Core::Result::AniClique;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::AniClique

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<ANI_CLIQUE>

=cut

__PACKAGE__->table("ANI_CLIQUE");

=head1 ACCESSORS

=head2 clique_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 clique_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 300

=head2 intra_clique_ani

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=head2 intra_clique_af

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=cut

__PACKAGE__->add_columns(
  "clique_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "clique_type",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 300 },
  "intra_clique_ani",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 5],
  },
  "intra_clique_af",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 5],
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</clique_id>

=back

=cut

__PACKAGE__->set_primary_key("clique_id");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cQRxGBYGJAFzE8jCTKElRA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DBIC::IMG_Core::Result::GeneTmhmmHit;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GeneTmhmmHit

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENE_TMHMM_HITS>

=cut

__PACKAGE__->table("GENE_TMHMM_HITS");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 topology

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 feature_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 400

=head2 start_coord

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 end_coord

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "gene_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "topology",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "feature_type",
  { data_type => "varchar2", is_nullable => 1, size => 400 },
  "start_coord",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "end_coord",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:J5AHd4V9wSCDjIBaMDJgxg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

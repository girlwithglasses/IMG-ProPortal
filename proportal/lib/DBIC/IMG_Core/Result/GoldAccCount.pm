use utf8;
package DBIC::IMG_Core::Result::GoldAccCount;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GoldAccCount

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GOLD_ACC_COUNTS>

=cut

__PACKAGE__->table("GOLD_ACC_COUNTS");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 gold_stamp_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 seq_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 contigs_#_in_gold

  accessor: 'contigs___in_gold'
  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 accessions_#_in_gold

  accessor: 'accessions___in_gold'
  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "gold_stamp_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "seq_status",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "contigs_#_in_gold",
  {
    accessor    => "contigs___in_gold",
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "accessions_#_in_gold",
  {
    accessor    => "accessions___in_gold",
    data_type   => "numeric",
    is_nullable => 1,
    original    => { data_type => "number" },
    size        => 126,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9sg0bFHJ+z2Djh9ypCE/JQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

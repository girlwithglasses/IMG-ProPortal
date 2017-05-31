use utf8;
package DBIC::IMG_Core::Result::TaxonCrisprDetail;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::TaxonCrisprDetail

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TAXON_CRISPR_DETAILS>

=cut

__PACKAGE__->table("TAXON_CRISPR_DETAILS");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 contig_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 300

=head2 crispr_no

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 pos

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 repeat_seq

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 spacer_seq

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 tool_code

  data_type: 'varchar2'
  is_nullable: 1
  size: 5

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "contig_id",
  { data_type => "varchar2", is_nullable => 1, size => 300 },
  "crispr_no",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "pos",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "repeat_seq",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "spacer_seq",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "tool_code",
  { data_type => "varchar2", is_nullable => 1, size => 5 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qKShnDsMFUKDAl1LEJPHFA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

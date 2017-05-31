use utf8;
package DBIC::IMG_Core::Result::GeneFeatureTag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GeneFeatureTag

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENE_FEATURE_TAGS>

=cut

__PACKAGE__->table("GENE_FEATURE_TAGS");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 tag

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 value

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 notes

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=cut

__PACKAGE__->add_columns(
  "gene_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "tag",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "value",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "notes",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:D1jljnCY7v1hpLbxzxgaig


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

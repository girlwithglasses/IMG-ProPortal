use utf8;
package DBIC::IMG_Core::Result::GeneGoTerm;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GeneGoTerm

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENE_GO_TERMS>

=cut

__PACKAGE__->table("GENE_GO_TERMS");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 go_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 go_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 go_evidence

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 reference

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 xref

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "gene_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "go_type",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "go_id",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "go_evidence",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "reference",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "xref",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/TqNXpgbLAtANCGsmlyNbA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

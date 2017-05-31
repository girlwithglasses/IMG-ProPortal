use utf8;
package DBIC::IMG_Core::Result::GeneException;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GeneException

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENE_EXCEPTIONS>

=cut

__PACKAGE__->table("GENE_EXCEPTIONS");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 gb_tag

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 exception

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=cut

__PACKAGE__->add_columns(
  "gene_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "gb_tag",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "exception",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xDCvBp0HUe4OIWymT5mk8A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DBIC::IMG_Core::Result::AniOldTaxon;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::AniOldTaxon

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<ANI_OLD_TAXONS>

=cut

__PACKAGE__->table("ANI_OLD_TAXONS");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 taxon_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "taxon_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XUL8Xhb26jsal7Uzm1Py1g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

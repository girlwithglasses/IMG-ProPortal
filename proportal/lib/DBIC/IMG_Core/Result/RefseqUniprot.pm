use utf8;
package DBIC::IMG_Core::Result::RefseqUniprot;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::RefseqUniprot

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<REFSEQ_UNIPROT>

=cut

__PACKAGE__->table("REFSEQ_UNIPROT");

=head1 ACCESSORS

=head2 refseq_protein_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 uniprot_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "refseq_protein_id",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "uniprot_id",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qKm4P28CnQBjV3xDajxPhw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

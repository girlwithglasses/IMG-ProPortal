use utf8;
package DBIC::IMG_Core::Result::TmpPfamDomain;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::TmpPfamDomain

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TMP_PFAM_DOMAIN>

=cut

__PACKAGE__->table("TMP_PFAM_DOMAIN");

=head1 ACCESSORS

=head2 pfam_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 domain

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 genome_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "pfam_id",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "domain",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "genome_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ohAaqWRkAhEjVL+gVfSq/g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

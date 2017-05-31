use utf8;
package DBIC::IMG_Core::Result::MvMetacycStat;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::MvMetacycStat

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<MV_METACYC_STATS>

=cut

__PACKAGE__->table("MV_METACYC_STATS");

=head1 ACCESSORS

=head2 pwy_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 ec_number

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 enzyme_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 rxn_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 gene_cnt

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 taxon_cnt

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=cut

__PACKAGE__->add_columns(
  "pwy_id",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "ec_number",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "enzyme_name",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "rxn_id",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "gene_cnt",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "taxon_cnt",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:w0RJNI0q9NY/C5H80cK3YA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

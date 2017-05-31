use utf8;
package DBIC::IMG_Core::Result::TaxonQualityMeasure;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::TaxonQualityMeasure

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TAXON_QUALITY_MEASURE>

=cut

__PACKAGE__->table("TAXON_QUALITY_MEASURE");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 taxonomy_completeness

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 taxonomy_coherence

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 annot_completeness

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 annot_coherence

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 visibility_completeness

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 visibility_coherence

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 modified_by

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "taxonomy_completeness",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "taxonomy_coherence",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "annot_completeness",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "annot_coherence",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "visibility_completeness",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "visibility_coherence",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "modified_by",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</taxon_oid>

=back

=cut

__PACKAGE__->set_primary_key("taxon_oid");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TxtpJtNfci7pPpDilmbgRg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

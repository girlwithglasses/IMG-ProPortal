use utf8;
package DBIC::IMG_Gold::Result::LoadGenbankProkData;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::LoadGenbankProkData

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<LOAD_GENBANK_PROK_DATA>

=cut

__PACKAGE__->table("LOAD_GENBANK_PROK_DATA");

=head1 ACCESSORS

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 bioproject_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 bactgroup

  data_type: 'varchar2'
  is_nullable: 1
  size: 150

=head2 subgroup

  data_type: 'varchar2'
  is_nullable: 1
  size: 150

=head2 chrsize

  data_type: 'numeric'
  default_value: null
  is_nullable: 1
  original: {data_type => "number"}
  size: [9,5]

=head2 gc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [4,2]

=head2 chromosomesref

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 chromosomesgen

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 plasmidsref

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 plasmidsgen

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 wgs

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 scaffolds

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 proteins

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 releasedate

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 modifydate

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 status

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 taxonomy_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 seq_center

  data_type: 'varchar2'
  is_nullable: 1
  size: 250

=head2 bioproject_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 biosample_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 assembly_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 reference

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=cut

__PACKAGE__->add_columns(
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "bioproject_id",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "bactgroup",
  { data_type => "varchar2", is_nullable => 1, size => 150 },
  "subgroup",
  { data_type => "varchar2", is_nullable => 1, size => 150 },
  "chrsize",
  {
    data_type => "numeric",
    default_value => \"null",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [9, 5],
  },
  "gc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [4, 2],
  },
  "chromosomesref",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "chromosomesgen",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "plasmidsref",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "plasmidsgen",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "wgs",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "scaffolds",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "proteins",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "releasedate",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "modifydate",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "status",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "taxonomy_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "seq_center",
  { data_type => "varchar2", is_nullable => 1, size => 250 },
  "bioproject_accession",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "biosample_accession",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "assembly_accession",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "reference",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:73Y/6JlyyDq4TjvI7j35eA
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/LoadGenbankProkData.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::LoadGenbankProkData;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::LoadGenbankProkData

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<LOAD_GENBANK_PROK_DATA>

=cut

__PACKAGE__->table("LOAD_GENBANK_PROK_DATA");

=head1 ACCESSORS

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 bioproject_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 bactgroup

  data_type: 'varchar2'
  is_nullable: 1
  size: 150

=head2 subgroup

  data_type: 'varchar2'
  is_nullable: 1
  size: 150

=head2 chrsize

  data_type: 'numeric'
  default_value: null
  is_nullable: 1
  original: {data_type => "number"}
  size: [9,5]

=head2 gc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [4,2]

=head2 chromosomesref

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 chromosomesgen

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 plasmidsref

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 plasmidsgen

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 wgs

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 scaffolds

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 proteins

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 releasedate

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 modifydate

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 status

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 taxonomy_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 seq_center

  data_type: 'varchar2'
  is_nullable: 1
  size: 250

=head2 bioproject_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 biosample_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 assembly_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 reference

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=cut

__PACKAGE__->add_columns(
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "bioproject_id",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "bactgroup",
  { data_type => "varchar2", is_nullable => 1, size => 150 },
  "subgroup",
  { data_type => "varchar2", is_nullable => 1, size => 150 },
  "chrsize",
  {
    data_type => "numeric",
    default_value => \"null",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [9, 5],
  },
  "gc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [4, 2],
  },
  "chromosomesref",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "chromosomesgen",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "plasmidsref",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "plasmidsgen",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "wgs",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "scaffolds",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "proteins",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "releasedate",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "modifydate",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "status",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "taxonomy_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "seq_center",
  { data_type => "varchar2", is_nullable => 1, size => 250 },
  "bioproject_accession",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "biosample_accession",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "assembly_accession",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "reference",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8aEBS3c1+4p1eEyE8m5G+Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/LoadGenbankProkData.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

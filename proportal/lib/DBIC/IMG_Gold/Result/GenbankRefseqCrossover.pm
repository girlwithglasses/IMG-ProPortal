use utf8;
package DBIC::IMG_Gold::Result::GenbankRefseqCrossover;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::GenbankRefseqCrossover

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENBANK_REFSEQ_CROSSOVER>

=cut

__PACKAGE__->table("GENBANK_REFSEQ_CROSSOVER");

=head1 ACCESSORS

=head2 refseq_bioproject_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 genbank_bioproject_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 display_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_taxon_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 project_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=cut

__PACKAGE__->add_columns(
  "refseq_bioproject_accession",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "genbank_bioproject_accession",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "display_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_taxon_id",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "project_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:C1xYpV8jCOm46AuVEB3m5g
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/GenbankRefseqCrossover.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::GenbankRefseqCrossover;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::GenbankRefseqCrossover

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENBANK_REFSEQ_CROSSOVER>

=cut

__PACKAGE__->table("GENBANK_REFSEQ_CROSSOVER");

=head1 ACCESSORS

=head2 refseq_bioproject_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 genbank_bioproject_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 display_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_taxon_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 project_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=cut

__PACKAGE__->add_columns(
  "refseq_bioproject_accession",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "genbank_bioproject_accession",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "display_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_taxon_id",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "project_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7GNlBcWkXR08uFM3hZSz4g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/GenbankRefseqCrossover.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DBIC::IMG_Gold::Result::NcbiAccession;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::NcbiAccession

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<NCBI_ACCESSIONS>

=cut

__PACKAGE__->table("NCBI_ACCESSIONS");

=head1 ACCESSORS

=head2 accession_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 type

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 bioproject_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 scaffold_source

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 project_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 assembly_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 gold_analysis_project_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "accession_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "type",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "bioproject_accession",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "scaffold_source",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "project_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "assembly_accession",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "gold_analysis_project_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<unique_scaffold_id>

=over 4

=item * L</accession_id>

=back

=cut

__PACKAGE__->add_unique_constraint("unique_scaffold_id", ["accession_id"]);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:w+37YNIyGczzColsdo2QLw
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/NcbiAccession.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::NcbiAccession;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::NcbiAccession

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<NCBI_ACCESSIONS>

=cut

__PACKAGE__->table("NCBI_ACCESSIONS");

=head1 ACCESSORS

=head2 accession_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 type

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 bioproject_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 scaffold_source

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 project_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 assembly_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 gold_analysis_project_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "accession_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "type",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "bioproject_accession",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "scaffold_source",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "project_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "assembly_accession",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "gold_analysis_project_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<unique_scaffold_id>

=over 4

=item * L</accession_id>

=back

=cut

__PACKAGE__->add_unique_constraint("unique_scaffold_id", ["accession_id"]);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XdXl53WMR/sECr1wOIyH/w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/NcbiAccession.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

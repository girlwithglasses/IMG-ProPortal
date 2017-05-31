use utf8;
package DBIC::IMG_Gold::Result::GoldApGenbank;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::GoldApGenbank

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GOLD_AP_GENBANK>

=cut

__PACKAGE__->table("GOLD_AP_GENBANK");

=head1 ACCESSORS

=head2 id

  data_type: 'numeric'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number"}
  sequence: 'gold_ap_genbank_id_seq'
  size: 126

=head2 gold_analysis_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 genbank_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 assembly_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "numeric",
    is_auto_increment => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    sequence => "gold_ap_genbank_id_seq",
    size => 126,
  },
  "gold_analysis_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "genbank_id",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "assembly_accession",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<gold_ap_genbank_1>

=over 4

=item * L</gold_analysis_project_id>

=item * L</genbank_id>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "gold_ap_genbank_1",
  ["gold_analysis_project_id", "genbank_id"],
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eTTEMRtNSjdB/HWPpajQ6A
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/GoldApGenbank.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::GoldApGenbank;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::GoldApGenbank

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GOLD_AP_GENBANK>

=cut

__PACKAGE__->table("GOLD_AP_GENBANK");

=head1 ACCESSORS

=head2 id

  data_type: 'numeric'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number"}
  sequence: 'gold_ap_genbank_id_seq'
  size: 126

=head2 gold_analysis_project_id

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 genbank_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 assembly_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "numeric",
    is_auto_increment => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    sequence => "gold_ap_genbank_id_seq",
    size => 126,
  },
  "gold_analysis_project_id",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "genbank_id",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "assembly_accession",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<gold_ap_genbank_1>

=over 4

=item * L</gold_analysis_project_id>

=item * L</genbank_id>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "gold_ap_genbank_1",
  ["gold_analysis_project_id", "genbank_id"],
);

=head1 RELATIONS

=head2 gold_analysis_project

Type: belongs_to

Related object: L<DBIC::IMG_Gold::Result::GoldAnalysisProject>

=cut

__PACKAGE__->belongs_to(
  "gold_analysis_project",
  "DBIC::IMG_Gold::Result::GoldAnalysisProject",
  { gold_analysis_project_id => "gold_analysis_project_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:q/bai/krjPf7IjhSeE/fpQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/GoldApGenbank.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

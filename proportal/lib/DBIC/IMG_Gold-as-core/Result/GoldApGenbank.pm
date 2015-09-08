use utf8;
package DbSchema::IMG_Core::Result::GoldApGenbank;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::GoldApGenbank

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

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

Related object: L<DbSchema::IMG_Core::Result::GoldAnalysisProject>

=cut

__PACKAGE__->belongs_to(
  "gold_analysis_project",
  "DbSchema::IMG_Core::Result::GoldAnalysisProject",
  { gold_analysis_project_id => "gold_analysis_project_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8urD9BQz4k6L/pRWqaGZ1Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

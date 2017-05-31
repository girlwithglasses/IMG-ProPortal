use utf8;
package DBIC::IMG_Sat::Result::PropertyStep;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::PropertyStep

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<PROPERTY_STEP>

=cut

__PACKAGE__->table("PROPERTY_STEP");

=head1 ACCESSORS

=head2 step_accession

  data_type: 'varchar2'
  is_nullable: 0
  size: 100

=head2 genome_property

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 100

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 is_required

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "step_accession",
  { data_type => "varchar2", is_nullable => 0, size => 100 },
  "genome_property",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 100 },
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "is_required",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</step_accession>

=back

=cut

__PACKAGE__->set_primary_key("step_accession");

=head1 RELATIONS

=head2 genome_property

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::GenomeProperty>

=cut

__PACKAGE__->belongs_to(
  "genome_property",
  "DBIC::IMG_Sat::Result::GenomeProperty",
  { prop_accession => "genome_property" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 pfam_family_genome_properties

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::PfamFamilyGenomeProperties>

=cut

__PACKAGE__->has_many(
  "pfam_family_genome_properties",
  "DBIC::IMG_Sat::Result::PfamFamilyGenomeProperties",
  { "foreign.property_step" => "self.step_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tigrfam_genome_properties

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::TigrfamGenomeProperties>

=cut

__PACKAGE__->has_many(
  "tigrfam_genome_properties",
  "DBIC::IMG_Sat::Result::TigrfamGenomeProperties",
  { "foreign.property_step" => "self.step_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KcPlTIqu+Goib3YrRHIBlA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

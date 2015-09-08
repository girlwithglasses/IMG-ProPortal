use utf8;
package DbSchema::IMG_Core::Result::ProjectInfoCyanoMetadata;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ProjectInfoCyanoMetadata

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<PROJECT_INFO_CYANO_METADATA>

=cut

__PACKAGE__->table("PROJECT_INFO_CYANO_METADATA");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 filaments

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 cysts

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 differentiated_cells

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 heterocysts_position

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 reproduction_mode

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 trichome

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 trichome_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 pigments

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 phage_infectivity

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 phage_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 carotenoids

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 restriction_enzyme

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 toxin_production

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 toxin_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 developmental_cycle

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 branching

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 gas_vesicles

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 gas_vesicle_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 body_inclusion

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 secondary_metabolites

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 extracellular_structures

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 bloom_forming

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 pigment_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 compl_chromatic_adaptation

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 medium_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 filament_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "filaments",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "cysts",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "differentiated_cells",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "heterocysts_position",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "reproduction_mode",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "trichome",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "trichome_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "pigments",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "phage_infectivity",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "phage_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "carotenoids",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "restriction_enzyme",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "toxin_production",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "toxin_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "developmental_cycle",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "branching",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "gas_vesicles",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "gas_vesicle_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "body_inclusion",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "secondary_metabolites",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "extracellular_structures",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "bloom_forming",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "pigment_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "compl_chromatic_adaptation",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "medium_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "filament_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:69OWacwC9YE68v8DHd+npw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

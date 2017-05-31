use utf8;
package DBIC::IMG_Gold::Result::ProjectInfoCyanoMetadata;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::ProjectInfoCyanoMetadata

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

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


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5gRnIq9JLaJKvwH7+yG/Tw
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/ProjectInfoCyanoMetadata.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::ProjectInfoCyanoMetadata;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::ProjectInfoCyanoMetadata

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WWvWhnlqR4LGFJAphxFE5w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/ProjectInfoCyanoMetadata.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

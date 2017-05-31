use utf8;
package DBIC::IMG_Gold::Result::EnvSampleSoilMetadata;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::EnvSampleSoilMetadata

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<ENV_SAMPLE_SOIL_METADATA>

=cut

__PACKAGE__->table("ENV_SAMPLE_SOIL_METADATA");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 current_land_use

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 current_vegetation

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 previous_land_use

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 crop_rotation

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 agrochemical_addition

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 tillage

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 fire

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 flooding

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 extreme_events

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 other_events

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 horizon

  data_type: 'varchar2'
  is_nullable: 1
  size: 16

=head2 sieving

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 soil_water_content

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 dna_pooling

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 storage_conditions

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 mean_temperature

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 mean_precipitation

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 fao_classification

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 local_classification

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 soil_order

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 slope_gradient

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 profile_position

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 drainage_classification

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 sand_percentage

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 silt_percentage

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 total_organic_carbon

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 total_nitrogen

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 soil_salinity

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 heavy_metals

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 aluminum_saturation

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 other_unusual_properties

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "current_land_use",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "current_vegetation",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "previous_land_use",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "crop_rotation",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "agrochemical_addition",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "tillage",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "fire",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "flooding",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "extreme_events",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "other_events",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "horizon",
  { data_type => "varchar2", is_nullable => 1, size => 16 },
  "sieving",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "soil_water_content",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "dna_pooling",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "storage_conditions",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "mean_temperature",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "mean_precipitation",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "fao_classification",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "local_classification",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "soil_order",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "slope_gradient",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "profile_position",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "drainage_classification",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "sand_percentage",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "silt_percentage",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "total_organic_carbon",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "total_nitrogen",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "soil_salinity",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "heavy_metals",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "aluminum_saturation",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "other_unusual_properties",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hz1nYu6yejGE0twlb4XzXA
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/EnvSampleSoilMetadata.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::EnvSampleSoilMetadata;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::EnvSampleSoilMetadata

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<ENV_SAMPLE_SOIL_METADATA>

=cut

__PACKAGE__->table("ENV_SAMPLE_SOIL_METADATA");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 current_land_use

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 current_vegetation

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 previous_land_use

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 crop_rotation

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 agrochemical_addition

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 tillage

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 fire

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 flooding

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 extreme_events

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 other_events

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 horizon

  data_type: 'varchar2'
  is_nullable: 1
  size: 16

=head2 sieving

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 soil_water_content

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 dna_pooling

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 storage_conditions

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 mean_temperature

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 mean_precipitation

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 fao_classification

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 local_classification

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 soil_order

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 slope_gradient

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 profile_position

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 drainage_classification

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 sand_percentage

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 silt_percentage

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 total_organic_carbon

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 total_nitrogen

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 soil_salinity

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 heavy_metals

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 aluminum_saturation

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 other_unusual_properties

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "current_land_use",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "current_vegetation",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "previous_land_use",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "crop_rotation",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "agrochemical_addition",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "tillage",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "fire",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "flooding",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "extreme_events",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "other_events",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "horizon",
  { data_type => "varchar2", is_nullable => 1, size => 16 },
  "sieving",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "soil_water_content",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "dna_pooling",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "storage_conditions",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "mean_temperature",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "mean_precipitation",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "fao_classification",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "local_classification",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "soil_order",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "slope_gradient",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "profile_position",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "drainage_classification",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "sand_percentage",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "silt_percentage",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "total_organic_carbon",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "total_nitrogen",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "soil_salinity",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "heavy_metals",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "aluminum_saturation",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "other_unusual_properties",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Gv/UWhUwbdzZBQHqOV56Kw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/EnvSampleSoilMetadata.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DbSchema::IMG_Core::Result::EnvSampleSoilMetadata;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::EnvSampleSoilMetadata

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jgrnqxcDBTeI2/2Ey/NlrA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

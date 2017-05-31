use utf8;
package DBIC::IMG_Sat::Result::CogSpecies;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::CogSpecies

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<COG_SPECIES>

=cut

__PACKAGE__->table("COG_SPECIES");

=head1 ACCESSORS

=head2 species_code

  data_type: 'varchar2'
  is_nullable: 0
  size: 10

=head2 cog_species_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 taxon

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 species_family

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "species_code",
  { data_type => "varchar2", is_nullable => 0, size => 10 },
  "cog_species_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "taxon",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "species_family",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</species_code>

=back

=cut

__PACKAGE__->set_primary_key("species_code");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ywq5OTR202EGv3wjjHliAA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

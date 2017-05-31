use utf8;
package DBIC::IMG_Sat::Result::GenomeProperty;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::GenomeProperty

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENOME_PROPERTY>

=cut

__PACKAGE__->table("GENOME_PROPERTY");

=head1 ACCESSORS

=head2 prop_accession

  data_type: 'varchar2'
  is_nullable: 0
  size: 100

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 description

  data_type: 'clob'
  is_nullable: 1

=head2 threshold

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "prop_accession",
  { data_type => "varchar2", is_nullable => 0, size => 100 },
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "description",
  { data_type => "clob", is_nullable => 1 },
  "threshold",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "type",
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

=item * L</prop_accession>

=back

=cut

__PACKAGE__->set_primary_key("prop_accession");

=head1 RELATIONS

=head2 pfam_family_genome_properties

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::PfamFamilyGenomeProperties>

=cut

__PACKAGE__->has_many(
  "pfam_family_genome_properties",
  "DBIC::IMG_Sat::Result::PfamFamilyGenomeProperties",
  { "foreign.property" => "self.prop_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 property_steps

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::PropertyStep>

=cut

__PACKAGE__->has_many(
  "property_steps",
  "DBIC::IMG_Sat::Result::PropertyStep",
  { "foreign.genome_property" => "self.prop_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tigrfam_genome_properties

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::TigrfamGenomeProperties>

=cut

__PACKAGE__->has_many(
  "tigrfam_genome_properties",
  "DBIC::IMG_Sat::Result::TigrfamGenomeProperties",
  { "foreign.property" => "self.prop_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0+I16xZRlVYyV0rl6cgJCQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

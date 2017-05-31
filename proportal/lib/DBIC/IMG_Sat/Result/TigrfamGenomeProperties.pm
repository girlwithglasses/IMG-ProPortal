use utf8;
package DBIC::IMG_Sat::Result::TigrfamGenomeProperties;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::TigrfamGenomeProperties

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TIGRFAM_GENOME_PROPERTIES>

=cut

__PACKAGE__->table("TIGRFAM_GENOME_PROPERTIES");

=head1 ACCESSORS

=head2 ext_accession

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 0
  size: 50

=head2 property

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 100

=head2 property_step

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "ext_accession",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 0, size => 50 },
  "property",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 100 },
  "property_step",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 100 },
);

=head1 RELATIONS

=head2 ext_accession

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::Tigrfam>

=cut

__PACKAGE__->belongs_to(
  "ext_accession",
  "DBIC::IMG_Sat::Result::Tigrfam",
  { ext_accession => "ext_accession" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);

=head2 property

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::GenomeProperty>

=cut

__PACKAGE__->belongs_to(
  "property",
  "DBIC::IMG_Sat::Result::GenomeProperty",
  { prop_accession => "property" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 property_step

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::PropertyStep>

=cut

__PACKAGE__->belongs_to(
  "property_step",
  "DBIC::IMG_Sat::Result::PropertyStep",
  { step_accession => "property_step" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:o+XZNXOC6rtl37YJdna8yA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

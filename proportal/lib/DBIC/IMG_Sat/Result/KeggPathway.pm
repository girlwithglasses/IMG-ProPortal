use utf8;
package DBIC::IMG_Sat::Result::KeggPathway;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::KeggPathway

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<KEGG_PATHWAY>

=cut

__PACKAGE__->table("KEGG_PATHWAY");

=head1 ACCESSORS

=head2 pathway_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 pathway_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 title

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 category

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 db_source

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 255

=head2 image_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 kegg_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 image_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 ko_pathway_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "pathway_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "pathway_name",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "title",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "category",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "db_source",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 255 },
  "image_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "kegg_id",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "image_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "ko_pathway_id",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</pathway_oid>

=back

=cut

__PACKAGE__->set_primary_key("pathway_oid");

=head1 RELATIONS

=head2 image_roi_pathways

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::ImageRoi>

=cut

__PACKAGE__->has_many(
  "image_roi_pathways",
  "DBIC::IMG_Sat::Result::ImageRoi",
  { "foreign.pathway" => "self.pathway_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 image_roi_related_pathways

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::ImageRoi>

=cut

__PACKAGE__->has_many(
  "image_roi_related_pathways",
  "DBIC::IMG_Sat::Result::ImageRoi",
  { "foreign.related_pathway" => "self.pathway_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 kegg_modules

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KeggModule>

=cut

__PACKAGE__->has_many(
  "kegg_modules",
  "DBIC::IMG_Sat::Result::KeggModule",
  { "foreign.pathway" => "self.pathway_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 kegg_pathway_modules

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KeggPathwayModules>

=cut

__PACKAGE__->has_many(
  "kegg_pathway_modules",
  "DBIC::IMG_Sat::Result::KeggPathwayModules",
  { "foreign.pathway_oid" => "self.pathway_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 kegg_pathway_related_pathways_pathway_oids

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KeggPathwayRelatedPathways>

=cut

__PACKAGE__->has_many(
  "kegg_pathway_related_pathways_pathway_oids",
  "DBIC::IMG_Sat::Result::KeggPathwayRelatedPathways",
  { "foreign.pathway_oid" => "self.pathway_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 kegg_pathway_related_pathways_related_pathways

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KeggPathwayRelatedPathways>

=cut

__PACKAGE__->has_many(
  "kegg_pathway_related_pathways_related_pathways",
  "DBIC::IMG_Sat::Result::KeggPathwayRelatedPathways",
  { "foreign.related_pathways" => "self.pathway_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:43:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/s27x8s8lxi+dqRiyV4YwA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

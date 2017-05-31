use utf8;
package DBIC::IMG_Core::Result::VwTaxonSc;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::VwTaxonSc

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<VW_TAXON_SC>

=cut

__PACKAGE__->table("VW_TAXON_SC");
__PACKAGE__->result_source_instance->view_definition("select taxon_oid, taxon_display_name, t.domain, obsolete_flag\nfrom taxon t, project_info_gold p, submission s\nwhere t.submission_id = s.submission_id\nand s.project_info = p.project_oid\nand p.uncultured_type like 'Single Cell%'");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 taxon_display_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 domain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 obsolete_flag

  data_type: 'varchar2'
  is_nullable: 0
  size: 10

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "taxon_display_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "domain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "obsolete_flag",
  { data_type => "varchar2", is_nullable => 0, size => 10 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OCJzb4jq5Y/MAV0dbTfw4w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

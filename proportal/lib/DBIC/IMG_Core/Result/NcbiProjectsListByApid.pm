use utf8;
package DBIC::IMG_Core::Result::NcbiProjectsListByApid;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::NcbiProjectsListByApid

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<NCBI_PROJECTS_LIST_BY_APID>

=cut

__PACKAGE__->table("NCBI_PROJECTS_LIST_BY_APID");

=head1 ACCESSORS

=head2 gold_stamp_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 gold_analysis_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 display_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 1000

=head2 project_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 locus_tag

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 seq_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 bioproject_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "gold_stamp_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "gold_analysis_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "display_name",
  { data_type => "varchar2", is_nullable => 0, size => 1000 },
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "locus_tag",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "seq_status",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "bioproject_accession",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0e0Vdc0Hi6BXTqhnXQbmRQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

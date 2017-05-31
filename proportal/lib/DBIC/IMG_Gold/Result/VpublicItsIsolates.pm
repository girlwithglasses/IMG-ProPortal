use utf8;
package DBIC::IMG_Gold::Result::VpublicItsIsolates;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::VpublicItsIsolates

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<VPUBLIC_ITS_ISOLATES>

=cut

__PACKAGE__->table("VPUBLIC_ITS_ISOLATES");
__PACKAGE__->result_source_instance->view_definition("SELECT  distinct pi.project_oid, pi.display_name,  sp.CURRENT_STATUS,  sp.DATE_CREATED, spro.SEQUENCING_PRODUCT_NAME,  sp.SEQUENCING_PROJECT_ID,  sp.SEQUENCING_PROJECT_NAME,  sp.SEQUENCING_STRATEGY_NAME, sp.STATUS_COMMENTS, sp.STATUS_DATE FROM DW.SEQUENCING_PROJECT\@itslink sp  inner join DW.SEQUENCING_PRODUCT\@itslink spro on sp.sequencing_product_id=spro.sequencing_product_id  inner join project_info pi on pi.its_spid = sp.sequencing_project_id WHERE sp.ELIGIBLE_PUBLIC_RELEASE ='Y' and display_name not like '%ABANDONED%' and pi.gold_stamp_id is null and embargo_days=0 and embargo_start_date is null and current_status !='Deleted' and current_status!='Abandoned' order by pi.project_oid\n ");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 display_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 1000

=head2 current_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 date_created

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=head2 sequencing_product_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 sequencing_project_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 sequencing_project_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 sequencing_strategy_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 status_comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 status_date

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "display_name",
  { data_type => "varchar2", is_nullable => 0, size => 1000 },
  "current_status",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "date_created",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
  "sequencing_product_name",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "sequencing_project_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "sequencing_project_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "sequencing_strategy_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "status_comments",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "status_date",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cnaZITP0WGeD5gQyf2H1SQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

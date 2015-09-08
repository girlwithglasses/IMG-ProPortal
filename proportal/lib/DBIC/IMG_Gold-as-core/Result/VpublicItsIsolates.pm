use utf8;
package DbSchema::IMG_Core::Result::VpublicItsIsolates;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::VpublicItsIsolates

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<VPUBLIC_ITS_ISOLATES>

=cut

__PACKAGE__->table("VPUBLIC_ITS_ISOLATES");

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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7aSWDs6D5RHoEllTiyTRSQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

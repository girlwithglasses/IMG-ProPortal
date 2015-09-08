use utf8;
package DbSchema::IMG_Core::Result::TJgiCatalogue;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::TJgiCatalogue

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<T_JGI_CATALOGUE>

=cut

__PACKAGE__->table("T_JGI_CATALOGUE");

=head1 ACCESSORS

=head2 oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 jgi_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [7,0]

=head2 portal_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 25

=head2 status

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 proposal

  data_type: 'varchar2'
  is_nullable: 1
  size: 244

=head2 product_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 31

=head2 project_manager

  data_type: 'varchar2'
  is_nullable: 1
  size: 44

=head2 project_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 275

=cut

__PACKAGE__->add_columns(
  "oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "jgi_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [7, 0],
  },
  "portal_id",
  { data_type => "varchar2", is_nullable => 1, size => 25 },
  "status",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "proposal",
  { data_type => "varchar2", is_nullable => 1, size => 244 },
  "product_name",
  { data_type => "varchar2", is_nullable => 1, size => 31 },
  "project_manager",
  { data_type => "varchar2", is_nullable => 1, size => 44 },
  "project_name",
  { data_type => "varchar2", is_nullable => 1, size => 275 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RogNlIwXdk3HP+NBvj2hNQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DbSchema::IMG_Core::Result::TAllGoldJgiProject;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::TAllGoldJgiProject

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<T_ALL_GOLD_JGI_PROJECTS>

=cut

__PACKAGE__->table("T_ALL_GOLD_JGI_PROJECTS");

=head1 ACCESSORS

=head2 its_spid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 project_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 project_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 source

  data_type: 'char'
  is_nullable: 1
  size: 2

=cut

__PACKAGE__->add_columns(
  "its_spid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "project_status",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "source",
  { data_type => "char", is_nullable => 1, size => 2 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aVyKYbxyQLEeql7dnoxWWQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DbSchema::IMG_Core::Result::OrnlProject;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OrnlProject

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ORNL_PROJECT>

=cut

__PACKAGE__->table("ORNL_PROJECT");

=head1 ACCESSORS

=head2 jgi_project_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 status

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "jgi_project_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "status",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RtHfdQWWqiXNBON5dv8z8w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

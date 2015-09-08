use utf8;
package DbSchema::IMG_Core::Result::Announcement;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::Announcement

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ANNOUNCEMENT>

=cut

__PACKAGE__->table("ANNOUNCEMENT");

=head1 ACCESSORS

=head2 type

  data_type: 'varchar2'
  is_nullable: 0
  size: 80

=head2 notes

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 modified_by

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "type",
  { data_type => "varchar2", is_nullable => 0, size => 80 },
  "notes",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "modified_by",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pG/wm3wKWMj1MfkXDqgiiw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

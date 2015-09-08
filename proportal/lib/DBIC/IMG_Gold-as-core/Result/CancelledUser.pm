use utf8;
package DbSchema::IMG_Core::Result::CancelledUser;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::CancelledUser

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<CANCELLED_USER>

=cut

__PACKAGE__->table("CANCELLED_USER");

=head1 ACCESSORS

=head2 username

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 email

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

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
  "username",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "email",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vYzClI5mQC+1NQI1LbH9+g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

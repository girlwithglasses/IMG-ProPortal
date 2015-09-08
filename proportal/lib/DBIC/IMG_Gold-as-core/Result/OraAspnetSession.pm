use utf8;
package DbSchema::IMG_Core::Result::OraAspnetSession;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraAspnetSession

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ORA_ASPNET_SESSIONS>

=cut

__PACKAGE__->table("ORA_ASPNET_SESSIONS");

=head1 ACCESSORS

=head2 sessionid

  data_type: 'nvarchar2'
  is_nullable: 0
  size: 116

=head2 created

  data_type: 'datetime'
  default_value: SYS_EXTRACT_UTC(SYSTIMESTAMP)
  is_nullable: 0
  original: {data_type => "date"}

=head2 expires

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=head2 lockdate

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=head2 lockdatelocal

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=head2 lockcookie

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 timeout

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 locked

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 sessionitemshort

  data_type: 'raw'
  is_nullable: 1
  size: 2000

=head2 sessionitemlong

  data_type: 'blob'
  is_nullable: 1

=head2 flags

  data_type: 'integer'
  default_value: 0
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "sessionid",
  { data_type => "nvarchar2", is_nullable => 0, size => 116 },
  "created",
  {
    data_type     => "datetime",
    default_value => \"SYS_EXTRACT_UTC(SYSTIMESTAMP)",
    is_nullable   => 0,
    original      => { data_type => "date" },
  },
  "expires",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
  "lockdate",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
  "lockdatelocal",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
  "lockcookie",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "timeout",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "locked",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "sessionitemshort",
  { data_type => "raw", is_nullable => 1, size => 2000 },
  "sessionitemlong",
  { data_type => "blob", is_nullable => 1 },
  "flags",
  {
    data_type     => "integer",
    default_value => 0,
    is_nullable   => 0,
    original      => { data_type => "number", size => [38, 0] },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</sessionid>

=back

=cut

__PACKAGE__->set_primary_key("sessionid");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GYkHaqQFDRFlODJTV2KPYg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DbSchema::IMG_Core::Result::OraVwAspnetSession;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraVwAspnetSession

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<ORA_VW_ASPNET_SESSIONS>

=cut

__PACKAGE__->table("ORA_VW_ASPNET_SESSIONS");

=head1 ACCESSORS

=head2 sessionid

  data_type: 'nvarchar2'
  is_nullable: 0
  size: 116

=head2 created

  data_type: 'datetime'
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

=head2 datasize

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 flags

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "sessionid",
  { data_type => "nvarchar2", is_nullable => 0, size => 116 },
  "created",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
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
  "datasize",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "flags",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:J2x4b9Qz7mfKpxDb3w+MYw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

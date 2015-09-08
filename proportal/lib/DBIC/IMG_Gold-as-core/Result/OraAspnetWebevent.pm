use utf8;
package DbSchema::IMG_Core::Result::OraAspnetWebevent;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraAspnetWebevent

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ORA_ASPNET_WEBEVENTS>

=cut

__PACKAGE__->table("ORA_ASPNET_WEBEVENTS");

=head1 ACCESSORS

=head2 eventid

  data_type: 'char'
  is_nullable: 1
  size: 32

=head2 eventtimeutc

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 eventtime

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 eventtype

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 256

=head2 eventsequence

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [19,0]

=head2 eventoccurence

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [19,0]

=head2 eventcode

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [10,0]

=head2 eventdetailcode

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [10,0]

=head2 message

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 1000

=head2 applicationpath

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 256

=head2 applicationvirtualpath

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 256

=head2 machinename

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 256

=head2 requesturl

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 256

=head2 exceptiontype

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 256

=head2 details

  data_type: 'nclob'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "eventid",
  { data_type => "char", is_nullable => 1, size => 32 },
  "eventtimeutc",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "eventtime",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "eventtype",
  { data_type => "nvarchar2", is_nullable => 1, size => 256 },
  "eventsequence",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [19, 0],
  },
  "eventoccurence",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [19, 0],
  },
  "eventcode",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [10, 0],
  },
  "eventdetailcode",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [10, 0],
  },
  "message",
  { data_type => "nvarchar2", is_nullable => 1, size => 1000 },
  "applicationpath",
  { data_type => "nvarchar2", is_nullable => 1, size => 256 },
  "applicationvirtualpath",
  { data_type => "nvarchar2", is_nullable => 1, size => 256 },
  "machinename",
  { data_type => "nvarchar2", is_nullable => 1, size => 256 },
  "requesturl",
  { data_type => "nvarchar2", is_nullable => 1, size => 256 },
  "exceptiontype",
  { data_type => "nvarchar2", is_nullable => 1, size => 256 },
  "details",
  { data_type => "nclob", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:437e2jahjsDIN10Tg4UgBQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

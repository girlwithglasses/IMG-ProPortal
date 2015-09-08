use utf8;
package DbSchema::IMG_Core::Result::OraVwAspnetMemuser;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraVwAspnetMemuser

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<ORA_VW_ASPNET_MEMUSERS>

=cut

__PACKAGE__->table("ORA_VW_ASPNET_MEMUSERS");

=head1 ACCESSORS

=head2 userid

  data_type: 'raw'
  is_nullable: 0
  size: 16

=head2 passwordformat

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 mobilepin

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 16

=head2 email

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 256

=head2 loweredemail

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 256

=head2 passwordquestion

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 256

=head2 passwordanswer

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 128

=head2 isapproved

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 islockedout

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 createdate

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=head2 lastlogindate

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=head2 lastpasswordchangeddate

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=head2 lastlockoutdate

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=head2 failedpwdattemptcount

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 failedpwdattemptwinstart

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=head2 failedpwdanswerattemptcount

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 failedpwdanswerattemptwinstart

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=head2 comments

  data_type: 'nclob'
  is_nullable: 1

=head2 applicationid

  data_type: 'raw'
  is_nullable: 0
  size: 16

=head2 username

  data_type: 'nvarchar2'
  is_nullable: 0
  size: 256

=head2 mobilealias

  data_type: 'nvarchar2'
  is_nullable: 1
  size: 16

=head2 isanonymous

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 lastactivitydate

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "userid",
  { data_type => "raw", is_nullable => 0, size => 16 },
  "passwordformat",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "mobilepin",
  { data_type => "nvarchar2", is_nullable => 1, size => 16 },
  "email",
  { data_type => "nvarchar2", is_nullable => 1, size => 256 },
  "loweredemail",
  { data_type => "nvarchar2", is_nullable => 1, size => 256 },
  "passwordquestion",
  { data_type => "nvarchar2", is_nullable => 1, size => 256 },
  "passwordanswer",
  { data_type => "nvarchar2", is_nullable => 1, size => 128 },
  "isapproved",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "islockedout",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "createdate",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
  "lastlogindate",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
  "lastpasswordchangeddate",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
  "lastlockoutdate",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
  "failedpwdattemptcount",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "failedpwdattemptwinstart",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
  "failedpwdanswerattemptcount",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "failedpwdanswerattemptwinstart",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
  "comments",
  { data_type => "nclob", is_nullable => 1 },
  "applicationid",
  { data_type => "raw", is_nullable => 0, size => 16 },
  "username",
  { data_type => "nvarchar2", is_nullable => 0, size => 256 },
  "mobilealias",
  { data_type => "nvarchar2", is_nullable => 1, size => 16 },
  "isanonymous",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "lastactivitydate",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KWChFcA8AAFWYJoaPeW7YA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

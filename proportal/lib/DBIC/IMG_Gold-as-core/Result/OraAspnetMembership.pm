use utf8;
package DbSchema::IMG_Core::Result::OraAspnetMembership;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraAspnetMembership

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ORA_ASPNET_MEMBERSHIP>

=cut

__PACKAGE__->table("ORA_ASPNET_MEMBERSHIP");

=head1 ACCESSORS

=head2 applicationid

  data_type: 'raw'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 userid

  data_type: 'raw'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 password

  data_type: 'nvarchar2'
  is_nullable: 0
  size: 128

=head2 passwordformat

  data_type: 'integer'
  default_value: 0
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 passwordsalt

  data_type: 'nvarchar2'
  is_nullable: 0
  size: 128

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

=cut

__PACKAGE__->add_columns(
  "applicationid",
  { data_type => "raw", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "userid",
  { data_type => "raw", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "password",
  { data_type => "nvarchar2", is_nullable => 0, size => 128 },
  "passwordformat",
  {
    data_type     => "integer",
    default_value => 0,
    is_nullable   => 0,
    original      => { data_type => "number", size => [38, 0] },
  },
  "passwordsalt",
  { data_type => "nvarchar2", is_nullable => 0, size => 128 },
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
);

=head1 PRIMARY KEY

=over 4

=item * L</userid>

=back

=cut

__PACKAGE__->set_primary_key("userid");

=head1 RELATIONS

=head2 applicationid

Type: belongs_to

Related object: L<DbSchema::IMG_Core::Result::OraAspnetApplication>

=cut

__PACKAGE__->belongs_to(
  "applicationid",
  "DbSchema::IMG_Core::Result::OraAspnetApplication",
  { applicationid => "applicationid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 userid

Type: belongs_to

Related object: L<DbSchema::IMG_Core::Result::OraAspnetUser>

=cut

__PACKAGE__->belongs_to(
  "userid",
  "DbSchema::IMG_Core::Result::OraAspnetUser",
  { userid => "userid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hlJ7gBuDbDVWCbN2yf1DLA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

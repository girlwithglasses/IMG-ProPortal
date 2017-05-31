use utf8;
package DBIC::IMG_Gold::Result::RequestAccount;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::RequestAccount

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<REQUEST_ACCOUNT>

=cut

__PACKAGE__->table("REQUEST_ACCOUNT");

=head1 ACCESSORS

=head2 request_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 username

  data_type: 'varchar2'
  is_nullable: 0
  size: 31

=head2 group_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 name

  data_type: 'varchar2'
  is_nullable: 0
  size: 80

=head2 title

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 department

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 email

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 phone

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 organization

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 address

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 city

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 state

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 country

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 comments

  data_type: 'varchar2'
  is_nullable: 0
  size: 1000

=head2 notes

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 status

  data_type: 'varchar2'
  is_nullable: 0
  size: 80

=head2 request_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 modified_by

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 assign_contact_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "request_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "username",
  { data_type => "varchar2", is_nullable => 0, size => 31 },
  "group_name",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "name",
  { data_type => "varchar2", is_nullable => 0, size => 80 },
  "title",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "department",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "email",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "phone",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "organization",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "address",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "city",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "state",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "country",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "comments",
  { data_type => "varchar2", is_nullable => 0, size => 1000 },
  "notes",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "status",
  { data_type => "varchar2", is_nullable => 0, size => 80 },
  "request_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "modified_by",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "assign_contact_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</request_oid>

=back

=cut

__PACKAGE__->set_primary_key("request_oid");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZV0MIeGIex2mPsu6wF6N5A
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/RequestAccount.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::RequestAccount;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::RequestAccount

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<REQUEST_ACCOUNT>

=cut

__PACKAGE__->table("REQUEST_ACCOUNT");

=head1 ACCESSORS

=head2 request_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 username

  data_type: 'varchar2'
  is_nullable: 0
  size: 31

=head2 group_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 name

  data_type: 'varchar2'
  is_nullable: 0
  size: 80

=head2 title

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 department

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 email

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 phone

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 organization

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 address

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 city

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 state

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 country

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 comments

  data_type: 'varchar2'
  is_nullable: 0
  size: 1000

=head2 notes

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 status

  data_type: 'varchar2'
  is_nullable: 0
  size: 80

=head2 request_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 modified_by

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 assign_contact_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "request_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "username",
  { data_type => "varchar2", is_nullable => 0, size => 31 },
  "group_name",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "name",
  { data_type => "varchar2", is_nullable => 0, size => 80 },
  "title",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "department",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "email",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "phone",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "organization",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "address",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "city",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "state",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "country",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "comments",
  { data_type => "varchar2", is_nullable => 0, size => 1000 },
  "notes",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "status",
  { data_type => "varchar2", is_nullable => 0, size => 80 },
  "request_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "modified_by",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "assign_contact_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</request_oid>

=back

=cut

__PACKAGE__->set_primary_key("request_oid");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cfnCKXIEbj33ltTMILkzYQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/RequestAccount.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

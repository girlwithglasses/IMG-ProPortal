use utf8;
package DBIC::IMG_Gold::Result::ProjectItsContactOld;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::ProjectItsContactOld

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<PROJECT_ITS_CONTACT_OLD>

=cut

__PACKAGE__->table("PROJECT_ITS_CONTACT_OLD");
__PACKAGE__->result_source_instance->view_definition("select pi.project_oid, \"c\".CONTACT_ID, \"c\".FIRST_NAME, \"c\".MIDDLE_NAME,\n\"c\".LAST_NAME, \"c\".EMAIL_ADDRESS from\n  project_info pi inner join DW.PROPOSAL\@itslink p\nON pi.ITS_PROPOSAL_ID = p.PROPOSAL_ID LEFT OUTER JOIN\ndw.contact\@itslink \"c\" on p.principal_investigator_id = \"c\".contact_id");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 its_contact_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [10,0]

=head2 first_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 middle_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 last_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 email

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "its_contact_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [10, 0],
  },
  "first_name",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "middle_name",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "last_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "email",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lWjG97q0UzcWlSYVHQv5eA
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/ProjectItsContactOld.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::ProjectItsContactOld;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::ProjectItsContactOld

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<PROJECT_ITS_CONTACT_OLD>

=cut

__PACKAGE__->table("PROJECT_ITS_CONTACT_OLD");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 its_contact_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [10,0]

=head2 first_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 middle_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 last_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 email

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "its_contact_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [10, 0],
  },
  "first_name",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "middle_name",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "last_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "email",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YJszPl4rsbCNAatnl9nBBQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/ProjectItsContactOld.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DBIC::IMG_Gold::Result::DaccLogon;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::DaccLogon

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DACC_LOGON>

=cut

__PACKAGE__->table("DACC_LOGON");

=head1 ACCESSORS

=head2 id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [10,0]

=head2 username

  data_type: 'varchar2'
  is_nullable: 0
  size: 30

=head2 password

  data_type: 'varchar2'
  is_nullable: 0
  size: 16

=head2 full_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 is_admin

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 contact_email_list

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [10, 0],
  },
  "username",
  { data_type => "varchar2", is_nullable => 0, size => 30 },
  "password",
  { data_type => "varchar2", is_nullable => 0, size => 16 },
  "full_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "is_admin",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "contact_email_list",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<dacc_logon_uk>

=over 4

=item * L</username>

=back

=cut

__PACKAGE__->add_unique_constraint("dacc_logon_uk", ["username"]);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fg8WqMMhoIc8MQ8PtaEMUQ
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/DaccLogon.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::DaccLogon;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::DaccLogon

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DACC_LOGON>

=cut

__PACKAGE__->table("DACC_LOGON");

=head1 ACCESSORS

=head2 id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [10,0]

=head2 username

  data_type: 'varchar2'
  is_nullable: 0
  size: 30

=head2 password

  data_type: 'varchar2'
  is_nullable: 0
  size: 16

=head2 full_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 is_admin

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 contact_email_list

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [10, 0],
  },
  "username",
  { data_type => "varchar2", is_nullable => 0, size => 30 },
  "password",
  { data_type => "varchar2", is_nullable => 0, size => 16 },
  "full_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "is_admin",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "contact_email_list",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<dacc_logon_uk>

=over 4

=item * L</username>

=back

=cut

__PACKAGE__->add_unique_constraint("dacc_logon_uk", ["username"]);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iH/eEihnP1Tmt6ML1dygag


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/DaccLogon.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DBIC::IMG_Gold::Result::TInstitutesBak;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::TInstitutesBak

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<T_INSTITUTES_BAK>

=cut

__PACKAGE__->table("T_INSTITUTES_BAK");

=head1 ACCESSORS

=head2 institute_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 400

=head2 url

  data_type: 'varchar2'
  is_nullable: 1
  size: 240

=head2 country

  data_type: 'varchar2'
  is_nullable: 1
  size: 40

=cut

__PACKAGE__->add_columns(
  "institute_name",
  { data_type => "varchar2", is_nullable => 0, size => 400 },
  "url",
  { data_type => "varchar2", is_nullable => 1, size => 240 },
  "country",
  { data_type => "varchar2", is_nullable => 1, size => 40 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XZRryKylGjjgD/PM/BntcA
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/TInstitutesBak.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::TInstitutesBak;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::TInstitutesBak

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<T_INSTITUTES_BAK>

=cut

__PACKAGE__->table("T_INSTITUTES_BAK");

=head1 ACCESSORS

=head2 institute_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 400

=head2 url

  data_type: 'varchar2'
  is_nullable: 1
  size: 240

=head2 country

  data_type: 'varchar2'
  is_nullable: 1
  size: 40

=cut

__PACKAGE__->add_columns(
  "institute_name",
  { data_type => "varchar2", is_nullable => 0, size => 400 },
  "url",
  { data_type => "varchar2", is_nullable => 1, size => 240 },
  "country",
  { data_type => "varchar2", is_nullable => 1, size => 40 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FFzHyDbuwCDbnWPqiAYNuA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/TInstitutesBak.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

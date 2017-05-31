use utf8;
package DBIC::IMG_Gold::Result::Announcement;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::Announcement

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<ANNOUNCEMENT>

=cut

__PACKAGE__->table("ANNOUNCEMENT");

=head1 ACCESSORS

=head2 type

  data_type: 'varchar2'
  is_nullable: 0
  size: 80

=head2 notes

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

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
  "type",
  { data_type => "varchar2", is_nullable => 0, size => 80 },
  "notes",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
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


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pBdiZwcs8c6o58m43IThmw
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/Announcement.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::Announcement;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::Announcement

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<ANNOUNCEMENT>

=cut

__PACKAGE__->table("ANNOUNCEMENT");

=head1 ACCESSORS

=head2 type

  data_type: 'varchar2'
  is_nullable: 0
  size: 80

=head2 notes

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

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
  "type",
  { data_type => "varchar2", is_nullable => 0, size => 80 },
  "notes",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QliI3g5XQ817KAbI9O/8iQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/Announcement.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

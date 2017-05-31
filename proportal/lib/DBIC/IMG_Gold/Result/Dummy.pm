use utf8;
package DBIC::IMG_Gold::Result::Dummy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::Dummy

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DUMMY>

=cut

__PACKAGE__->table("DUMMY");

=head1 ACCESSORS

=head2 a

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "a",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mEJJTYx0OajNh79cUrj5lA
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/Dummy.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::Dummy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::Dummy

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DUMMY>

=cut

__PACKAGE__->table("DUMMY");

=head1 ACCESSORS

=head2 a

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "a",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NTygfjUrTAEL9F2nmZpSSg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/Dummy.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

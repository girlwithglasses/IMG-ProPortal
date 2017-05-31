use utf8;
package DBIC::IMG_Gold::Result::WebPageCodecv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::WebPageCodecv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<WEB_PAGE_CODECV>

=cut

__PACKAGE__->table("WEB_PAGE_CODECV");

=head1 ACCESSORS

=head2 term_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=cut

__PACKAGE__->add_columns(
  "term_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
);

=head1 PRIMARY KEY

=over 4

=item * L</term_oid>

=back

=cut

__PACKAGE__->set_primary_key("term_oid");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BzuFpNRZJ6+6a1XVmJnL2g
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/WebPageCodecv.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::WebPageCodecv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::WebPageCodecv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<WEB_PAGE_CODECV>

=cut

__PACKAGE__->table("WEB_PAGE_CODECV");

=head1 ACCESSORS

=head2 term_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=cut

__PACKAGE__->add_columns(
  "term_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
);

=head1 PRIMARY KEY

=over 4

=item * L</term_oid>

=back

=cut

__PACKAGE__->set_primary_key("term_oid");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:p6ez0LuvXeVWTzsVRdBUxg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/WebPageCodecv.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

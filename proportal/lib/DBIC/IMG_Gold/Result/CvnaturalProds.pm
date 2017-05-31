use utf8;
package DBIC::IMG_Gold::Result::CvnaturalProds;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::CvnaturalProds

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<CVNATURAL_PRODS>

=cut

__PACKAGE__->table("CVNATURAL_PRODS");

=head1 ACCESSORS

=head2 np_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 np_product_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 np_product_link

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 np_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 np_activity

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 img_compound_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "np_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "np_product_name",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "np_product_link",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "np_type",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "np_activity",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "img_compound_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</np_id>

=back

=cut

__PACKAGE__->set_primary_key("np_id");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6EbtPijvrO9dsYT+mn7uKQ
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/CvnaturalProds.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::CvnaturalProds;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::CvnaturalProds

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<CVNATURAL_PRODS>

=cut

__PACKAGE__->table("CVNATURAL_PRODS");

=head1 ACCESSORS

=head2 np_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 np_product_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 np_product_link

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 np_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 np_activity

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 img_compound_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "np_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "np_product_name",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "np_product_link",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "np_type",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "np_activity",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "img_compound_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</np_id>

=back

=cut

__PACKAGE__->set_primary_key("np_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hy1lSGZDNQB+YdFHbe3Fcg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/CvnaturalProds.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

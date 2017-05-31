use utf8;
package DBIC::IMG_Gold::Result::GoldImgNatProdEntity;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::GoldImgNatProdEntity

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GOLD_IMG_NAT_PROD_ENTITY>

=cut

__PACKAGE__->table("GOLD_IMG_NAT_PROD_ENTITY");

=head1 ACCESSORS

=head2 gold_np_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 np_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 project_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 img_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 bio_cluster_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 evidence

  data_type: 'varchar2'
  default_value: 'Experimental'
  is_nullable: 0
  size: 20

=head2 activity

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=cut

__PACKAGE__->add_columns(
  "gold_np_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "np_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "project_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "img_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "bio_cluster_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "evidence",
  {
    data_type => "varchar2",
    default_value => "Experimental",
    is_nullable => 0,
    size => 20,
  },
  "activity",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
);

=head1 PRIMARY KEY

=over 4

=item * L</gold_np_id>

=back

=cut

__PACKAGE__->set_primary_key("gold_np_id");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NJfd4qeElyy20bdfzSYeYQ
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/GoldImgNatProdEntity.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::GoldImgNatProdEntity;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::GoldImgNatProdEntity

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GOLD_IMG_NAT_PROD_ENTITY>

=cut

__PACKAGE__->table("GOLD_IMG_NAT_PROD_ENTITY");

=head1 ACCESSORS

=head2 gold_np_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 np_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 project_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 img_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 bio_cluster_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 evidence

  data_type: 'varchar2'
  default_value: 'Experimental'
  is_nullable: 0
  size: 20

=head2 activity

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=cut

__PACKAGE__->add_columns(
  "gold_np_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "np_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "project_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "img_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "bio_cluster_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "evidence",
  {
    data_type => "varchar2",
    default_value => "Experimental",
    is_nullable => 0,
    size => 20,
  },
  "activity",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
);

=head1 PRIMARY KEY

=over 4

=item * L</gold_np_id>

=back

=cut

__PACKAGE__->set_primary_key("gold_np_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IanaGODiGPsy8++AoqUTHQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/GoldImgNatProdEntity.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

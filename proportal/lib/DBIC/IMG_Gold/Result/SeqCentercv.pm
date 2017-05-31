use utf8;
package DBIC::IMG_Gold::Result::SeqCentercv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::SeqCentercv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<SEQ_CENTERCV>

=cut

__PACKAGE__->table("SEQ_CENTERCV");

=head1 ACCESSORS

=head2 seq_center_id

  data_type: 'numeric'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number"}
  sequence: 'seq_centercv_seq'
  size: 126

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 link

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=cut

__PACKAGE__->add_columns(
  "seq_center_id",
  {
    data_type => "numeric",
    is_auto_increment => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    sequence => "seq_centercv_seq",
    size => 126,
  },
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "link",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
);

=head1 PRIMARY KEY

=over 4

=item * L</seq_center_id>

=back

=cut

__PACKAGE__->set_primary_key("seq_center_id");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Gd9Ol7b7ImrO5EPeTcabYg
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/SeqCentercv.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::SeqCentercv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::SeqCentercv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<SEQ_CENTERCV>

=cut

__PACKAGE__->table("SEQ_CENTERCV");

=head1 ACCESSORS

=head2 seq_center_id

  data_type: 'numeric'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number"}
  sequence: 'seq_centercv_seq'
  size: 126

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 link

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=cut

__PACKAGE__->add_columns(
  "seq_center_id",
  {
    data_type => "numeric",
    is_auto_increment => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    sequence => "seq_centercv_seq",
    size => 126,
  },
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "link",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
);

=head1 PRIMARY KEY

=over 4

=item * L</seq_center_id>

=back

=cut

__PACKAGE__->set_primary_key("seq_center_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fjGZzgq8q76yHP+CH3Bkjg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/SeqCentercv.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

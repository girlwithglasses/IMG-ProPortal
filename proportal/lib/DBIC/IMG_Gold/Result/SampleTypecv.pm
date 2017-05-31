use utf8;
package DBIC::IMG_Gold::Result::SampleTypecv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::SampleTypecv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<SAMPLE_TYPECV>

=cut

__PACKAGE__->table("SAMPLE_TYPECV");

=head1 ACCESSORS

=head2 cv_term

  data_type: 'varchar2'
  is_nullable: 0
  size: 30

=cut

__PACKAGE__->add_columns(
  "cv_term",
  { data_type => "varchar2", is_nullable => 0, size => 30 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EbUrv1jtrqpgVbjoJfpp4Q
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/SampleTypecv.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::SampleTypecv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::SampleTypecv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<SAMPLE_TYPECV>

=cut

__PACKAGE__->table("SAMPLE_TYPECV");

=head1 ACCESSORS

=head2 cv_term

  data_type: 'varchar2'
  is_nullable: 0
  size: 30

=cut

__PACKAGE__->add_columns(
  "cv_term",
  { data_type => "varchar2", is_nullable => 0, size => 30 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3BOmLSF6ki2ornVqHbnfRw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/SampleTypecv.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

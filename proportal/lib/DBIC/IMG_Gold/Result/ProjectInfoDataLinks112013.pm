use utf8;
package DBIC::IMG_Gold::Result::ProjectInfoDataLinks112013;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::ProjectInfoDataLinks112013

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<PROJECT_INFO_DATA_LINKS_112013>

=cut

__PACKAGE__->table("PROJECT_INFO_DATA_LINKS_112013");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 db_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 id

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 url

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 link_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "db_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "id",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "url",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "link_type",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cJub/32hGLyTEQc27+HIAQ
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/ProjectInfoDataLinks112013.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::ProjectInfoDataLinks112013;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::ProjectInfoDataLinks112013

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<PROJECT_INFO_DATA_LINKS_112013>

=cut

__PACKAGE__->table("PROJECT_INFO_DATA_LINKS_112013");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 db_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 id

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 url

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 link_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "db_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "id",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "url",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "link_type",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qbaCY9kSrfeC/ZrPdblwHw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/ProjectInfoDataLinks112013.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

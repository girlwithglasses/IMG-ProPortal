use utf8;
package DBIC::IMG_Gold::Result::EnvSampleDataLink;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::EnvSampleDataLink

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<ENV_SAMPLE_DATA_LINKS>

=cut

__PACKAGE__->table("ENV_SAMPLE_DATA_LINKS");

=head1 ACCESSORS

=head2 sample_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

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
  "sample_oid",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
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

=head1 RELATIONS

=head2 sample_oid

Type: belongs_to

Related object: L<DBIC::IMG_Gold::Result::EnvSample>

=cut

__PACKAGE__->belongs_to(
  "sample_oid",
  "DBIC::IMG_Gold::Result::EnvSample",
  { sample_oid => "sample_oid" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dcolA4KEJpXkoqhwd8RvSA
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/EnvSampleDataLink.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::EnvSampleDataLink;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::EnvSampleDataLink

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<ENV_SAMPLE_DATA_LINKS>

=cut

__PACKAGE__->table("ENV_SAMPLE_DATA_LINKS");

=head1 ACCESSORS

=head2 sample_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

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
  "sample_oid",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
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

=head1 RELATIONS

=head2 sample_oid

Type: belongs_to

Related object: L<DBIC::IMG_Gold::Result::EnvSample>

=cut

__PACKAGE__->belongs_to(
  "sample_oid",
  "DBIC::IMG_Gold::Result::EnvSample",
  { sample_oid => "sample_oid" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nBTf84bf/R14tZWsgXPybw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/EnvSampleDataLink.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

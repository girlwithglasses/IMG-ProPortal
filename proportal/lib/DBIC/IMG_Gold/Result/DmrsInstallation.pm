use utf8;
package DBIC::IMG_Gold::Result::DmrsInstallation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::DmrsInstallation

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<DMRS_INSTALLATION>

=cut

__PACKAGE__->table("DMRS_INSTALLATION");
__PACKAGE__->result_source_instance->view_definition("select 1.6 DMRS_Persistence_Version, 1.0 DMRS_Reports_Version, to_timestamp('2013/09/26 15:05:25','YYYY/MM/DD HH24:MI:SS') Created_On from dual with read only\n ");

=head1 ACCESSORS

=head2 dmrs_persistence_version

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 dmrs_reports_version

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 created_on

  data_type: 'timestamp'
  is_nullable: 1
  size: 9

=cut

__PACKAGE__->add_columns(
  "dmrs_persistence_version",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "dmrs_reports_version",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "created_on",
  { data_type => "timestamp", is_nullable => 1, size => 9 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TLQ/Qb8K4pW/SiBXNAlN3Q
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/DmrsInstallation.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::DmrsInstallation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::DmrsInstallation

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<DMRS_INSTALLATION>

=cut

__PACKAGE__->table("DMRS_INSTALLATION");

=head1 ACCESSORS

=head2 dmrs_persistence_version

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 dmrs_reports_version

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 created_on

  data_type: 'timestamp'
  is_nullable: 1
  size: 9

=cut

__PACKAGE__->add_columns(
  "dmrs_persistence_version",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "dmrs_reports_version",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "created_on",
  { data_type => "timestamp", is_nullable => 1, size => 9 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IT10Kcb/s0CGkoAcTOMRMA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/DmrsInstallation.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

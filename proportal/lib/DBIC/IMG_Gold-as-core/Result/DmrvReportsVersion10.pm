use utf8;
package DbSchema::IMG_Core::Result::DmrvReportsVersion10;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::DmrvReportsVersion10

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<DMRV_REPORTS_VERSION_1_0>

=cut

__PACKAGE__->table("DMRV_REPORTS_VERSION_1_0");

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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:X1GcZZxEFfgIcHxz/yEkRQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

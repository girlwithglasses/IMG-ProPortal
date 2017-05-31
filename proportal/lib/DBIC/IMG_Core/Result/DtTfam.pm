use utf8;
package DBIC::IMG_Core::Result::DtTfam;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::DtTfam

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DT_TFAM>

=cut

__PACKAGE__->table("DT_TFAM");

=head1 ACCESSORS

=head2 tfam_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=cut

__PACKAGE__->add_columns(
  "tfam_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IEuJjD3ieFQEG9RTKyUKUw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

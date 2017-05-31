use utf8;
package DBIC::IMG_Gold::Result::BadDepthFileWarning;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::BadDepthFileWarning

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BAD_DEPTH_FILE_WARNINGS>

=cut

__PACKAGE__->table("BAD_DEPTH_FILE_WARNINGS");

=head1 ACCESSORS

=head2 submission_id

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 warn_time

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "submission_id",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "warn_time",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);

=head1 RELATIONS

=head2 submission

Type: belongs_to

Related object: L<DBIC::IMG_Gold::Result::Submission>

=cut

__PACKAGE__->belongs_to(
  "submission",
  "DBIC::IMG_Gold::Result::Submission",
  { submission_id => "submission_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:44gcChVW+wgT3iSgN8qbDA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

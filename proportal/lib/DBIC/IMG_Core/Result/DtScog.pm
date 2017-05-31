use utf8;
package DBIC::IMG_Core::Result::DtScog;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::DtScog

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DT_SCOGS>

=cut

__PACKAGE__->table("DT_SCOGS");

=head1 ACCESSORS

=head2 cog_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 cog_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 single_copy

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "cog_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "cog_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "single_copy",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:950wOL4cMyG/vcCCk3WOxA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

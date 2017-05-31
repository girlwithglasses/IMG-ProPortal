use utf8;
package DBIC::IMG_Core::Result::DtViralSpacer;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::DtViralSpacer

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DT_VIRAL_SPACER>

=cut

__PACKAGE__->table("DT_VIRAL_SPACER");

=head1 ACCESSORS

=head2 spacer_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 spacer_seq

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 alt_short_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "spacer_id",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "spacer_seq",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "alt_short_id",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TlCr33vrQdPj0RSL6d6TGA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

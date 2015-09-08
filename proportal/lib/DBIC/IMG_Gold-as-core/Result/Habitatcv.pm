use utf8;
package DbSchema::IMG_Core::Result::Habitatcv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::Habitatcv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<HABITATCV>

=cut

__PACKAGE__->table("HABITATCV");

=head1 ACCESSORS

=head2 cv_term

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 envo_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=cut

__PACKAGE__->add_columns(
  "cv_term",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "envo_id",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
);

=head1 PRIMARY KEY

=over 4

=item * L</cv_term>

=back

=cut

__PACKAGE__->set_primary_key("cv_term");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EtxjGgArAynztWxY9dBu3w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

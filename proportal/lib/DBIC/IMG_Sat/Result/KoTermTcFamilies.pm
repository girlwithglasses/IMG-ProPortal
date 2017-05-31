use utf8;
package DBIC::IMG_Sat::Result::KoTermTcFamilies;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::KoTermTcFamilies

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<KO_TERM_TC_FAMILIES>

=cut

__PACKAGE__->table("KO_TERM_TC_FAMILIES");

=head1 ACCESSORS

=head2 ko_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 tc_families

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "ko_id",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "tc_families",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Y2s4JGWCswEYIgYbEtRSKA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

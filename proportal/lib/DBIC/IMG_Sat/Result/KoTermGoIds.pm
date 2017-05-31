use utf8;
package DBIC::IMG_Sat::Result::KoTermGoIds;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::KoTermGoIds

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<KO_TERM_GO_IDS>

=cut

__PACKAGE__->table("KO_TERM_GO_IDS");

=head1 ACCESSORS

=head2 ko_id

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 0
  size: 255

=head2 go_ids

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "ko_id",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 0, size => 255 },
  "go_ids",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 RELATIONS

=head2 ko

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::KoTerm>

=cut

__PACKAGE__->belongs_to(
  "ko",
  "DBIC::IMG_Sat::Result::KoTerm",
  { ko_id => "ko_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sjoE/F7/bN7HfpGI1W5kgg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

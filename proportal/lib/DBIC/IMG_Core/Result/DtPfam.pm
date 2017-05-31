use utf8;
package DBIC::IMG_Core::Result::DtPfam;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::DtPfam

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DT_PFAM>

=cut

__PACKAGE__->table("DT_PFAM");

=head1 ACCESSORS

=head2 pfam_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=cut

__PACKAGE__->add_columns(
  "pfam_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6llYErN1ayMcZAbgKI+y7g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

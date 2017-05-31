use utf8;
package DBIC::IMG_Gold::Result::T1Audit;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::T1Audit

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<T1_AUDIT>

=cut

__PACKAGE__->table("T1_AUDIT");

=head1 ACCESSORS

=head2 f1

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 f2

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "f1",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "f2",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "submission_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3g1oCBUcKXB2TiPeFBFykA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

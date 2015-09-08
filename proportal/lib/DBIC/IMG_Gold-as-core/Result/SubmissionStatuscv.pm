use utf8;
package DbSchema::IMG_Core::Result::SubmissionStatuscv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::SubmissionStatuscv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<SUBMISSION_STATUSCV>

=cut

__PACKAGE__->table("SUBMISSION_STATUSCV");

=head1 ACCESSORS

=head2 term_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 cv_term

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 cv_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 terminal_status

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
  "term_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "cv_term",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "cv_type",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "terminal_status",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 1,
    size => 10,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</term_oid>

=back

=cut

__PACKAGE__->set_primary_key("term_oid");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QLcymrXuZWh8YM0tgWItsw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DbSchema::IMG_Core::Result::Study;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::Study

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<STUDY>

=cut

__PACKAGE__->table("STUDY");

=head1 ACCESSORS

=head2 study_id

  data_type: 'numeric'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number"}
  sequence: 'study_pk_seq'
  size: 126

=head2 study_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=cut

__PACKAGE__->add_columns(
  "study_id",
  {
    data_type => "numeric",
    is_auto_increment => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    sequence => "study_pk_seq",
    size => 126,
  },
  "study_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
);

=head1 PRIMARY KEY

=over 4

=item * L</study_id>

=back

=cut

__PACKAGE__->set_primary_key("study_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:067+kWpWvPi60EXOjHsWqg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DBIC::IMG_Sat::Result::PropertyStepEvidences;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::PropertyStepEvidences

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<PROPERTY_STEP_EVIDENCES>

=cut

__PACKAGE__->table("PROPERTY_STEP_EVIDENCES");

=head1 ACCESSORS

=head2 step_accession

  data_type: 'varchar2'
  is_nullable: 0
  size: 100

=head2 query

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 method

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=cut

__PACKAGE__->add_columns(
  "step_accession",
  { data_type => "varchar2", is_nullable => 0, size => 100 },
  "query",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "method",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0LN9kOO7mudzWo9+JsprTQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

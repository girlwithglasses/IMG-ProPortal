use utf8;
package DBIC::IMG_Sat::Result::InterproGoTerms;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::InterproGoTerms

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<INTERPRO_GO_TERMS>

=cut

__PACKAGE__->table("INTERPRO_GO_TERMS");

=head1 ACCESSORS

=head2 ext_accession

  data_type: 'varchar2'
  is_nullable: 0
  size: 100

=head2 go_terms

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "ext_accession",
  { data_type => "varchar2", is_nullable => 0, size => 100 },
  "go_terms",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ji4pVeOVQW7mRm5Ct1MA3A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

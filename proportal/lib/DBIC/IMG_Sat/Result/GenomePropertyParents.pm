use utf8;
package DBIC::IMG_Sat::Result::GenomePropertyParents;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::GenomePropertyParents

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENOME_PROPERTY_PARENTS>

=cut

__PACKAGE__->table("GENOME_PROPERTY_PARENTS");

=head1 ACCESSORS

=head2 prop_accession

  data_type: 'varchar2'
  is_nullable: 0
  size: 100

=head2 parents

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "prop_accession",
  { data_type => "varchar2", is_nullable => 0, size => 100 },
  "parents",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7GfO0IVObqa1tVIXpdaCSg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

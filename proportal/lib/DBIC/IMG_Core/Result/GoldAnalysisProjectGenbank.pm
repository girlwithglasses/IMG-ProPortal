use utf8;
package DBIC::IMG_Core::Result::GoldAnalysisProjectGenbank;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GoldAnalysisProjectGenbank

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GOLD_ANALYSIS_PROJECT_GENBANKS>

=cut

__PACKAGE__->table("GOLD_ANALYSIS_PROJECT_GENBANKS");

=head1 ACCESSORS

=head2 gold_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 16

=head2 genbank_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 assembly_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=cut

__PACKAGE__->add_columns(
  "gold_id",
  { data_type => "varchar2", is_nullable => 0, size => 16 },
  "genbank_id",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "assembly_accession",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-07-13 15:21:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PQaV7LXCZKA5A62fF1i27g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

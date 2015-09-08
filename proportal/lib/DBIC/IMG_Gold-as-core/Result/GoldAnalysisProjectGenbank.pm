use utf8;
package DbSchema::IMG_Core::Result::GoldAnalysisProjectGenbank;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::GoldAnalysisProjectGenbank

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sHzsHbZ2WZ/R9maHdVIt/Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

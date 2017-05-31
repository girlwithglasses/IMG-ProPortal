use utf8;
package DBIC::IMG_Gold::Result::GoldAnalysisProjectGenbank;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::GoldAnalysisProjectGenbank

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


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ldh7TPOQaOff66oEpQ2wyQ
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/GoldAnalysisProjectGenbank.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::GoldAnalysisProjectGenbank;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::GoldAnalysisProjectGenbank

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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rqv6C7wNIfUw7R3fvLoBog


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/GoldAnalysisProjectGenbank.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

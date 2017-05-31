use utf8;
package DBIC::IMG_Sat::Result::BiocycProteinCatalyzes;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::BiocycProteinCatalyzes

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BIOCYC_PROTEIN_CATALYZES>

=cut

__PACKAGE__->table("BIOCYC_PROTEIN_CATALYZES");

=head1 ACCESSORS

=head2 unique_id

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 0
  size: 100

=head2 enzrxn

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 255

=head2 ec_number

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "unique_id",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 0, size => 100 },
  "enzrxn",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 255 },
  "ec_number",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 RELATIONS

=head2 enzrxn

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::BiocycEnzrxn>

=cut

__PACKAGE__->belongs_to(
  "enzrxn",
  "DBIC::IMG_Sat::Result::BiocycEnzrxn",
  { unique_id => "enzrxn" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 unique

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::BiocycProtein>

=cut

__PACKAGE__->belongs_to(
  "unique",
  "DBIC::IMG_Sat::Result::BiocycProtein",
  { unique_id => "unique_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/ARdn+rUpUOCDbohi0RKlw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

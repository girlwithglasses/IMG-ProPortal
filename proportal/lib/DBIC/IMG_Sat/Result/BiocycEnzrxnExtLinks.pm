use utf8;
package DBIC::IMG_Sat::Result::BiocycEnzrxnExtLinks;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::BiocycEnzrxnExtLinks

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BIOCYC_ENZRXN_EXT_LINKS>

=cut

__PACKAGE__->table("BIOCYC_ENZRXN_EXT_LINKS");

=head1 ACCESSORS

=head2 unique_id

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 0
  size: 255

=head2 id

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 db_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "unique_id",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 0, size => 255 },
  "id",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "db_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 RELATIONS

=head2 unique

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::BiocycEnzrxn>

=cut

__PACKAGE__->belongs_to(
  "unique",
  "DBIC::IMG_Sat::Result::BiocycEnzrxn",
  { unique_id => "unique_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:y2QAqEeJoIORNWCUU9R2pg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

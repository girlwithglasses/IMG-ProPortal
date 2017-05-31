use utf8;
package DBIC::IMG_Sat::Result::ImageRoiEnzymes;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::ImageRoiEnzymes

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<IMAGE_ROI_ENZYMES>

=cut

__PACKAGE__->table("IMAGE_ROI_ENZYMES");

=head1 ACCESSORS

=head2 roi_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 enzymes

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 30

=cut

__PACKAGE__->add_columns(
  "roi_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "enzymes",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 30 },
);

=head1 RELATIONS

=head2 enzyme

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::Enzyme>

=cut

__PACKAGE__->belongs_to(
  "enzyme",
  "DBIC::IMG_Sat::Result::Enzyme",
  { ec_number => "enzymes" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OjgQkYqoOjQvY0G8WhQcgQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DBIC::IMG_Core::Result::CassetteBoxCogXlog;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::CassetteBoxCogXlog

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<CASSETTE_BOX_COG_XLOGS>

=cut

__PACKAGE__->table("CASSETTE_BOX_COG_XLOGS");

=head1 ACCESSORS

=head2 box_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 cog_cluster

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "box_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "cog_cluster",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5T8DhkNWBYvxMeCycpUNQg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

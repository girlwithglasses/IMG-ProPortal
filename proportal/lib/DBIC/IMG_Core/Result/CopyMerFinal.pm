use utf8;
package DBIC::IMG_Core::Result::CopyMerFinal;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::CopyMerFinal

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<COPY_MER_FINAL>

=cut

__PACKAGE__->table("COPY_MER_FINAL");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8jy1J4L0Aq5vw/jMrv66xA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DBIC::IMG_Core::Result::DeleteScaffold;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::DeleteScaffold

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DELETE_SCAFFOLDS>

=cut

__PACKAGE__->table("DELETE_SCAFFOLDS");

=head1 ACCESSORS

=head2 scaffold_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "scaffold_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:I+MOvt7MeN8H7Q6kgKJW7w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

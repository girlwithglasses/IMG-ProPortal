use utf8;
package DbSchema::IMG_Core::Result::BioprojectRelevancecv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::BioprojectRelevancecv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<BIOPROJECT_RELEVANCECV>

=cut

__PACKAGE__->table("BIOPROJECT_RELEVANCECV");

=head1 ACCESSORS

=head2 br_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 relevance

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "br_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "relevance",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</br_id>

=back

=cut

__PACKAGE__->set_primary_key("br_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xkCz+XwE8DR6/pIV7PzbEw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DbSchema::IMG_Core::Result::Collaboratorcv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::Collaboratorcv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<COLLABORATORCV>

=cut

__PACKAGE__->table("COLLABORATORCV");

=head1 ACCESSORS

=head2 collaborator_id

  data_type: 'numeric'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number"}
  sequence: 'collaboratorcv_id_seq'
  size: 126

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 link

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=cut

__PACKAGE__->add_columns(
  "collaborator_id",
  {
    data_type => "numeric",
    is_auto_increment => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    sequence => "collaboratorcv_id_seq",
    size => 126,
  },
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "link",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
);

=head1 PRIMARY KEY

=over 4

=item * L</collaborator_id>

=back

=cut

__PACKAGE__->set_primary_key("collaborator_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:z6EtF3Ta+tBaI20+p+T9Ew


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

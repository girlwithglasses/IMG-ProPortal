use utf8;
package DbSchema::IMG_Core::Result::ProjectMetaUpdate;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ProjectMetaUpdate

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<PROJECT_META_UPDATES>

=cut

__PACKAGE__->table("PROJECT_META_UPDATES");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 update_run

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [1,0]

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "update_run",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [1, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nDdssYwDu1bYAsDxnTXmGQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

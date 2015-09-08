use utf8;
package DbSchema::IMG_Core::Result::SchemaMigration;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::SchemaMigration

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<SCHEMA_MIGRATIONS>

=cut

__PACKAGE__->table("SCHEMA_MIGRATIONS");

=head1 ACCESSORS

=head2 version

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "version",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hwUvpHnS7ZNuLFYb0dKlMw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

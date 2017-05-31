use utf8;
package DBIC::IMG_Core::Result::DbSource;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::DbSource

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DB_SOURCE>

=cut

__PACKAGE__->table("DB_SOURCE");

=head1 ACCESSORS

=head2 db_code

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 base_url

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "db_code",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "base_url",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</db_code>

=back

=cut

__PACKAGE__->set_primary_key("db_code");

=head1 RELATIONS

=head2 gene_pdb_xrefs

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GenePdbXref>

=cut

__PACKAGE__->has_many(
  "gene_pdb_xrefs",
  "DBIC::IMG_Core::Result::GenePdbXref",
  { "foreign.db_name" => "self.db_code" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hmiEbb0sRDwjapqz9zpyBw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

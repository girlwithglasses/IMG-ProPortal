use utf8;
package DbSchema::IMG_Core::Result::MetagenomicClassification;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::MetagenomicClassification

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<METAGENOMIC_CLASSIFICATION>

=cut

__PACKAGE__->table("METAGENOMIC_CLASSIFICATION");

=head1 ACCESSORS

=head2 mc_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 ecosystem_category

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 ecosystem_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 ecosystem_subtype

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 specific_ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=cut

__PACKAGE__->add_columns(
  "mc_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "ecosystem_category",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "ecosystem_type",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "ecosystem_subtype",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "specific_ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
);

=head1 PRIMARY KEY

=over 4

=item * L</mc_id>

=back

=cut

__PACKAGE__->set_primary_key("mc_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:531OwHveEeRcOhRku74aMQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

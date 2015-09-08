use utf8;
package DbSchema::IMG_Core::Result::OrganismSort;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OrganismSort

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ORGANISM_SORT>

=cut

__PACKAGE__->table("ORGANISM_SORT");

=head1 ACCESSORS

=head2 display_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 ncbi_taxon_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 strain

  data_type: 'varchar2'
  default_value: null
  is_nullable: 1
  size: 255

=head2 genus

  data_type: 'varchar2'
  default_value: null
  is_nullable: 1
  size: 255

=head2 species

  data_type: 'varchar2'
  default_value: null
  is_nullable: 1
  size: 255

=head2 domain

  data_type: 'varchar2'
  default_value: null
  is_nullable: 1
  size: 255

=head2 phylogeny

  data_type: 'varchar2'
  default_value: null
  is_nullable: 1
  size: 255

=head2 ncbi_phylum

  data_type: 'varchar2'
  default_value: null
  is_nullable: 1
  size: 255

=head2 ncbi_class

  data_type: 'varchar2'
  default_value: null
  is_nullable: 1
  size: 255

=head2 ncbi_order

  data_type: 'varchar2'
  default_value: null
  is_nullable: 1
  size: 255

=head2 ncbi_genus

  data_type: 'varchar2'
  default_value: null
  is_nullable: 1
  size: 255

=head2 ncbi_species

  data_type: 'varchar2'
  default_value: null
  is_nullable: 1
  size: 255

=head2 group_id

  data_type: 'numeric'
  default_value: null
  is_auto_increment: 1
  is_nullable: 1
  original: {data_type => "number"}
  sequence: 'organism_group_id_seq'
  size: 126

=cut

__PACKAGE__->add_columns(
  "display_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "ncbi_taxon_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "strain",
  {
    data_type => "varchar2",
    default_value => \"null",
    is_nullable => 1,
    size => 255,
  },
  "genus",
  {
    data_type => "varchar2",
    default_value => \"null",
    is_nullable => 1,
    size => 255,
  },
  "species",
  {
    data_type => "varchar2",
    default_value => \"null",
    is_nullable => 1,
    size => 255,
  },
  "domain",
  {
    data_type => "varchar2",
    default_value => \"null",
    is_nullable => 1,
    size => 255,
  },
  "phylogeny",
  {
    data_type => "varchar2",
    default_value => \"null",
    is_nullable => 1,
    size => 255,
  },
  "ncbi_phylum",
  {
    data_type => "varchar2",
    default_value => \"null",
    is_nullable => 1,
    size => 255,
  },
  "ncbi_class",
  {
    data_type => "varchar2",
    default_value => \"null",
    is_nullable => 1,
    size => 255,
  },
  "ncbi_order",
  {
    data_type => "varchar2",
    default_value => \"null",
    is_nullable => 1,
    size => 255,
  },
  "ncbi_genus",
  {
    data_type => "varchar2",
    default_value => \"null",
    is_nullable => 1,
    size => 255,
  },
  "ncbi_species",
  {
    data_type => "varchar2",
    default_value => \"null",
    is_nullable => 1,
    size => 255,
  },
  "group_id",
  {
    data_type         => "numeric",
    default_value     => \"null",
    is_auto_increment => 1,
    is_nullable       => 1,
    original          => { data_type => "number" },
    sequence          => "organism_group_id_seq",
    size              => 126,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+9W0kw/pYH5tNdyQyfv6VA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

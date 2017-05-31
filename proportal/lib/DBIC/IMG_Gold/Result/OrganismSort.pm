use utf8;
package DBIC::IMG_Gold::Result::OrganismSort;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::OrganismSort

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

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


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:N3hnZsZfLyTH8L8wuddRGQ
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/OrganismSort.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::OrganismSort;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::OrganismSort

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vB7K9lkN0Hol5P75c1ExcQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/OrganismSort.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DBIC::IMG_Core::Result::DtMvcTaxonomy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::DtMvcTaxonomy

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DT_MVC_TAXONOMY>

=cut

__PACKAGE__->table("DT_MVC_TAXONOMY");

=head1 ACCESSORS

=head2 mvc

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 domain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 phylum

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ir_class

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ir_order

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 family

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 subfamily

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 genus

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 species

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 lineage

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=cut

__PACKAGE__->add_columns(
  "mvc",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "domain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "phylum",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ir_class",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ir_order",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "family",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "subfamily",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "genus",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "species",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "lineage",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:c9/PD3MryKIGVK8f1kLA0g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

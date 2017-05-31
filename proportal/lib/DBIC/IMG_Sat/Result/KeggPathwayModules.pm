use utf8;
package DBIC::IMG_Sat::Result::KeggPathwayModules;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::KeggPathwayModules

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<KEGG_PATHWAY_MODULES>

=cut

__PACKAGE__->table("KEGG_PATHWAY_MODULES");

=head1 ACCESSORS

=head2 pathway_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 modules

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "pathway_oid",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "modules",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 20 },
);

=head1 RELATIONS

=head2 module

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::KeggModule>

=cut

__PACKAGE__->belongs_to(
  "module",
  "DBIC::IMG_Sat::Result::KeggModule",
  { module_id => "modules" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 pathway_oid

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::KeggPathway>

=cut

__PACKAGE__->belongs_to(
  "pathway_oid",
  "DBIC::IMG_Sat::Result::KeggPathway",
  { pathway_oid => "pathway_oid" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:16LP1tSTcXZXLF/btS7fsg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DBIC::IMG_Sat::Result::CogPathwayCogMembers;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::CogPathwayCogMembers

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<COG_PATHWAY_COG_MEMBERS>

=cut

__PACKAGE__->table("COG_PATHWAY_COG_MEMBERS");

=head1 ACCESSORS

=head2 cog_pathway_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 cog_members

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "cog_pathway_oid",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "cog_members",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 20 },
);

=head1 RELATIONS

=head2 cog_member

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::Cog>

=cut

__PACKAGE__->belongs_to(
  "cog_member",
  "DBIC::IMG_Sat::Result::Cog",
  { cog_id => "cog_members" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 cog_pathway_oid

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::CogPathway>

=cut

__PACKAGE__->belongs_to(
  "cog_pathway_oid",
  "DBIC::IMG_Sat::Result::CogPathway",
  { cog_pathway_oid => "cog_pathway_oid" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kaOZx5Dffv2I7NxAJbnWEA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

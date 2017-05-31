use utf8;
package DBIC::IMG_Sat::Result::CogPathway;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::CogPathway

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<COG_PATHWAY>

=cut

__PACKAGE__->table("COG_PATHWAY");

=head1 ACCESSORS

=head2 cog_pathway_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 function

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 10

=head2 cog_pathway_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "cog_pathway_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "function",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 10 },
  "cog_pathway_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</cog_pathway_oid>

=back

=cut

__PACKAGE__->set_primary_key("cog_pathway_oid");

=head1 RELATIONS

=head2 cog_pathway_cog_members

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::CogPathwayCogMembers>

=cut

__PACKAGE__->has_many(
  "cog_pathway_cog_members",
  "DBIC::IMG_Sat::Result::CogPathwayCogMembers",
  { "foreign.cog_pathway_oid" => "self.cog_pathway_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 function

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::CogFunction>

=cut

__PACKAGE__->belongs_to(
  "function",
  "DBIC::IMG_Sat::Result::CogFunction",
  { function_code => "function" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Nrd+SO3jG+/zzHaLVkPB7A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

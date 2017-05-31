use utf8;
package DBIC::IMG_Sat::Result::KogPathway;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::KogPathway

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<KOG_PATHWAY>

=cut

__PACKAGE__->table("KOG_PATHWAY");

=head1 ACCESSORS

=head2 kog_pathway_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 function

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 10

=head2 kog_pathway_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "kog_pathway_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "function",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 10 },
  "kog_pathway_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</kog_pathway_oid>

=back

=cut

__PACKAGE__->set_primary_key("kog_pathway_oid");

=head1 RELATIONS

=head2 function

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::KogFunction>

=cut

__PACKAGE__->belongs_to(
  "function",
  "DBIC::IMG_Sat::Result::KogFunction",
  { function_code => "function" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 kog_pathway_kog_members

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KogPathwayKogMembers>

=cut

__PACKAGE__->has_many(
  "kog_pathway_kog_members",
  "DBIC::IMG_Sat::Result::KogPathwayKogMembers",
  { "foreign.kog_pathway_oid" => "self.kog_pathway_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jUPTJqowviO9l71eTTYP+Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DbSchema::IMG_Core::Result::GoldAnalysisProjectLookup2;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::GoldAnalysisProjectLookup2

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<GOLD_ANALYSIS_PROJECT_LOOKUP2>

=cut

__PACKAGE__->table("GOLD_ANALYSIS_PROJECT_LOOKUP2");

=head1 ACCESSORS

=head2 gold_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 its_spid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 project_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 sample_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 sp_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 pmo_project_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "gold_id",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "its_spid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "sample_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "sp_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "pmo_project_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:89o9k2IpRB6dLepsPIefxw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

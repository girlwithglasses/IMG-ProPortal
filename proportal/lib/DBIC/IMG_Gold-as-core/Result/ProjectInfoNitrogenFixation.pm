use utf8;
package DbSchema::IMG_Core::Result::ProjectInfoNitrogenFixation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ProjectInfoNitrogenFixation

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<PROJECT_INFO_NITROGEN_FIXATION>

=cut

__PACKAGE__->table("PROJECT_INFO_NITROGEN_FIXATION");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 nitrogen_fixation

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 authenticated_fixer

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 nitrogen_fixation_on_hosts

  data_type: 'varchar2'
  is_nullable: 1
  size: 3000

=head2 no_nitrogen_fixation_on_hosts

  data_type: 'varchar2'
  is_nullable: 1
  size: 3000

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 3000

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type      => "integer",
    is_foreign_key => 1,
    is_nullable    => 1,
    original       => { data_type => "number", size => [38, 0] },
  },
  "nitrogen_fixation",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "authenticated_fixer",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "nitrogen_fixation_on_hosts",
  { data_type => "varchar2", is_nullable => 1, size => 3000 },
  "no_nitrogen_fixation_on_hosts",
  { data_type => "varchar2", is_nullable => 1, size => 3000 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 3000 },
);

=head1 RELATIONS

=head2 project_oid

Type: belongs_to

Related object: L<DbSchema::IMG_Core::Result::ProjectInfo>

=cut

__PACKAGE__->belongs_to(
  "project_oid",
  "DbSchema::IMG_Core::Result::ProjectInfo",
  { project_oid => "project_oid" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cQiNkTxD+CavKOLp0zMhaQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

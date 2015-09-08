use utf8;
package DbSchema::IMG_Core::Result::ProjectInfoGenbankComment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ProjectInfoGenbankComment

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<PROJECT_INFO_GENBANK_COMMENTS>

=cut

__PACKAGE__->table("PROJECT_INFO_GENBANK_COMMENTS");

=head1 ACCESSORS

=head2 project_relevance

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 comment_template

  data_type: 'clob'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "project_relevance",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "comment_template",
  { data_type => "clob", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</project_relevance>

=back

=cut

__PACKAGE__->set_primary_key("project_relevance");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Rgib9jb8eR67/Zwf+UydVg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

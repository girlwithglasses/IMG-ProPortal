use utf8;
package DbSchema::IMG_Core::Result::GenbankCommentTemplate;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::GenbankCommentTemplate

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<GENBANK_COMMENT_TEMPLATES>

=cut

__PACKAGE__->table("GENBANK_COMMENT_TEMPLATES");

=head1 ACCESSORS

=head2 project_category

  data_type: 'varchar2'
  is_nullable: 0
  size: 50

=head2 comment_template

  data_type: 'clob'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "project_category",
  { data_type => "varchar2", is_nullable => 0, size => 50 },
  "comment_template",
  { data_type => "clob", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</project_category>

=back

=cut

__PACKAGE__->set_primary_key("project_category");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:uaYZOLb/7v8AxQrUnbAilQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

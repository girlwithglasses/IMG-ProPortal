use utf8;
package DbSchema::IMG_Core::Result::ProjectInfoGenbankAuthor;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ProjectInfoGenbankAuthor

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<PROJECT_INFO_GENBANK_AUTHORS>

=cut

__PACKAGE__->table("PROJECT_INFO_GENBANK_AUTHORS");

=head1 ACCESSORS

=head2 auto_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 project_relevance

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 jgi_authors

  data_type: 'clob'
  is_nullable: 1

=head2 comments

  data_type: 'clob'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "auto_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "project_relevance",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "jgi_authors",
  { data_type => "clob", is_nullable => 1 },
  "comments",
  { data_type => "clob", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</auto_id>

=back

=cut

__PACKAGE__->set_primary_key("auto_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gc3mBVsHeT8fs8srUXQzVQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

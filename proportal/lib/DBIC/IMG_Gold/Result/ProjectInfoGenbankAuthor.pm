use utf8;
package DBIC::IMG_Gold::Result::ProjectInfoGenbankAuthor;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::ProjectInfoGenbankAuthor

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

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


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:405zU9RlBMxReRC3eBQMuQ
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/ProjectInfoGenbankAuthor.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::ProjectInfoGenbankAuthor;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::ProjectInfoGenbankAuthor

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JpMus+bmCy6mozIUGbh4VA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/ProjectInfoGenbankAuthor.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

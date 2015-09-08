use utf8;
package DbSchema::IMG_Core::Result::PublicationJournalcv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::PublicationJournalcv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<PUBLICATION_JOURNALCV>

=cut

__PACKAGE__->table("PUBLICATION_JOURNALCV");

=head1 ACCESSORS

=head2 cv_term

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "cv_term",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8sYV+q4SmnW2TSmUIc/6gg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

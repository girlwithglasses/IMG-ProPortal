use utf8;
package DbSchema::IMG_Core::Result::SubmissionImgContact;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::SubmissionImgContact

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<SUBMISSION_IMG_CONTACTS>

=cut

__PACKAGE__->table("SUBMISSION_IMG_CONTACTS");

=head1 ACCESSORS

=head2 submission_id

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 img_contacts

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "submission_id",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "img_contacts",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RD9ePKPEZ8fvGX7mRNc17g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

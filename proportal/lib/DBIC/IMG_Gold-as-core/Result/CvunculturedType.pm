use utf8;
package DbSchema::IMG_Core::Result::CvunculturedType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::CvunculturedType

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<CVUNCULTURED_TYPE>

=cut

__PACKAGE__->table("CVUNCULTURED_TYPE");

=head1 ACCESSORS

=head2 cv_term

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=cut

__PACKAGE__->add_columns(
  "cv_term",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/2k4SEn3sJ4SF/rZ9e2/0g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

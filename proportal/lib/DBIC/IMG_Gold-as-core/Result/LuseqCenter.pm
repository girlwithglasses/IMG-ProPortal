use utf8;
package DbSchema::IMG_Core::Result::LuseqCenter;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::LuseqCenter

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<LUSEQ_CENTER>

=cut

__PACKAGE__->table("LUSEQ_CENTER");

=head1 ACCESSORS

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 url

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 seq_center_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=cut

__PACKAGE__->add_columns(
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "url",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "seq_center_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:p8jHUCcKPtUhVeZOjEdmLQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

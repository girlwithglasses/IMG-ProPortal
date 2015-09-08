use utf8;
package DbSchema::IMG_Core::Result::EnvSampleMiscMetaData;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::EnvSampleMiscMetaData

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ENV_SAMPLE_MISC_META_DATA>

=cut

__PACKAGE__->table("ENV_SAMPLE_MISC_META_DATA");

=head1 ACCESSORS

=head2 sample_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 meta_tag

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 meta_value

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=cut

__PACKAGE__->add_columns(
  "sample_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "meta_tag",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "meta_value",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yCycd7QCKwSB4ci/htggmg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

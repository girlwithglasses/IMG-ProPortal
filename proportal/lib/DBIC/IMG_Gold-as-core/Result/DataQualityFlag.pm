use utf8;
package DbSchema::IMG_Core::Result::DataQualityFlag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::DataQualityFlag

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<DATA_QUALITY_FLAGS>

=cut

__PACKAGE__->table("DATA_QUALITY_FLAGS");

=head1 ACCESSORS

=head2 data_quality_id

  data_type: 'numeric'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number"}
  sequence: 'data_quality_pk_seq'
  size: 126

=head2 project_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "data_quality_id",
  {
    data_type => "numeric",
    is_auto_increment => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    sequence => "data_quality_pk_seq",
    size => 126,
  },
  "project_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "flag",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</data_quality_id>

=back

=cut

__PACKAGE__->set_primary_key("data_quality_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NQWNfoUP/d9s7JaAnoyEIg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

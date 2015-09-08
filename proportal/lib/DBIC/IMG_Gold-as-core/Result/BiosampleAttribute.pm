use utf8;
package DbSchema::IMG_Core::Result::BiosampleAttribute;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::BiosampleAttribute

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<BIOSAMPLE_ATTRIBUTE>

=cut

__PACKAGE__->table("BIOSAMPLE_ATTRIBUTE");

=head1 ACCESSORS

=head2 biosample_attribute_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}
  sequence: 'biosample_at_pk_seq'

=head2 biosample_accession

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 attribute_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 200

=head2 attribute_value

  data_type: 'varchar2'
  is_nullable: 0
  size: 2000

=cut

__PACKAGE__->add_columns(
  "biosample_attribute_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    original          => { data_type => "number", size => [38, 0] },
    sequence          => "biosample_at_pk_seq",
  },
  "biosample_accession",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "attribute_name",
  { data_type => "varchar2", is_nullable => 0, size => 200 },
  "attribute_value",
  { data_type => "varchar2", is_nullable => 0, size => 2000 },
);

=head1 PRIMARY KEY

=over 4

=item * L</biosample_attribute_id>

=back

=cut

__PACKAGE__->set_primary_key("biosample_attribute_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eiGgtAWvop/oWPTaCCfX5w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

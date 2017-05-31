use utf8;
package DBIC::IMG_Gold::Result::PublicWorkspace;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::PublicWorkspace

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<PUBLIC_WORKSPACE>

=cut

__PACKAGE__->table("PUBLIC_WORKSPACE");

=head1 ACCESSORS

=head2 contact_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 data_set_type

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 data_set_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 publish_date

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=cut

__PACKAGE__->add_columns(
  "contact_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "data_set_type",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "data_set_name",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "publish_date",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:69qPpnNtsnrb4HItXxsvuw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

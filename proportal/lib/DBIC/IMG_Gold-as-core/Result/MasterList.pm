use utf8;
package DbSchema::IMG_Core::Result::MasterList;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::MasterList

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<MASTER_LIST>

=cut

__PACKAGE__->table("MASTER_LIST");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 release_date

  data_type: 'datetime'
  default_value: null
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "release_date",
  {
    data_type     => "datetime",
    default_value => \"null",
    is_nullable   => 1,
    original      => { data_type => "date" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:s7Vm+LYC54KE9PGuslyr9w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DBIC::IMG_Sat::Result::KogFunction;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::KogFunction

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<KOG_FUNCTION>

=cut

__PACKAGE__->table("KOG_FUNCTION");

=head1 ACCESSORS

=head2 function_code

  data_type: 'varchar2'
  is_nullable: 0
  size: 10

=head2 definition

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 function_group

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "function_code",
  { data_type => "varchar2", is_nullable => 0, size => 10 },
  "definition",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "function_group",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</function_code>

=back

=cut

__PACKAGE__->set_primary_key("function_code");

=head1 RELATIONS

=head2 kog_pathways

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KogPathway>

=cut

__PACKAGE__->has_many(
  "kog_pathways",
  "DBIC::IMG_Sat::Result::KogPathway",
  { "foreign.function" => "self.function_code" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vs07me1UGVd+ueVhkzIK3Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

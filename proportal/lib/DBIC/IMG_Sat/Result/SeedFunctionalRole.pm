use utf8;
package DBIC::IMG_Sat::Result::SeedFunctionalRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::SeedFunctionalRole

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<SEED_FUNCTIONAL_ROLE>

=cut

__PACKAGE__->table("SEED_FUNCTIONAL_ROLE");

=head1 ACCESSORS

=head2 role_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 500

=head2 subsystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 level_1

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 level_2

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=cut

__PACKAGE__->add_columns(
  "role_name",
  { data_type => "varchar2", is_nullable => 0, size => 500 },
  "subsystem",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "level_1",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "level_2",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
);

=head1 PRIMARY KEY

=over 4

=item * L</role_name>

=back

=cut

__PACKAGE__->set_primary_key("role_name");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Pa8b2coXwCVf6Vcra6ItAA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DbSchema::IMG_Core::Result::CountryLoad;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::CountryLoad

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<COUNTRY_LOAD>

=cut

__PACKAGE__->table("COUNTRY_LOAD");

=head1 ACCESSORS

=head2 country

  data_type: 'varchar2'
  is_nullable: 1
  size: 150

=cut

__PACKAGE__->add_columns(
  "country",
  { data_type => "varchar2", is_nullable => 1, size => 150 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:O1PL5P1I7nK2gDnTRI9ofw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

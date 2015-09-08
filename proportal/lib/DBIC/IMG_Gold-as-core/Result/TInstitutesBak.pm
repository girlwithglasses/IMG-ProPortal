use utf8;
package DbSchema::IMG_Core::Result::TInstitutesBak;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::TInstitutesBak

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<T_INSTITUTES_BAK>

=cut

__PACKAGE__->table("T_INSTITUTES_BAK");

=head1 ACCESSORS

=head2 institute_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 400

=head2 url

  data_type: 'varchar2'
  is_nullable: 1
  size: 240

=head2 country

  data_type: 'varchar2'
  is_nullable: 1
  size: 40

=cut

__PACKAGE__->add_columns(
  "institute_name",
  { data_type => "varchar2", is_nullable => 0, size => 400 },
  "url",
  { data_type => "varchar2", is_nullable => 1, size => 240 },
  "country",
  { data_type => "varchar2", is_nullable => 1, size => 40 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BXEV7GouZbgHJqToN546UQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

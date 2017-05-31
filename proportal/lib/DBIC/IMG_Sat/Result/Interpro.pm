use utf8;
package DBIC::IMG_Sat::Result::Interpro;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::Interpro

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<INTERPRO>

=cut

__PACKAGE__->table("INTERPRO");

=head1 ACCESSORS

=head2 ext_accession

  data_type: 'varchar2'
  is_nullable: 0
  size: 100

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "ext_accession",
  { data_type => "varchar2", is_nullable => 0, size => 100 },
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</ext_accession>

=back

=cut

__PACKAGE__->set_primary_key("ext_accession");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:T5EHTtjyAG7ybMSJp8k98A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

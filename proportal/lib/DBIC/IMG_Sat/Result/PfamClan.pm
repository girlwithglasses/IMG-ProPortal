use utf8;
package DBIC::IMG_Sat::Result::PfamClan;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::PfamClan

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<PFAM_CLAN>

=cut

__PACKAGE__->table("PFAM_CLAN");

=head1 ACCESSORS

=head2 ext_accession

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 name

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "ext_accession",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "name",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</ext_accession>

=back

=cut

__PACKAGE__->set_primary_key("ext_accession");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0avJxUzVJb2ZjKSXGdSFZg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

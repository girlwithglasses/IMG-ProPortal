use utf8;
package DBIC::IMG_Sat::Result::PfamFamilyV28;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::PfamFamilyV28

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<PFAM_FAMILY_V28>

=cut

__PACKAGE__->table("PFAM_FAMILY_V28");

=head1 ACCESSORS

=head2 ext_accession

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 seq_length

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 db_source

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 255

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "ext_accession",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "seq_length",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "db_source",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 255 },
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

=head1 RELATIONS

=head2 db_source

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::DbSource>

=cut

__PACKAGE__->belongs_to(
  "db_source",
  "DBIC::IMG_Sat::Result::DbSource",
  { db_code => "db_source" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 pfam_family_ext_links

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::PfamFamilyExtLinks>

=cut

__PACKAGE__->has_many(
  "pfam_family_ext_links",
  "DBIC::IMG_Sat::Result::PfamFamilyExtLinks",
  { "foreign.ext_accession" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 pfam_family_families

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::PfamFamilyFamilies>

=cut

__PACKAGE__->has_many(
  "pfam_family_families",
  "DBIC::IMG_Sat::Result::PfamFamilyFamilies",
  { "foreign.ext_accession" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:z0KTcf9C6GjANN3UKcF6qg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

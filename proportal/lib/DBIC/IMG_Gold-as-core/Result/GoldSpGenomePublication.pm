use utf8;
package DbSchema::IMG_Core::Result::GoldSpGenomePublication;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::GoldSpGenomePublication

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<GOLD_SP_GENOME_PUBLICATIONS>

=cut

__PACKAGE__->table("GOLD_SP_GENOME_PUBLICATIONS");

=head1 ACCESSORS

=head2 gold_id

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 0
  size: 50

=head2 pubmed_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 journal_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 volume

  data_type: 'varchar2'
  is_nullable: 1
  size: 40

=head2 issue

  data_type: 'varchar2'
  is_nullable: 1
  size: 40

=head2 page

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 title

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 publication_date

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 doi

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "gold_id",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 0, size => 50 },
  "pubmed_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "journal_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "volume",
  { data_type => "varchar2", is_nullable => 1, size => 40 },
  "issue",
  { data_type => "varchar2", is_nullable => 1, size => 40 },
  "page",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "title",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "publication_date",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "doi",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 RELATIONS

=head2 gold

Type: belongs_to

Related object: L<DbSchema::IMG_Core::Result::GoldSequencingProject>

=cut

__PACKAGE__->belongs_to(
  "gold",
  "DbSchema::IMG_Core::Result::GoldSequencingProject",
  { gold_id => "gold_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:m4Yt20hQk/j6wbehm5iODQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

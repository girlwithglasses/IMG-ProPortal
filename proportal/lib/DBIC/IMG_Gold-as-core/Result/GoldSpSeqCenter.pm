use utf8;
package DbSchema::IMG_Core::Result::GoldSpSeqCenter;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::GoldSpSeqCenter

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<GOLD_SP_SEQ_CENTER>

=cut

__PACKAGE__->table("GOLD_SP_SEQ_CENTER");

=head1 ACCESSORS

=head2 gold_id

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 0
  size: 50

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 country

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 url

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=cut

__PACKAGE__->add_columns(
  "gold_id",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 0, size => 50 },
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "country",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "url",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eBTIzH006Jr+HnLnKmIRyQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

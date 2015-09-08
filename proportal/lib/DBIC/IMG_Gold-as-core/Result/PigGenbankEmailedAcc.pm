use utf8;
package DbSchema::IMG_Core::Result::PigGenbankEmailedAcc;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::PigGenbankEmailedAcc

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<PIG_GENBANK_EMAILED_ACCS>

=cut

__PACKAGE__->table("PIG_GENBANK_EMAILED_ACCS");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 bioproject_id

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 ncbi_accession_number

  data_type: 'varchar2'
  is_nullable: 0
  size: 50

=head2 display_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 100

=head2 genbank_email_time

  data_type: 'timestamp'
  is_nullable: 0

=head2 genbank_email_subject

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 insert_user_sso

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 insert_user

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 insert_time

  data_type: 'timestamp'
  is_nullable: 1

=head2 update_user_sso

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 update_user

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 update_time

  data_type: 'timestamp'
  is_nullable: 1

=head2 created_at

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 updated_at

  data_type: 'datetime'
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
  "bioproject_id",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "ncbi_accession_number",
  { data_type => "varchar2", is_nullable => 0, size => 50 },
  "display_name",
  { data_type => "varchar2", is_nullable => 0, size => 100 },
  "genbank_email_time",
  { data_type => "timestamp", is_nullable => 0 },
  "genbank_email_subject",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "insert_user_sso",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "insert_user",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "insert_time",
  { data_type => "timestamp", is_nullable => 1 },
  "update_user_sso",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "update_user",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "update_time",
  { data_type => "timestamp", is_nullable => 1 },
  "created_at",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "updated_at",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pE6NKo3jo5PVNknVebM7iQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

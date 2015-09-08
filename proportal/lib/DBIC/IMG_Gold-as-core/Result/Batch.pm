use utf8;
package DbSchema::IMG_Core::Result::Batch;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::Batch

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<BATCH>

=cut

__PACKAGE__->table("BATCH");

=head1 ACCESSORS

=head2 batch_id

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 database

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 no_submissions

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 start_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 annot_ready_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 finish_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "batch_id",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "database",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "no_submissions",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "start_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "annot_ready_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "finish_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/n2UWLCuH8Hz7VUs68rb4w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

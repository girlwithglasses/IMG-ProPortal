use utf8;
package DBIC::IMG_Gold::Result::PlanTable20131114;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::PlanTable20131114

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<PLAN_TABLE_20131114>

=cut

__PACKAGE__->table("PLAN_TABLE_20131114");

=head1 ACCESSORS

=head2 statement_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 timestamp

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 remarks

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 operation

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 options

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 object_node

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 object_owner

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 object_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 object_instance

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 object_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 optimizer

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 search_columns

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 parent_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 position

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 cost

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 cardinality

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 bytes

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 other_tag

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 partition_start

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 partition_stop

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 partition_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 other

  data_type: 'long'
  is_nullable: 1

=head2 distribution

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=cut

__PACKAGE__->add_columns(
  "statement_id",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "timestamp",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "remarks",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "operation",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "options",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "object_node",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "object_owner",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "object_name",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "object_instance",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "object_type",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "optimizer",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "search_columns",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "parent_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "position",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "cost",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "cardinality",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "bytes",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "other_tag",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "partition_start",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "partition_stop",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "partition_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "other",
  { data_type => "long", is_nullable => 1 },
  "distribution",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:m7GDRIrKCuF/sgLbV4UW3A
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/PlanTable20131114.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::PlanTable20131114;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::PlanTable20131114

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<PLAN_TABLE_20131114>

=cut

__PACKAGE__->table("PLAN_TABLE_20131114");

=head1 ACCESSORS

=head2 statement_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 timestamp

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 remarks

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 operation

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 options

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 object_node

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 object_owner

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 object_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 object_instance

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 object_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 optimizer

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 search_columns

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 parent_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 position

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 cost

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 cardinality

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 bytes

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 other_tag

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 partition_start

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 partition_stop

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 partition_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 other

  data_type: 'long'
  is_nullable: 1

=head2 distribution

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=cut

__PACKAGE__->add_columns(
  "statement_id",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "timestamp",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "remarks",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "operation",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "options",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "object_node",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "object_owner",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "object_name",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "object_instance",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "object_type",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "optimizer",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "search_columns",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "parent_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "position",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "cost",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "cardinality",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "bytes",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "other_tag",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "partition_start",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "partition_stop",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "partition_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "other",
  { data_type => "long", is_nullable => 1 },
  "distribution",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:E/lveGKEnv9Kz+pgYQcKYg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/PlanTable20131114.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

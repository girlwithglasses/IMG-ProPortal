use utf8;
package DBIC::IMG_Gold::Result::MetagenomicClassNode;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::MetagenomicClassNode

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<METAGENOMIC_CLASS_NODES>

=cut

__PACKAGE__->table("METAGENOMIC_CLASS_NODES");

=head1 ACCESSORS

=head2 mc_node_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 node

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 ecosystem_category

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 ecosystem_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 ecosystem_subtype

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 specific_ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 node_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "mc_node_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "node",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "ecosystem_category",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "ecosystem_type",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "ecosystem_subtype",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "specific_ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "node_type",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</mc_node_id>

=back

=cut

__PACKAGE__->set_primary_key("mc_node_id");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Z9rmsymreowXv8+7NhNKDg
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/MetagenomicClassNode.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::MetagenomicClassNode;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::MetagenomicClassNode

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<METAGENOMIC_CLASS_NODES>

=cut

__PACKAGE__->table("METAGENOMIC_CLASS_NODES");

=head1 ACCESSORS

=head2 mc_node_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 node

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 ecosystem_category

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 ecosystem_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 ecosystem_subtype

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 specific_ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 node_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "mc_node_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "node",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "ecosystem_category",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "ecosystem_type",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "ecosystem_subtype",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "specific_ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "node_type",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</mc_node_id>

=back

=cut

__PACKAGE__->set_primary_key("mc_node_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Jde1US1xkQL3oEY+OoFkaQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/MetagenomicClassNode.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

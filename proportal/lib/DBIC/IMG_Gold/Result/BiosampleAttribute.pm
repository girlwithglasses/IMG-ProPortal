use utf8;
package DBIC::IMG_Gold::Result::BiosampleAttribute;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::BiosampleAttribute

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BIOSAMPLE_ATTRIBUTE>

=cut

__PACKAGE__->table("BIOSAMPLE_ATTRIBUTE");

=head1 ACCESSORS

=head2 biosample_attribute_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}
  sequence: 'biosample_at_pk_seq'

=head2 biosample_accession

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 attribute_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 200

=head2 attribute_value

  data_type: 'varchar2'
  is_nullable: 0
  size: 2000

=cut

__PACKAGE__->add_columns(
  "biosample_attribute_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    original          => { data_type => "number", size => [38, 0] },
    sequence          => "biosample_at_pk_seq",
  },
  "biosample_accession",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "attribute_name",
  { data_type => "varchar2", is_nullable => 0, size => 200 },
  "attribute_value",
  { data_type => "varchar2", is_nullable => 0, size => 2000 },
);

=head1 PRIMARY KEY

=over 4

=item * L</biosample_attribute_id>

=back

=cut

__PACKAGE__->set_primary_key("biosample_attribute_id");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3pOfoj11IeDzhMjnAZ4BWw
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/BiosampleAttribute.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::BiosampleAttribute;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::BiosampleAttribute

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BIOSAMPLE_ATTRIBUTE>

=cut

__PACKAGE__->table("BIOSAMPLE_ATTRIBUTE");

=head1 ACCESSORS

=head2 biosample_attribute_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}
  sequence: 'biosample_at_pk_seq'

=head2 biosample_accession

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 attribute_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 200

=head2 attribute_value

  data_type: 'varchar2'
  is_nullable: 0
  size: 2000

=cut

__PACKAGE__->add_columns(
  "biosample_attribute_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    original          => { data_type => "number", size => [38, 0] },
    sequence          => "biosample_at_pk_seq",
  },
  "biosample_accession",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "attribute_name",
  { data_type => "varchar2", is_nullable => 0, size => 200 },
  "attribute_value",
  { data_type => "varchar2", is_nullable => 0, size => 2000 },
);

=head1 PRIMARY KEY

=over 4

=item * L</biosample_attribute_id>

=back

=cut

__PACKAGE__->set_primary_key("biosample_attribute_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ud5yZB3XpJeKQSyZisXOmQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/BiosampleAttribute.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package DBIC::IMG_Core::Result::GoldSpCollaborator;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GoldSpCollaborator

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GOLD_SP_COLLABORATOR>

=cut

__PACKAGE__->table("GOLD_SP_COLLABORATOR");

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

Related object: L<DBIC::IMG_Core::Result::GoldSequencingProject>

=cut

__PACKAGE__->belongs_to(
  "gold",
  "DBIC::IMG_Core::Result::GoldSequencingProject",
  { gold_id => "gold_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-07-13 15:21:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UNh8GfDZkfv2eLT//SbQoQ
# These lines were loaded from '/global/u1/a/aireland/gn-img-proportal-mojo/script/../lib/DBIC/IMG_Core/Result/GoldSpCollaborator.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Core::Result::GoldSpCollaborator;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GoldSpCollaborator

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GOLD_SP_COLLABORATOR>

=cut

__PACKAGE__->table("GOLD_SP_COLLABORATOR");

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

Related object: L<DBIC::IMG_Core::Result::GoldSequencingProject>

=cut

__PACKAGE__->belongs_to(
  "gold",
  "DBIC::IMG_Core::Result::GoldSequencingProject",
  { gold_id => "gold_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Wz3q6YsUZRddPteIcIDVdg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/u1/a/aireland/gn-img-proportal-mojo/script/../lib/DBIC/IMG_Core/Result/GoldSpCollaborator.pm' 


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

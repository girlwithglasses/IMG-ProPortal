use utf8;
package DbSchema::IMG_Core::Result::OraAspnetPersonaliznalluser;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::OraAspnetPersonaliznalluser

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<ORA_ASPNET_PERSONALIZNALLUSERS>

=cut

__PACKAGE__->table("ORA_ASPNET_PERSONALIZNALLUSERS");

=head1 ACCESSORS

=head2 pathid

  data_type: 'raw'
  is_foreign_key: 1
  is_nullable: 1
  size: 16

=head2 pagesettings

  data_type: 'blob'
  is_nullable: 0

=head2 lastupdateddate

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "pathid",
  { data_type => "raw", is_foreign_key => 1, is_nullable => 1, size => 16 },
  "pagesettings",
  { data_type => "blob", is_nullable => 0 },
  "lastupdateddate",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
);

=head1 RELATIONS

=head2 pathid

Type: belongs_to

Related object: L<DbSchema::IMG_Core::Result::OraAspnetPath>

=cut

__PACKAGE__->belongs_to(
  "pathid",
  "DbSchema::IMG_Core::Result::OraAspnetPath",
  { pathid => "pathid" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OyWdhJKmROGf6Ih8NK0OjA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

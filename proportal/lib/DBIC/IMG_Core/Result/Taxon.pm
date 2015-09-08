use utf8;
package DBIC::IMG_Core::Result::Taxon;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::Taxon

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TAXON>

=cut

__PACKAGE__->table("TAXON");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 taxon_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 genus

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 species

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 strain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 taxon_display_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 ncbi_taxon_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 domain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 phylum

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ir_class

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ir_order

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 family

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 jgi_species_code

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 env_sample

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 seq_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 seq_center

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 is_public

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 0
  size: 10

=head2 is_replaced

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 img_ec_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 funding_agency

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 jgi_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 img_version

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 ncbi_species_code

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 ncbi_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 release_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 ornl_species_code

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 is_big_euk

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 host_ncbi_taxon_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 is_std_reference

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 modified_by

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 project

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genome_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 gram_stain

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 is_proxygene_set

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 obsolete_flag

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 0
  size: 10

=head2 is_pangenome

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 edit_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 img_product_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 refseq_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 gbk_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 is_low_quality

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 phylodist_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 proposal_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 2000

=head2 sample_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 phylodist_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 in_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 ncbi_bioproject_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 combined_sample_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 high_quality_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 taxonomy_lock

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 locked_by

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 lock_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 distmatrix_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 analysis_project_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 legacy_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 ani_species

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 study_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 sequencing_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "taxon_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "genus",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "species",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "strain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "taxon_display_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "ncbi_taxon_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "domain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "phylum",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ir_class",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ir_order",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "family",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "jgi_species_code",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "env_sample",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "seq_status",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "seq_center",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "is_public",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 0,
    size => 10,
  },
  "is_replaced",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "img_ec_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "funding_agency",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "jgi_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "img_version",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "ncbi_species_code",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "ncbi_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "release_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "ornl_species_code",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "is_big_euk",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "host_ncbi_taxon_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "is_std_reference",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "modified_by",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "project",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genome_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "gram_stain",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "is_proxygene_set",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "obsolete_flag",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 0,
    size => 10,
  },
  "is_pangenome",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "edit_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "submission_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "img_product_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "refseq_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "gbk_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "is_low_quality",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "phylodist_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "proposal_name",
  { data_type => "varchar2", is_nullable => 1, size => 2000 },
  "sample_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "phylodist_method",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "in_file",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "ncbi_bioproject_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "combined_sample_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "high_quality_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "taxonomy_lock",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "locked_by",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "lock_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "distmatrix_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "analysis_project_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "legacy_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "ani_species",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "study_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "sequencing_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
);

=head1 PRIMARY KEY

=over 4

=item * L</taxon_oid>

=back

=cut

__PACKAGE__->set_primary_key("taxon_oid");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-07-13 15:21:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KlQYNh26NyLtRuD7J0apcw
# These lines were loaded from '/global/u1/a/aireland/gn-img-proportal-mojo/script/../lib/DBIC/IMG_Core/Result/Taxon.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Core::Result::Taxon;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::Taxon

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TAXON>

=cut

__PACKAGE__->table("TAXON");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 taxon_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 genus

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 species

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 strain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 taxon_display_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 ncbi_taxon_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 domain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 phylum

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ir_class

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ir_order

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 family

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 jgi_species_code

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 env_sample

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 seq_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 seq_center

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 is_public

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 0
  size: 10

=head2 is_replaced

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 img_ec_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 funding_agency

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 jgi_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 img_version

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 ncbi_species_code

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 ncbi_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 release_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 ornl_species_code

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 is_big_euk

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 host_ncbi_taxon_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 is_std_reference

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 modified_by

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 project

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genome_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 gram_stain

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 is_proxygene_set

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 obsolete_flag

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 0
  size: 10

=head2 is_pangenome

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 edit_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 img_product_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 refseq_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 gbk_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 is_low_quality

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 phylodist_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 proposal_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 2000

=head2 sample_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 phylodist_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 in_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 ncbi_bioproject_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 combined_sample_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 high_quality_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 taxonomy_lock

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 locked_by

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 lock_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 distmatrix_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 analysis_project_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 legacy_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 ani_species

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 study_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 sequencing_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "taxon_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "genus",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "species",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "strain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "taxon_display_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "ncbi_taxon_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "domain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "phylum",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ir_class",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ir_order",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "family",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "jgi_species_code",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "env_sample",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "seq_status",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "seq_center",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "is_public",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 0,
    size => 10,
  },
  "is_replaced",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "img_ec_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "funding_agency",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "jgi_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "img_version",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "ncbi_species_code",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "ncbi_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "release_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "ornl_species_code",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "is_big_euk",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "host_ncbi_taxon_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "is_std_reference",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "modified_by",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "project",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genome_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "gram_stain",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "is_proxygene_set",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "obsolete_flag",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 0,
    size => 10,
  },
  "is_pangenome",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "edit_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "submission_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "img_product_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "refseq_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "gbk_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "is_low_quality",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "phylodist_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "proposal_name",
  { data_type => "varchar2", is_nullable => 1, size => 2000 },
  "sample_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "phylodist_method",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "in_file",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "ncbi_bioproject_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "combined_sample_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "high_quality_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "taxonomy_lock",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "locked_by",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "lock_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "distmatrix_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "analysis_project_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "legacy_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "ani_species",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "study_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "sequencing_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
);

=head1 PRIMARY KEY

=over 4

=item * L</taxon_oid>

=back

=cut

__PACKAGE__->set_primary_key("taxon_oid");

=head1 RELATIONS

=head2 assemblies

Type: has_many

Related object: L<DBIC::IMG_Core::Result::Assembly>


__PACKAGE__->has_many(
  "assemblies",
  "DBIC::IMG_Core::Result::Assembly",
  { "foreign.taxon" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=cut

=head2 bin_scaffolds

Type: has_many

Related object: L<DBIC::IMG_Core::Result::BinScaffold>


__PACKAGE__->has_many(
  "bin_scaffolds",
  "DBIC::IMG_Core::Result::BinScaffold",
  { "foreign.taxon" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=cut

=head2 cassette_box_cassettes_bbhs

Type: has_many

Related object: L<DBIC::IMG_Core::Result::CassetteBoxCassettesBbh>

x
__PACKAGE__->has_many(
  "cassette_box_cassettes_bbhs",
  "DBIC::IMG_Core::Result::CassetteBoxCassettesBbh",
  { "foreign.taxon" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
=cut

=head2 cassette_box_cassettes_cogs

Type: has_many

Related object: L<DBIC::IMG_Core::Result::CassetteBoxCassettesCog>


__PACKAGE__->has_many(
  "cassette_box_cassettes_cogs",
  "DBIC::IMG_Core::Result::CassetteBoxCassettesCog",
  { "foreign.taxon" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
=cut


=head2 cassette_box_cassettes_pfams

Type: has_many

Related object: L<DBIC::IMG_Core::Result::CassetteBoxCassettesPfam>


__PACKAGE__->has_many(
  "cassette_box_cassettes_pfams",
  "DBIC::IMG_Core::Result::CassetteBoxCassettesPfam",
  { "foreign.taxon" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
=cut

=head2 gene_biocyc_rxns

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneBiocycRxn>


__PACKAGE__->has_many(
  "gene_biocyc_rxns",
  "DBIC::IMG_Core::Result::GeneBiocycRxn",
  { "foreign.taxon" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
=cut

=head2 gene_cassette_panfolds

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneCassettePanfold>


__PACKAGE__->has_many(
  "gene_cassette_panfolds",
  "DBIC::IMG_Core::Result::GeneCassettePanfold",
  { "foreign.taxon" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
=cut

=head2 gene_ko_enzymes

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneKoEnzyme>


__PACKAGE__->has_many(
  "gene_ko_enzymes",
  "DBIC::IMG_Core::Result::GeneKoEnzyme",
  { "foreign.taxon" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
=cut

=head2 gene_orthologs_query_taxons

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneOrtholog>


__PACKAGE__->has_many(
  "gene_orthologs_query_taxons",
  "DBIC::IMG_Core::Result::GeneOrtholog",
  { "foreign.query_taxon" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
=cut

=head2 gene_orthologs_taxons

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneOrtholog>


__PACKAGE__->has_many(
  "gene_orthologs_taxons",
  "DBIC::IMG_Core::Result::GeneOrtholog",
  { "foreign.taxon" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
=cut

=head2 gene_seed_names

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneSeedName>


__PACKAGE__->has_many(
  "gene_seed_names",
  "DBIC::IMG_Core::Result::GeneSeedName",
  { "foreign.taxon" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
=cut

=head2 gene_tc_families

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneTcFamily>


__PACKAGE__->has_many(
  "gene_tc_families",
  "DBIC::IMG_Core::Result::GeneTcFamily",
  { "foreign.taxon" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
=cut

=head2 taxon_node_lites

Type: has_many

Related object: L<DBIC::IMG_Core::Result::TaxonNodeLite>


__PACKAGE__->has_many(
  "taxon_node_lites",
  "DBIC::IMG_Core::Result::TaxonNodeLite",
  { "foreign.taxon" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
=cut

=head2 taxon_pangenome_composition_pangenome_compositions

Type: has_many

Related object: L<DBIC::IMG_Core::Result::TaxonPangenomeComposition>


__PACKAGE__->has_many(
  "taxon_pangenome_composition_pangenome_compositions",
  "DBIC::IMG_Core::Result::TaxonPangenomeComposition",
  { "foreign.pangenome_composition" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
=cut

=head2 taxon_pangenome_composition_taxon_oids

Type: has_many

Related object: L<DBIC::IMG_Core::Result::TaxonPangenomeComposition>


__PACKAGE__->has_many(
  "taxon_pangenome_composition_taxon_oids",
  "DBIC::IMG_Core::Result::TaxonPangenomeComposition",
  { "foreign.taxon_oid" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
=cut

=head2 taxon_related_taxons_related_taxons

Type: has_many

Related object: L<DBIC::IMG_Core::Result::TaxonRelatedTaxon>

__PACKAGE__->has_many(
  "taxon_related_taxons_related_taxons",
  "DBIC::IMG_Core::Result::TaxonRelatedTaxon",
  { "foreign.related_taxons" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
=cut

=head2 taxon_related_taxons_taxon_oids

Type: has_many

Related object: L<DBIC::IMG_Core::Result::TaxonRelatedTaxon>


__PACKAGE__->has_many(
  "taxon_related_taxons_taxon_oids",
  "DBIC::IMG_Core::Result::TaxonRelatedTaxon",
  { "foreign.taxon_oid" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
=cut

=head2 taxon_replacements

Type: has_many

Related object: L<DBIC::IMG_Core::Result::TaxonReplacement>

__PACKAGE__->has_many(
  "taxon_replacements",
  "DBIC::IMG_Core::Result::TaxonReplacement",
  { "foreign.taxon_oid" => "self.taxon_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=cut


__PACKAGE__->belongs_to(
	"goldseqproj",
	"DBIC::IMG_Core::Result::GoldSequencingProject",
	{ "foreign.gold_id" => "self.sequencing_gold_id" },
	{ cascade_copy => 0, cascade_delete => 0 },
);


__PACKAGE__->belongs_to(
	"goldanaproj",
	"DBIC::IMG_Core::Result::GoldAnalysisProject",
	{ "foreign.gold_analysis_project_id" => "self.analysis_project_id" },
	{ cascade_copy => 0, cascade_delete => 0 },
);

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/u1/a/aireland/gn-img-proportal-mojo/script/../lib/DBIC/IMG_Core/Result/Taxon.pm' 


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

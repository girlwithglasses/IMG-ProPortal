use utf8;
package DBIC::IMG_Gold::Result::GoldAnalysisProject;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::GoldAnalysisProject

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GOLD_ANALYSIS_PROJECT>

=cut

__PACKAGE__->table("GOLD_ANALYSIS_PROJECT");

=head1 ACCESSORS

=head2 gold_analysis_project_id

  data_type: 'numeric'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number"}
  sequence: 'gold_analysis_project_id_seq'
  size: 126

=head2 its_analysis_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 analysis_project_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 ncbi_tax_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 img_dataset_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 analysis_product_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 visibility

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 domain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_phylum

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_class

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_order

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_family

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_genus

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_species

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 gold_analysis_project_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 gold_proposal_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 ecosystem_category

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 ecosystem_subtype

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 specific_ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 reference_img_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 pi_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 pi_email

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 submitter_contact_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 ecosystem_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 specimen

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 reference_img_experiment_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 reference_gold_ap_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 gold_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 16

=head2 genome_size

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 gene_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 scaffold_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 its_analysis_project_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 contig_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 genbank_low_quality_annotation

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 genbank_low_quality_genome

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 completion_date

  data_type: 'timestamp'
  is_nullable: 1

=head2 binning_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 gene_calling_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 submission_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 img_analysis_complete

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 status

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 is_gene_primp

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 3

=head2 gene_primp_date

  data_type: 'timestamp'
  is_nullable: 1

=head2 is_decontamination

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 3

=head2 is_img_annotation

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 3

=head2 its_annotation_at_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 its_assembly_at_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 is_assembled

  data_type: 'varchar2'
  is_nullable: 1
  size: 16

=head2 genome_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 40

=head2 study_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 locus_tag

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 cultured

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 jgi_sequenced

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 reference_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 strain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 submission_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 submitter_email

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 review_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 40

=head2 caliban_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 assembly_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 genus

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 species

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 sequencing_depth

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 img_use

  data_type: 'varchar2'
  is_nullable: 1
  size: 40

=head2 gold_phylogeny

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "gold_analysis_project_id",
  {
    data_type => "numeric",
    is_auto_increment => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    sequence => "gold_analysis_project_id_seq",
    size => 126,
  },
  "its_analysis_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "analysis_project_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "ncbi_tax_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "img_dataset_id",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "analysis_product_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "visibility",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "domain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_phylum",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_class",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_order",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_family",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_genus",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_species",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "gold_analysis_project_type",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "gold_proposal_name",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem_category",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem_subtype",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "specific_ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "reference_img_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "pi_name",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "pi_email",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "submitter_contact_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "ecosystem_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "specimen",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "reference_img_experiment_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "reference_gold_ap_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "gold_id",
  { data_type => "varchar2", is_nullable => 0, size => 16 },
  "genome_size",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "gene_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "scaffold_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "its_analysis_project_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "contig_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "genbank_low_quality_annotation",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "genbank_low_quality_genome",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "completion_date",
  { data_type => "timestamp", is_nullable => 1 },
  "binning_method",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "gene_calling_method",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "submission_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "img_analysis_complete",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "status",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "is_gene_primp",
  { data_type => "varchar2", default_value => "No", is_nullable => 1, size => 3 },
  "gene_primp_date",
  { data_type => "timestamp", is_nullable => 1 },
  "is_decontamination",
  { data_type => "varchar2", default_value => "No", is_nullable => 1, size => 3 },
  "is_img_annotation",
  { data_type => "varchar2", default_value => "No", is_nullable => 1, size => 3 },
  "its_annotation_at_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "its_assembly_at_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "is_assembled",
  { data_type => "varchar2", is_nullable => 1, size => 16 },
  "genome_type",
  { data_type => "varchar2", is_nullable => 1, size => 40 },
  "study_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "locus_tag",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "cultured",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "jgi_sequenced",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "reference_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "strain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "submission_type",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "submitter_email",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "review_status",
  { data_type => "varchar2", is_nullable => 1, size => 40 },
  "caliban_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "assembly_method",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "genus",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "species",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "sequencing_depth",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "img_use",
  { data_type => "varchar2", is_nullable => 1, size => 40 },
  "gold_phylogeny",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</gold_id>

=back

=cut

__PACKAGE__->set_primary_key("gold_id");

=head1 RELATIONS

=head2 gold_analysis_project_lookup2s

Type: has_many

Related object: L<DBIC::IMG_Gold::Result::GoldAnalysisProjectLookup2>

=cut

__PACKAGE__->has_many(
  "gold_analysis_project_lookup2s",
  "DBIC::IMG_Gold::Result::GoldAnalysisProjectLookup2",
  { "foreign.gold_id" => "self.gold_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gold_analysis_project_users

Type: has_many

Related object: L<DBIC::IMG_Gold::Result::GoldAnalysisProjectUser>

=cut

__PACKAGE__->has_many(
  "gold_analysis_project_users",
  "DBIC::IMG_Gold::Result::GoldAnalysisProjectUser",
  { "foreign.gold_id" => "self.gold_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6+6EHXVA+/u19UItPgwxpQ
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/GoldAnalysisProject.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::GoldAnalysisProject;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::GoldAnalysisProject

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GOLD_ANALYSIS_PROJECT>

=cut

__PACKAGE__->table("GOLD_ANALYSIS_PROJECT");

=head1 ACCESSORS

=head2 gold_analysis_project_id

  data_type: 'numeric'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number"}
  sequence: 'gold_analysis_project_id_seq'
  size: 126

=head2 its_analysis_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 analysis_project_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 ncbi_tax_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 img_dataset_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 analysis_product_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 visibility

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 domain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_phylum

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_class

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_order

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_family

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_genus

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_species

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 gold_analysis_project_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 gold_proposal_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 ecosystem_category

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 ecosystem_subtype

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 specific_ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 reference_img_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 pi_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 pi_email

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 submitter_contact_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 ecosystem_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 specimen

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 reference_img_experiment_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 reference_gold_ap_id

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 16

=head2 genome_size

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 gene_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 scaffold_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 its_analysis_project_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 contig_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 genbank_low_quality_annotation

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 genbank_low_quality_genome

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 completion_date

  data_type: 'timestamp'
  is_nullable: 1

=head2 binning_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 gene_calling_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 submission_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 img_analysis_complete

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 status

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 is_gene_primp

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 3

=head2 gene_primp_date

  data_type: 'timestamp'
  is_nullable: 1

=head2 is_decontamination

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 3

=head2 is_img_annotation

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 3

=head2 its_annotation_at_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 its_assembly_at_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 is_assembled

  data_type: 'varchar2'
  is_nullable: 1
  size: 16

=head2 genome_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 40

=head2 study_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 locus_tag

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 cultured

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 jgi_sequenced

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 reference_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 strain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 submission_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 submitter_email

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 review_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 40

=head2 caliban_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 assembly_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "gold_analysis_project_id",
  {
    data_type => "numeric",
    is_auto_increment => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    sequence => "gold_analysis_project_id_seq",
    size => 126,
  },
  "its_analysis_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "analysis_project_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "ncbi_tax_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "img_dataset_id",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "analysis_product_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "visibility",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "domain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_phylum",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_class",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_order",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_family",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_genus",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_species",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "gold_analysis_project_type",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "gold_proposal_name",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem_category",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem_subtype",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "specific_ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "reference_img_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "pi_name",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "pi_email",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "submitter_contact_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "ecosystem_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "specimen",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "reference_img_experiment_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "reference_gold_ap_id",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 16 },
  "genome_size",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "gene_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "scaffold_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "its_analysis_project_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "contig_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "genbank_low_quality_annotation",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "genbank_low_quality_genome",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "completion_date",
  { data_type => "timestamp", is_nullable => 1 },
  "binning_method",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "gene_calling_method",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "submission_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "img_analysis_complete",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "status",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "is_gene_primp",
  { data_type => "varchar2", default_value => "No", is_nullable => 1, size => 3 },
  "gene_primp_date",
  { data_type => "timestamp", is_nullable => 1 },
  "is_decontamination",
  { data_type => "varchar2", default_value => "No", is_nullable => 1, size => 3 },
  "is_img_annotation",
  { data_type => "varchar2", default_value => "No", is_nullable => 1, size => 3 },
  "its_annotation_at_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "its_assembly_at_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "is_assembled",
  { data_type => "varchar2", is_nullable => 1, size => 16 },
  "genome_type",
  { data_type => "varchar2", is_nullable => 1, size => 40 },
  "study_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "locus_tag",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "cultured",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "jgi_sequenced",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "reference_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "strain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "submission_type",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "submitter_email",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "review_status",
  { data_type => "varchar2", is_nullable => 1, size => 40 },
  "caliban_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "assembly_method",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</gold_analysis_project_id>

=back

=cut

__PACKAGE__->set_primary_key("gold_analysis_project_id");

=head1 RELATIONS

=head2 gold_analysis_project_lookups

Type: has_many

Related object: L<DBIC::IMG_Gold::Result::GoldAnalysisProjectLookup>

=cut

__PACKAGE__->has_many(
  "gold_analysis_project_lookups",
  "DBIC::IMG_Gold::Result::GoldAnalysisProjectLookup",
  {
    "foreign.gold_analysis_project_id" => "self.gold_analysis_project_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gold_analysis_projects

Type: has_many

Related object: L<DBIC::IMG_Gold::Result::GoldAnalysisProject>

=cut

__PACKAGE__->has_many(
  "gold_analysis_projects",
  "DBIC::IMG_Gold::Result::GoldAnalysisProject",
  {
    "foreign.reference_gold_ap_id" => "self.gold_analysis_project_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gold_ap_genbanks

Type: has_many

Related object: L<DBIC::IMG_Gold::Result::GoldApGenbank>

=cut

__PACKAGE__->has_many(
  "gold_ap_genbanks",
  "DBIC::IMG_Gold::Result::GoldApGenbank",
  {
    "foreign.gold_analysis_project_id" => "self.gold_analysis_project_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 reference_gold_ap

Type: belongs_to

Related object: L<DBIC::IMG_Gold::Result::GoldAnalysisProject>

=cut

__PACKAGE__->belongs_to(
  "reference_gold_ap",
  "DBIC::IMG_Gold::Result::GoldAnalysisProject",
  { gold_analysis_project_id => "reference_gold_ap_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iAyf0CfSAQ3NxFXSqbsPxw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/GoldAnalysisProject.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

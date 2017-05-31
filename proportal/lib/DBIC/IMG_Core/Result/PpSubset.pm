use utf8;
package DBIC::IMG_Core::Result::PpSubset;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::PpSubset

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<PP_SUBSET>

=cut

__PACKAGE__->table("PP_SUBSET");
__PACKAGE__->result_source_instance->view_definition("SELECT \nCASE\n   WHEN taxon.genome_type = 'isolate' THEN\n    CASE\n      WHEN lower(taxon_display_name) LIKE 'prochlorococcus%' THEN\n        CASE\n          WHEN taxon.domain = 'Bacteria' THEN 'pro'\n          WHEN taxon.domain = 'Viruses' THEN 'pro_phage'\n        END\n      WHEN lower(taxon_display_name) LIKE 'synechococcus%' THEN\n        CASE\n          WHEN taxon.domain = 'Bacteria' THEN 'syn'\n          WHEN taxon.domain = 'Viruses' THEN 'syn_phage'\n        END\n      WHEN ( lower(ecosystem_subtype) = 'marginal sea' OR lower(ecosystem_subtype) = 'pelagic') THEN\n        CASE\n          WHEN taxon.domain = 'Bacteria' THEN 'other'\n          WHEN taxon.domain = 'Viruses' THEN 'other_phage'\n        END\n    END\n   WHEN genome_type = 'metagenome' AND lower(ecosystem_type) = 'marine' THEN genome_type\nEND\nAS proportal_subset,\ntaxon_oid\nFROM \n    TAXON\n    INNER JOIN\n    GOLD_SEQUENCING_PROJECT \n    ON GOLD_SEQUENCING_PROJECT.gold_id = TAXON.sequencing_gold_id\n    WHERE taxon.OBSOLETE_FLAG = 'No'");

=head1 ACCESSORS

=head2 proportal_subset

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "proportal_subset",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NBJ4X/KezPT6E1u24tl40w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

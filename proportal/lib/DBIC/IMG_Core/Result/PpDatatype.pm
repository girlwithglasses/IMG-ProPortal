use utf8;
package DBIC::IMG_Core::Result::PpDatatype;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::PpDatatype

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<PP_DATATYPE>

=cut

__PACKAGE__->table("PP_DATATYPE");
__PACKAGE__->result_source_instance->view_definition("SELECT \nCASE\n  when genome_type = 'isolate' AND lower(uncultured_type) = 'single cell' THEN lower(uncultured_type)\n  when sequencing_strategy = 'Metatranscriptome' THEN lower(sequencing_strategy)\n  when ( dataset_type = 'Metatranscriptome' OR dataset_type = 'Transcriptome' ) THEN lower(dataset_type)\n  else genome_type\n  end\nAS data_type,\ntaxon.taxon_oid\nFROM taxon\ninner join gold_sequencing_project ON taxon.sequencing_gold_id = gold_sequencing_project.gold_id\nleft join rnaseq_dataset ON rnaseq_dataset.reference_taxon_oid = taxon.taxon_oid\nWHERE\ntaxon.obsolete_flag = 'No'");

=head1 ACCESSORS

=head2 data_type

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
  "data_type",
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EknAdBNQigbz8hN71RRlRA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

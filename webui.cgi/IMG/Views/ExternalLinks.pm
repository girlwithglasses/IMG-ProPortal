package IMG::Views::ExternalLinks;

use IMG::Util::Import;

our (@ISA, @EXPORT_OK);

BEGIN {
	require Exporter;
	@ISA = qw( Exporter );
	@EXPORT_OK = qw( get_external_link );
}

use IMG::App::Role::ErrorMessages qw( err );

=pod

=head1 NAME

IMG::Views::ExternalLinks

=head2 SYNOPSIS

	use strict;
	use warnings;
	use IMG::Views::Links qw( get_ext_link );

	my $link = get_ext_link( 'pubmed', '91764817' );
	# $link is http://www.ncbi.nlm.nih.gov/pubmed/9174817

	my $sso_url = get_ext_link( 'sso_url' );
	# $sso_url is https://signon.jgi-psf.org

=head2 DESCRIPTION

This module manages external links; it can be used either directly, through the function get_external_link, or by loading IMG::Views::Links and using the function get_ext_link.

=cut

=head3 external_links

Library of external links

=cut

my $external_links = {

	'sso_api_url' => 'https://signon.jgi-psf.org/api/sessions/',
	'sso_url' => 'https://signon.jgi-psf.org',
	'sso_user_info_url' => 'https://signon.jgi-psf.org/api/users/',

	'aclame_base_url' => 'http://aclame.ulb.ac.be/perl/Aclame/Genomes/prot_view.cgi?mode=genome&id=',
	'artemis_url' => 'http://www.sanger.ac.uk/Software/Artemis/',
	'blast_server_url' => 'https://img-worker.jgi-psf.org/cgi-bin/usearch/generic/hopsServer.cgi',
	'blastallm0_server_url' => 'https://img-worker.jgi-psf.org/cgi-bin/blast/generic/blastQueue.cgi',
	'cmr_jcvi_ncbi_project_id_base_url' => 'http://cmr.jcvi.org/cgi-bin/CMR/ncbiProjectId2CMR.cgi?ncbi_project_id=',
	'doi' => 'http://dx.doi.org/',
	'ebi_iprscan_url' => 'http://www.ebi.ac.uk/Tools/pfa/iprscan/',
	'enzyme_base_url' => 'http://www.genome.jp/dbget-bin/www_bget?',
	'flybase_base_url' => 'http://flybase.bio.indiana.edu/reports/',
	'gbrowse_base_url' => 'http://gpweb07.nersc.gov/',
	'gcat_base_url' => 'http://darwin.nox.ac.uk/gsc/gcat/report/',
	'geneid_base_url' => 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=gene&cmd=Retrieve&dopt=full_report&list_uids=',
	'go_base_url' => 'http://www.ebi.ac.uk/ego/DisplayGoTerm?id=',
	'go_evidence_url' => 'http://www.geneontology.org/GO.evidence.shtml',
	'gold_api_base_url' => 'https://gpweb08.nersc.gov:8443/',
	'gold_base_url' => 'http://genomesonline.org/',
	'gold_base_url_analysis' => 'https://gold.jgi-psf.org/analysis_projects?id=',
	'gold_base_url_project' => 'https://gold.jgi-psf.org/projects?id=',
	'gold_base_url_study' => 'https://gold.jgi-psf.org/study?id=',
	'greengenes_base_url' => 'http://greengenes.lbl.gov/cgi-bin/show_one_record_v2.pl?prokMSA_id=',
	'greengenes_blast_url' => 'http://greengenes.lbl.gov/cgi-bin/nph-blast_interface.cgi',
	'hgnc_base_url' => 'http://www.gene.ucl.ac.uk/nomenclature/data/get_data.php?hgnc_id=',
	'img_er_submit_project_url' => 'https://img.jgi.doe.gov/cgi-bin/submit/main.cgi?section=ProjectInfo&page=displayProject&project_oid=',
	'img_er_submit_url' => 'https://img.jgi.doe.gov/cgi-bin/submit/main.cgi?section=ERSubmission&page=displaySubmission&submission_id=',
	'img_mer_submit_url' => 'https://img.jgi.doe.gov/cgi-bin/submit/main.cgi?section=MSubmission&page=displaySubmission&submission_id=',
	'img_submit_url' => 'https://img.jgi.doe.gov/submit',
	'ipr_base_url' => 'http://www.ebi.ac.uk/interpro/entry/',
	'ipr_base_url2' => 'http://supfam.cs.bris.ac.uk/SUPERFAMILY/cgi-bin/scop.cgi?ipid=',
	'ipr_base_url3' => 'http://prosite.expasy.org/',
	'ipr_base_url4' => 'http://smart.embl-heidelberg.de/smart/do_annotation.pl?ACC=',
	'jgi_project_qa_base_url' => 'http://cayman.jgi-psf.org/prod/data/QA/Reports/QD/',
	'kegg_module_url' => 'http://www.genome.jp/dbget-bin/www_bget?md+',
	'kegg_orthology_url' => 'http://www.genome.jp/dbget-bin/www_bget?ko+',
	'kegg_reaction_url' => 'http://www.genome.jp/dbget-bin/www_bget?rn+',
	'ko_base_url' => 'http://www.genome.ad.jp/dbget-bin/www_bget?ko+',
	'metacyc_url' => 'http://biocyc.org/META/NEW-IMAGE?object=',
	'mgi_base_url' => 'http://www.informatics.jax.org/searches/accession_report.cgi?id=MGI:',
	'ncbi_bioproject' => 'http://www.ncbi.nlm.nih.gov/bioproject/',
	'ncbi_biosample' => 'http://www.ncbi.nlm.nih.gov/biosample/?term=',
	'ncbi_taxonomy' => 'https://www.ncbi.nlm.nih.gov/taxonomy/',
	'ncbi_blast_server_url' => 'https://img-proportal-dev.jgi-psf.org/cgi-bin/ncbiBlastServer.cgi',
	'ncbi_blast_url' => 'http://www.ncbi.nlm.nih.gov/blast/Blast.cgi?PAGE=Proteins&PROGRAM=blastp&BLAST_PROGRAMS=blastp&PAGE_TYPE=BlastSearch&SHOW_DEFAULTS=on',
	'ncbi_entrez_base_url' => 'http://www.ncbi.nlm.nih.gov/entrez/viewer.fcgi?val=',
	'ncbi_mapview_base_url' => 'http://www.ncbi.nlm.nih.gov/mapview/map_search.cgi?direct=on&idtype=gene&id=',
	'ncbi_project_id_base_url' => 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=genomeprj&cmd=Retrieve&dopt=Overview&list_uids=',
	'nice_prot_base_url' => 'http://www.uniprot.org/uniprot/',
	'pdb_base_url' => 'http://www.rcsb.org/pdb/explore.do?structureId=',
	'pdb_blast_url' => 'http://www.rcsb.org/pdb/search/searchSequence.do',
	'pfam_base_url' => 'http://pfam.sanger.ac.uk/family?acc=',
	'pfam_clan_base_url' => 'http://pfam.sanger.ac.uk/clan?acc=',
	'pirsf_base_url' => 'http://pir.georgetown.edu/cgi-bin/ipcSF?id=',
	'pubmed' => 'http://www.ncbi.nlm.nih.gov/pubmed/',
	'pubmed_base_url' => 'http://www.ncbi.nlm.nih.gov/entrez?db=PubMed&term=',
	'puma_base_url' => 'http://compbio.mcs.anl.gov/puma2/cgi-bin/search.cgi?protein_id_type=NCBI_GI&search=Search&search_type=protein_id&search_text=',
	'puma_redirect_base_url' => 'http://compbio.mcs.anl.gov/puma2/cgi-bin/puma2_url.cgi?gi=',
	'regtransbase_base_url' => 'http://regtransbase.lbl.gov/cgi-bin/regtransbase?page=geneinfo&protein_id=',
	'regtransbase_check_base_url' => 'http://regtransbase.lbl.gov/cgi-bin/regtransbase?page=check_gene_exp&protein_id=',
	'rfam_base_url' => 'http://rfam.sanger.ac.uk/family/',
	'rgd_base_url' => 'http://rgd.mcw.edu/tools/genes/genes_view.cgi?id=',
	'rna_server_url' => 'https://img-worker.jgi-psf.org/cgi-bin/blast/generic/rnaServer.cgi',
	'swiss_prot_base_url' => 'http://www.uniprot.org/uniprot/',
	'swissprot_source_url' => 'http://www.uniprot.org/uniprot/',
	'tair_base_url' => 'http://www.arabidopsis.org/servlets/TairObject?type=locus&name=',
	'taxonomy_base_url' => 'http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=',
	'tigrfam_base_url' => 'http://www.jcvi.org/cgi-bin/tigrfams/HmmReportPage.cgi?acc=',
	'unigene_base_url' => 'http://www.ncbi.nlm.nih.gov/UniGene/clust.cgi',
	'vimss_redirect_base_url' => 'http://www.microbesonline.org/cgi-bin/gi2vimss.cgi?gi=',
	'worker_base_url' => 'https://img-worker.jgi-psf.org',
	'wormbase_base_url' => 'http://www.wormbase.org/db/gene/gene?name=',
	'zfin_base_url' => 'http://zfin.org/cgi-bin/webdriver?MIval=aa-markerview.apg&OID=',
};


sub reverse_hash {
return {
	'http://aclame.ulb.ac.be/perl/Aclame/Genomes/prot_view.cgi?mode=genome&id=' => 'aclame_base_url',
	'http://biocyc.org/META/NEW-IMAGE?object=' => 'metacyc_url',
	'http://cayman.jgi-psf.org/prod/data/QA/Reports/QD/' => 'jgi_project_qa_base_url',
	'http://cmr.jcvi.org/cgi-bin/CMR/ncbiProjectId2CMR.cgi?ncbi_project_id=' => 'cmr_jcvi_ncbi_project_id_base_url',
	'http://compbio.mcs.anl.gov/puma2/cgi-bin/puma2_url.cgi?gi=' => 'puma_redirect_base_url',
	'http://compbio.mcs.anl.gov/puma2/cgi-bin/search.cgi?protein_id_type=NCBI_GI&search=Search&search_type=protein_id&search_text=' => 'puma_base_url',
	'http://darwin.nox.ac.uk/gsc/gcat/report/' => 'gcat_base_url',
	'http://dx.doi.org/' => 'doi',
	'http://flybase.bio.indiana.edu/reports/' => 'flybase_base_url',
	'http://genomesonline.org/' => 'gold_base_url',
	'http://gpweb07.nersc.gov/' => 'gbrowse_base_url',
	'http://greengenes.lbl.gov/cgi-bin/nph-blast_interface.cgi' => 'greengenes_blast_url',
	'http://greengenes.lbl.gov/cgi-bin/show_one_record_v2.pl?prokMSA_id=' => 'greengenes_base_url',
	'http://pfam.sanger.ac.uk/clan?acc=' => 'pfam_clan_base_url',
	'http://pfam.sanger.ac.uk/family?acc=' => 'pfam_base_url',
	'http://pir.georgetown.edu/cgi-bin/ipcSF?id=' => 'pirsf_base_url',
	'http://prosite.expasy.org/' => 'ipr_base_url3',
	'http://regtransbase.lbl.gov/cgi-bin/regtransbase?page=check_gene_exp&protein_id=' => 'regtransbase_check_base_url',
	'http://regtransbase.lbl.gov/cgi-bin/regtransbase?page=geneinfo&protein_id=' => 'regtransbase_base_url',
	'http://rfam.sanger.ac.uk/family/' => 'rfam_base_url',
	'http://rgd.mcw.edu/tools/genes/genes_view.cgi?id=' => 'rgd_base_url',
	'http://smart.embl-heidelberg.de/smart/do_annotation.pl?ACC=' => 'ipr_base_url4',
	'http://supfam.cs.bris.ac.uk/SUPERFAMILY/cgi-bin/scop.cgi?ipid=' => 'ipr_base_url2',
	'http://www.arabidopsis.org/servlets/TairObject?type=locus&name=' => 'tair_base_url',
	'http://www.ebi.ac.uk/ego/DisplayGoTerm?id=' => 'go_base_url',
	'http://www.ebi.ac.uk/interpro/entry/' => 'ipr_base_url',
	'http://www.ebi.ac.uk/Tools/pfa/iprscan/' => 'ebi_iprscan_url',
	'http://www.gene.ucl.ac.uk/nomenclature/data/get_data.php?hgnc_id=' => 'hgnc_base_url',
	'http://www.geneontology.org/GO.evidence.shtml' => 'go_evidence_url',
	'http://www.genome.ad.jp/dbget-bin/www_bget?ko+' => 'ko_base_url',

	'http://www.genome.jp/dbget-bin/www_bget?' => 'enzyme_base_url',
	'http://www.genome.jp/dbget-bin/www_bget?ko+' => 'kegg_orthology_url',
	'http://www.genome.jp/dbget-bin/www_bget?md+' => 'kegg_module_url',
	'http://www.genome.jp/dbget-bin/www_bget?rn+' => 'kegg_reaction_url',
	'http://www.informatics.jax.org/searches/accession_report.cgi?id=MGI:' => 'mgi_base_url',
	# JCVI_TIGRFAMS
	'http://www.jcvi.org/cgi-bin/tigrfams/HmmReportPage.cgi?acc=' => 'tigrfam_base_url',

	'http://www.microbesonline.org/cgi-bin/gi2vimss.cgi?gi=' => 'vimss_redirect_base_url',
	'http://www.ncbi.nlm.nih.gov/blast/Blast.cgi?PAGE=Proteins&PROGRAM=blastp&BLAST_PROGRAMS=blastp&PAGE_TYPE=BlastSearch&SHOW_DEFAULTS=on' => 'ncbi_blast_url',
	'http://www.ncbi.nlm.nih.gov/entrez?db=PubMed&term=' => 'pubmed_base_url',
	'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=gene&cmd=Retrieve&dopt=full_report&list_uids=' => 'geneid_base_url',
	'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=genomeprj&cmd=Retrieve&dopt=Overview&list_uids=' => 'ncbi_project_id_base_url',
	'http://www.ncbi.nlm.nih.gov/entrez/viewer.fcgi?val=' => 'ncbi_entrez_base_url',
	'http://www.ncbi.nlm.nih.gov/mapview/map_search.cgi?direct=on&idtype=gene&id=' => 'ncbi_mapview_base_url',
	'http://www.ncbi.nlm.nih.gov/pubmed/' => 'pubmed',
	'http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=' => 'taxonomy_base_url',
	'http://www.ncbi.nlm.nih.gov/UniGene/clust.cgi' => 'unigene_base_url',
	'http://www.rcsb.org/pdb/explore.do?structureId=' => 'pdb_base_url',
	'http://www.rcsb.org/pdb/search/searchSequence.do' => 'pdb_blast_url',
	'http://www.sanger.ac.uk/Software/Artemis/' => 'artemis_url',
	'http://www.uniprot.org/uniprot/' => 'nice_prot_base_url',
	'http://www.uniprot.org/uniprot/' => 'swiss_prot_base_url',
	'http://www.uniprot.org/uniprot/' => 'swissprot_source_url',
	'http://www.wormbase.org/db/gene/gene?name=' => 'wormbase_base_url',
	'http://zfin.org/cgi-bin/webdriver?MIval=aa-markerview.apg&OID=' => 'zfin_base_url',
	'https://gold.jgi-psf.org/analysis_projects?id=' => 'gold_base_url_analysis',
	'https://gold.jgi-psf.org/projects?id=' => 'gold_base_url_project',
	'https://gold.jgi-psf.org/study?id=' => 'gold_base_url_study',
	'https://gpweb08.nersc.gov:8443/' => 'gold_api_base_url',
	'https://img-proportal-dev.jgi-psf.org/cgi-bin/ncbiBlastServer.cgi' => 'ncbi_blast_server_url',
	'https://img-worker.jgi-psf.org' => 'worker_base_url',
	'https://img-worker.jgi-psf.org/cgi-bin/blast/generic/blastQueue.cgi' => 'blastallm0_server_url',
	'https://img-worker.jgi-psf.org/cgi-bin/blast/generic/rnaServer.cgi' => 'rna_server_url',
	'https://img-worker.jgi-psf.org/cgi-bin/usearch/generic/hopsServer.cgi' => 'blast_server_url',
	'https://img.jgi.doe.gov/cgi-bin/submit/main.cgi?section=ERSubmission&page=displaySubmission&submission_id=' => 'img_er_submit_url',
	'https://img.jgi.doe.gov/cgi-bin/submit/main.cgi?section=MSubmission&page=displaySubmission&submission_id=' => 'img_mer_submit_url',
	'https://img.jgi.doe.gov/cgi-bin/submit/main.cgi?section=ProjectInfo&page=displayProject&project_oid=' => 'img_er_submit_project_url',
	'https://img.jgi.doe.gov/submit' => 'img_submit_url',
};
}

=head3 get_external_link

Get an external link from the library

	my $link = IMG::Views::Links::get_external_link( 'pubmed', '81274414' );
	# $link = http://www.ncbi.nlm.nih.gov/pubmed/81274414

@param  $target - the name of the link in the hash above
@param  $id     - any other params (optional)

@return $link   - text string that forms the link

=cut

sub get_external_link {
	my $target = shift // die err({ err => 'missing', subject => 'link target' });

	die err({ err => 'not_found',
		subject => 'link target ' . ( $target || '' )
	}) unless defined $external_links->{$target};

	# simple string; append any arguments to it
	if ( ! ref $external_links->{$target} ) {
		return $external_links->{$target} . ( $_[0] || "" );
	}
	# otherwise, it's a coderef
	elsif ( ref $external_links eq 'CODE' ) {
		return $external_links->{$target}->( @_ );
	}
	return '';
}

1;

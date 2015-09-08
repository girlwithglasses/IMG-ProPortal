package ProPortal::Views::Links;

use IMG::Util::Base;
use Role::Tiny;

=head3 proportal_links

Construct links for ProPortal pages

Takes the list of active components or a default set of components

@output $links          hash of link templates

=cut

sub proportal_links {
	my $self = shift;

	my $active = $self->config->{active_components} || [ qw( location clade data_type ) ];

	my %links;

	@links{ @$active } = map { $self->config->{pp_app} . $_ . "/" } @$active;

	return \%links;

}

=head3 img_links

Construct templates for internal (ProPortal) links

@param  $style  (opt)   the link style to construct. Will use the old school
                        param=value form unless specified otherwise
                        currently-valid values: 'new'

@output $output         hash of link templates

=cut

# links required: news

sub img_links {
	my $self = shift;
	my $style = shift || 'old';

	my $base = {
		old => $self->config->{main_cgi_url},
#		new => $self->config->{pp_app},
	};

	my $links = {
		taxon => {
			section => 'TaxonDetail',
			page => 'taxonDetail',
			taxon_oid => ''
		},
		genome_list => {
			section => 'ProPortal',
			page => 'genomeList',
			class => '',
		},
		genome_list_ecosystem => {
			section => 'ProPortal',
			page => 'genomeList',
			class => 'marine_metagenome',
			ecosystem_subtype => ''
		},
		genome_list_clade => {
			section => 'ProPortal',
			page => 'genomeList',
			metadata_col => 'p.clade',
			clade => ''
		},
	};


	my $params = [ qw( section page class taxon_oid ecosystem_subtype metadata_col clade ) ];

	my $link_gen = {
		# new skool /section/page/class style
		'new' => sub {
			my $l_hash = shift;
			return join "", map { "/" . ( $l_hash->{$_} || "" ) } grep { exists $l_hash->{$_} } @$params;
		},

		# this constructs URLs in the old skool arg1=val1&arg2=val2 style
		'old' => sub {
			my $l_hash = shift;
			return
				$base->{old} . "?" . join "&amp;",
					map { $_ . "=" . ( $l_hash->{$_} || "" ) }
					grep { exists $l_hash->{$_} } @$params;
		}
	};

	if (! $link_gen->{$style}) {
		$style = 'old';
	}

	my %output;

	@output{ keys %$links } = map {
		$link_gen->{ $style }->( $_ );
	} values %$links;

	return \%output;
}

=head3 external_links

External links

=cut

sub external_links {

	return {

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
}


1;

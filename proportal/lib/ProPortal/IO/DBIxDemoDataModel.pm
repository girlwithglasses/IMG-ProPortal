package ProPortal::IO::DBIxDemoDataModel;

use IMG::Util::Base 'MooRole';
use Class::Method::Modifiers;
use Text::CSV_XS qw( csv );

use JSON qw( encode_json decode_json );

my $dispatch_table = {

clade => sub {
return decode_json '[{"taxon_display_name":"Synechococcus sp. KORDI-100 (genome sequencing)","taxon_oid":"2507262013","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1","clade":"5.1-UC-A","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. CC9311","taxon_oid":"637000309","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1A","clade":"5.1A-I","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. CC9311","taxon_oid":"2623620876","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1A","clade":"5.1A-I","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. CC9605","taxon_oid":"637000310","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1A","clade":"5.1A-II","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. KORDI-52 (genome sequencing)","taxon_oid":"2507262012","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1A","clade":"5.1A-II","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. WH 8109","taxon_oid":"2563366603","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1A","clade":"5.1A-II","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. WH8102","taxon_oid":"637000314","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1A","clade":"5.1A-III","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. BL107","taxon_oid":"2623620351","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1A","clade":"5.1A-IV","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. BL107","taxon_oid":"639857006","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1A","clade":"5.1A-IV","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. CC9902","taxon_oid":"637000311","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1A","clade":"5.1A-IV","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. KORDI-49 (genome sequencing)","taxon_oid":"2507262011","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1A","clade":"5.1A-WPC1","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. WH 8016","taxon_oid":"2507262052","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1B","clade":"5.1B-I","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. RS9916","taxon_oid":"639857007","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1B","clade":"5.1B-IX","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. RS9916","taxon_oid":"2623620281","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1B","clade":"5.1B-IX","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. WH7803","taxon_oid":"640427149","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1B","clade":"5.1B-V","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. WH7803","taxon_oid":"2623620330","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1B","clade":"5.1B-V","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. WH7805","taxon_oid":"2623620868","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1B","clade":"5.1B-VI","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. WH7805","taxon_oid":"638341215","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1B","clade":"5.1B-VI","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. RS9917","taxon_oid":"638341213","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.1B","clade":"5.1B-VIII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. WH5701","taxon_oid":"638341214","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.2","clade":"5.2","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. RCC307","taxon_oid":"640427148","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.3","clade":"5.3-I / X","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Synechococcus sp. RCC307","taxon_oid":"2623620283","ir_order":"Chroococcales","genus":"Synechococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"5.3","clade":"5.3-I / X","phylum":"Cyanobacteria","ir_class":"unclassified","family":"unclassified"},{"taxon_display_name":"Prochlorococcus marinus pastoris CCMP 1986","taxon_oid":"637000214","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLI","clade":"HLI","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. EQPAC1","taxon_oid":"2606217689","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLI","clade":"HLI","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9515","taxon_oid":"2623620345","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLI","clade":"HLI","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9515","taxon_oid":"640069324","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLI","clade":"HLI","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. AS9601","taxon_oid":"2623620959","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. AS9601","taxon_oid":"640069321","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. GP2","taxon_oid":"2606217606","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT0604","taxon_oid":"2606217688","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9107","taxon_oid":"2606217692","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9116","taxon_oid":"2606217690","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9123","taxon_oid":"2606217318","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9201","taxon_oid":"2606217687","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9202","taxon_oid":"647533199","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9202","taxon_oid":"2623620984","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9215","taxon_oid":"640753041","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9215","taxon_oid":"2606217559","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9301","taxon_oid":"2623620961","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9301","taxon_oid":"640069322","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9302","taxon_oid":"2606217691","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9311","taxon_oid":"2606217680","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9312","taxon_oid":"637000210","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9314","taxon_oid":"2606217312","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9321","taxon_oid":"2606217683","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9322","taxon_oid":"2606217679","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9401","taxon_oid":"2606217316","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. SB","taxon_oid":"2606217677","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"HLII","clade":"HLII","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT0801","taxon_oid":"2606217560","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLI","clade":"LLI","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. NATL1A","taxon_oid":"2623620348","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLI","clade":"LLI","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. NATL1A","taxon_oid":"640069325","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLI","clade":"LLI","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. NATL2A","taxon_oid":"637000212","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLI","clade":"LLI","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. PAC1","taxon_oid":"2606217419","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLI","clade":"LLI","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus marinus marinus CCMP1375","taxon_oid":"2623620733","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLII/III","clade":"LLII/III","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus marinus marinus CCMP1375","taxon_oid":"637000213","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLII/III","clade":"LLII/III","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. LG","taxon_oid":"2606217685","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLII/III","clade":"LLII/III","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT0601","taxon_oid":"2606217319","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLII/III","clade":"LLII/III","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT0602","taxon_oid":"2606217317","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLII/III","clade":"LLII/III","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT0603","taxon_oid":"2606217686","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLII/III","clade":"LLII/III","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9211","taxon_oid":"641228501","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLII/III","clade":"LLII/III","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9211","taxon_oid":"2623620960","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLII/III","clade":"LLII/III","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. SS2","taxon_oid":"2606217313","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLII/III","clade":"LLII/III","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. SS35","taxon_oid":"2606217311","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLII/III","clade":"LLII/III","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. SS51","taxon_oid":"2606217315","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLII/III","clade":"LLII/III","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. SS52","taxon_oid":"2606217314","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLII/III","clade":"LLII/III","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus marinus MIT9313","taxon_oid":"637000211","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLIV","clade":"LLIV","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT0701","taxon_oid":"2606217684","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLIV","clade":"LLIV","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT0702","taxon_oid":"2606217681","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLIV","clade":"LLIV","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT0703","taxon_oid":"2606217682","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLIV","clade":"LLIV","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9303","taxon_oid":"2623620962","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLIV","clade":"LLIV","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"},{"taxon_display_name":"Prochlorococcus sp. MIT9303","taxon_oid":"640069323","ir_order":"Prochlorales","genus":"Prochlorococcus","genome_type":"isolate","domain":"Bacteria","generic_clade":"LLIV","clade":"LLIV","phylum":"Cyanobacteria","ir_class":"unclassified","family":"Prochlorococcaceae"}]';

},

ecosystem => sub {


},

ecotype => sub {

},

phylogram => sub {

},

taxon_oid_display_name => sub {
	my $self = shift;

	say 'self: ' . Dumper $self;

	return csv( in => $self->config->{local_data_dir} . 'dataset.tsv', headers => 'auto', sep_char => "\t", quote_char => undef );

},

location => sub {
	my $self = shift;
	my $aoh = csv( in => $self->config->{local_data_dir} . 'dataset.tsv', headers => 'auto', sep_char => "\t", quote_char => undef );
	return [ grep { $_->{latitude} && $_->{longitude} } @$aoh ];

}

};

sub filter {
	my $self = shift;
	my $data = shift;
	my $filter_h = $self->filters;

	my $f_types = {
		prochlor => {
			ecosystem_subtype => [ 'Marginal Sea', 'Pelagic' ],
			genome_type => 'isolate',
			genus => 'Prochlorococcus',
			domain => 'Bacteria',
		},

		synech => {
			ecosystem_subtype => [ 'Marginal Sea', 'Pelagic' ],
			genome_type => 'isolate',
			genus => 'Synechococcus',
			domain => 'Bacteria',
		},

		prochlor_phage => {
		#	ecosystem_subtype => [ 'Marginal Sea', 'Pelagic' ],
			genome_type => 'isolate',
			taxon_display_name => sub { shift =~ m/Prochlorococcus/i ? 1 : 0; },
			domain => 'Viruses',
		},

		synech_phage => {
		#	ecosystem_subtype => [ 'Marginal Sea', 'Pelagic' ],
			genome_type => 'isolate',
			taxon_display_name => sub { shift =~ m/Synechococcus/i ? 1 : 0; },
			domain => 'Viruses',
		},

		metagenome => {
			genome_type => 'metagenome',
			ecosystem_type => 'Marine',
		},

		isolate => {
			genome_type => 'isolate'
		},

		all_proportal => {}

	};

	if ( ! $f_types->{ $filter_h->{subset} } ) {
		die 'Filter ' . $filter_h->{subset} . ' is not defined';
	}

	if ( ! keys %{$f_types->{ $filter_h->{subset} } } ) {
		say 'Could not find any filters for ' . $filter_h->{subset};
		return $data;
	}

	my @test;
	for my $k ( keys %{$f_types->{ $filter_h->{subset} }} ) {
		say 'Looking at ' . $k;
		if ( ! ref $f_types->{ $filter_h->{subset} }{$k} ) {
			push @test, sub {
				my $t = shift;
				say 'looking for '
				. $k . ' to equal '
				. $f_types->{ $filter_h->{subset} }{$k}
				. '; it is ' . $t->{$k};

				return 1 if ! exists $t->{ $k };

				say 'test: ' . $f_types->{ $filter_h->{subset} }{$k}
				. ' equal to ' . $t->{$k} . ': '
				. ( $f_types->{ $filter_h->{subset} }{$k} eq $t->{$k} ) ;
				return $f_types->{ $filter_h->{subset} }{$k} eq $t->{$k} ? 1 : 0;
			};
		}
		elsif ( 'ARRAY' eq ref $f_types->{ $filter_h->{subset} }{$k} ) {
			push @test, sub {
				my $t = shift;
				say 'looking for ' . $k . ' to be one of: ' . join ", ", @{$f_types->{ $filter_h->{subset} }{$k}};
				return 1 if ! exists $t->{ $k };
				return scalar grep { $t->{$k} eq $_ } @{$f_types->{ $filter_h->{subset} }{$k}};
			};
		}
		elsif ( 'CODE' eq ref $f_types->{ $filter_h->{subset} }{$k} ) {
			push @test, $f_types->{ $filter_h->{subset} }{$k};
		}
	}

	say 'test array: ' . Dumper \@test;

	my @passed;
	DATA_LOOP:
	for my $d ( @$data ) {
		say 'looking at data item for ' . $d->{taxon_oid};
		for my $t ( @test ) {
			say 'Running test';
			my $ans = $t->( $d );
			say 'answer: ' . Dumper $ans;
			if ( ! $t->( $d ) ) {
				say $d->{taxon_oid} . ' failed test: ' . Dumper $t;
				next DATA_LOOP;
			}
#			next DATA_LOOP unless $_->( $d );
		}
		push @passed, $d;
	}
	return \@passed;
}

around run_query => sub {
    my $orig = shift;
	my $self = shift;

	my $args;
	if ( @_ && 1 < scalar( @_ ) ) {
		$args = { @_ } ;
	}
	else {
		$args = shift;
	}

	#	query is the name of the method to run
	#	args->{params} will contain filter params

	my $query = $args->{query}
		# no query specified
		or croak __PACKAGE__ . ' ' . (caller(0))[3]
		. ': no query specified!';

	if (! $self->can($query)) {
		croak __PACKAGE__ . ' ' . (caller(0))[3]
		. ': no query named ' . $query . ' exists!';
	}

	# add filters
	my $data = $self->$query;
	if ( $self->filters ) {
		return $self->filter( $data );
	}
	return $data;
};




1;
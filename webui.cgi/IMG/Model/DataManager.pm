package IMG::Model::DataManager;

use IMG::Util::Import 'MooRole';

sub get_label_data {

	return {

depth => {
	unit => 'm'
},
altitude => {
	unit => 'm',
},
proport_isolation => {
	label => 'Isolation details'
},
proport_ocean => {
	label => 'Ocean',
},
geo_location => {
	label => '<abbr title="National Oceanic and Atmospheric Administration">NOAA</abbr> sea name</abbr>',
},
chlorophyll_concentration => {
	unit => '&mu;g/L'
},
nitrate_concentration => {
	unit => '&mu;mol/kg'
},
oxygen_concentration => {
	unit => '&mu;mol/kg'
},
temperature => {
	unit => '&deg; C',
},
pressure => {
	unit => 'dbar'
},
proport_woa_salinity => {
	label => 'Salinity',
},
proport_woa_dissolved_oxygen => {
	label => 'Dissolved oxygen',
	unit => 'ml/L'
},
proport_woa_temperature => {
	label => 'Temperature',
	unit => '&deg; C'
},
proport_woa_nitrate => {
	label => 'Nitrate',
	unit => '&mu;mol/L'
},
proport_woa_phosphate => {
	label => 'Phosphate',
	unit => '&mu;mol/L'
},
proport_woa_silicate => {
	label => 'Silicate',
	unit => '&mu;mol/L'
},
bioproject_accession => {
	label => 'NCBI Bioproject',
	ext_link => 'ncbi_bioproject',
},
biosample_accession => {
	label => 'NCBI Biosample',
	ext_link => 'ncbi_biosample',
},
ncbi_taxon_id => {
	label => 'NCBI Taxon ID',
	ext_link => 'ncbi_taxonomy'
},
ncbi_project_id => {
	label => 'NCBI Project ID',
	ext_link => 'ncbi_bioproject'
}
};

}

1;

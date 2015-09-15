var species = [];
var selectedGenomes = {};
var selectedPlotSamples = [];
var passthrough = function(d) {return d;}
var lookupTaxon = function(taxon) { return 'taxon/'+taxon;}
var selectedGenomeValueFuncs = [passthrough, lookupTaxon, lookupTaxon]

var updateSpecies = function() {
    var species_to_plot = d3.select('#species_to_plot').selectAll('tr').data(species, function(name, i) { return name; });
    var row = species_to_plot.enter().append('tr')
    row.append('td')
    .append('button')
    .attr('onclick', function(d) { return 'removeSpecies(\''+d+'\')'; })
    .text('X');
    row.append('td')
    .text(String)
    species_to_plot.exit().remove();
}

var updateSelection = function() {
	selectedPlotSamples = Object.keys(selectedGenomes).map(function(k) { return selectedGenomes[k]; });
	var selectedTaxa = {};
	selectedPlotSamples.map(function(d) { selectedTaxa[d.sample.genome1] = d.species; selectedTaxa[d.sample.genome2] = d.species; });

    var selection = d3.select('#clicked_genomes').selectAll('tr').data(Object.keys(selectedTaxa), function(d, i) {
    	console.log( d );
    	return d;
    })
    var row = selection.enter().append('tr')
    row.append('td')
    .append('input')
    .attr('class', 'genomeSet-chk')
    .attr('type', 'checkbox')
    .attr('value', function(d) { return d;})
    .attr('name', 'taxon_filter_oid')
    .attr('id', function(d) { return d; })
    row.append('td')
    .append('label')
    .attr('for', function(d) { return d; })
    .text(function(d) { return 'Species: ' + selectedTaxa[d] + ' | Taxon: ' + d; })
    selection.exit().remove();
}

var onClickedSample = function(species_name, sample, key) {
	if(key in selectedGenomes) {
		delete selectedGenomes[key];
	} else {
        selectedGenomes[key] = {species: species_name, sample: sample, key: key};
	}

    updateSelection();
}

var removeSpecies = function(name) {
  var i = species.indexOf(name);
  if(species.length > i && i >= 0) {
    species.splice(i, 1);
    updateSpecies();
  }
}

var resetSelection = function() {
	selectedGenomes = {};
}

var clearSelection = function() {
    resetSelection();
    updateSelection();
}

var clearSpecies = function() {
    species = [];
        var plot = document.getElementById('svg1');
        plot.innerHTML = "";

    updateSpecies();
    clearSelection();
}

var showProgressWheel = function() {
  document.getElementById("loading_image").style.display = "block";
}

var hideProgressWheel = function() {
  document.getElementById("loading_image").style.display = "none";
}

var plotSpecies = function(cgi_url) {
    var url = [cgi_url].concat(species).join('&genus_species=');

    var pt_type = "type2";
    /*
    var e = document.getElementById('type1');
    if (e.checked == true) {
        pt_type = "type1";
    }
    */
    showProgressWheel();
    clearSelection();
    AniPlotter.plot('svg1', pt_type, {url: encodeURI(url)}, hideProgressWheel);
}

var addSpecies = function() {
    var species_selection = document.getElementById('species');
    if (species.indexOf(species_selection.value) !== 0) {
        species.push(species_selection.value);
        updateSpecies();
    }
}

var fetchSpecies = function(species_url) {
    var kingdom_selection = document.getElementById('kingdom');
    if (kingdom_selection.value == 'none') {
        clearSpecies();
        var species = document.getElementById('species');
        species.innerHTML = "";
        return;
    }

    showProgressWheel();
    d3.json(species_url+'?domain='+kingdom_selection.value, function(data) {
        hideProgressWheel();
        var options = d3.select('#species').selectAll('option').data(data);
        options.enter().append('option');
        options.text(String);
        options.exit().remove();
    });
}

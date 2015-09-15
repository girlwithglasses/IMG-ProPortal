var species = [];
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

var removeSpecies = function(name) {
  var i = species.indexOf(name);
  if(species.length > i && i >= 0) {
    species.splice(i, 1);
    updateSpecies();
  }
}

var clearSpecies = function() {
    species = [];
        var plot = document.getElementById('svg1');
        plot.innerHTML = "";

    updateSpecies();
}

var showProgressWheel = function() {
  document.getElementById("loading_image").style.display = "block";
}

var hideProgressWheel = function() {
  document.getElementById("loading_image").style.display = "none";
}

var plotSpecies = function(cgi_url) {
    var url = [cgi_url].concat(species).join('&genus_species=');

    var e = document.getElementById('type1');
    var pt_type = "type2";
    if (e.checked == true) {
        pt_type = "type1";
    }
    showProgressWheel();
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

function fn(res,d,gm,MarkerClusterer,links) {
	"use strict";
	var ppMap = {
		map: null,
		cm : null,
		markers: [],
		type: gm.MapTypeId.ROADMAP,
		bounds: null,
		infoBox: null,
//		mzs: null,
		map_div: d.getElementById('map'),
		info_div: d.getElementById('info'),

	/**
	makeMap:

	create the map

	@param zoom - zoom level (optional; defaults to 1)
	@param lt - latitude for the map centre (optional)
	@param ln - longitude of map centre (optional)

	*/
		makeMap: function(zoom,lt,ln){
			var cen,
			opts = {
			//	mapTypeControl: true,
				streetViewControl: false,
				zoom: zoom || 5,
			//  center: cen,
				mapTypeId: ppMap.type
			};
			if (lt && ln) {
				opts.center = new gm.LatLng(lt,ln);
			}

			ppMap.map = new gm.Map(ppMap.map_div, opts);
			ppMap.bounds = new gm.LatLngBounds();
			ppMap.infoBox = new gm.InfoWindow();
			return ppMap.map;
		},

	/**
	makeClstrMap


	*/
		makeClstrMap: function(){
			ppMap.makeMap(5,0,0);
			// add the clusterer
			ppMap.cm = new MarkerClusterer(ppMap.map, ppMap.markers, {
			//	zoomOnClick: false,
				averageCenter: true,
				ignoreHidden: true
			});
			ppMap.cm.fitMapToMarkers();

			gm.event.addListener(ppMap.cm, 'click', function(c){
			//	ppMap.map.panTo(c.getCenter());
				// get current zoom level, check max zoom level
				if ( ppMap.map.mapTypes[ ppMap.map.mapTypeId ].maxZoom === ppMap.map.get('zoom') ) {
					// show info window
					alert("We're at max zoom level!");
					ppMap.showClstrInfoBox(c);
					ppMap.showClstrAuxInfo(c);
				}
				else {
			//		ppMap.map.set('zoom', ppMap.map.get('zoom') + 2);
				 }
			});
/*
*/
			return ppMap.cm;
		},

	/**
	makeMarker:

	Create a marker to add to the map

	@param pt - object with params
		latitude
		longitude
		tooltip
		...
	@param m  - an existing map to add the marker to (optional)

	@return x - marker object
	*/
		makeMarker: function(pt,m){
			var ltln = new gm.LatLng(pt.latitude, pt.longitude),
			x,
			x_opts = {
				position: ltln,
				title: pt.geo_location,
				data: pt
			};
			if (typeof m !== 'undefined') {
				x_opts.map = m;
			}

			x = new gm.Marker(x_opts);

			gm.event.addListener(x, 'click', function() {
				ppMap.showInfoBox(pt, x);
				ppMap.showAuxInfo(pt);
			});

			ppMap.markers.push(x);
			return x;
		},

	/**
	showInfoBox

	opens an info window, sets the content to the data point's info string

	@param pt - data point
	@param x - the marker that has been clicked

	*/
		showInfoBox: function(pt, x){
			ppMap.infoBox.close();
			ppMap.infoBox.setContent(ppMap.getInfo(pt));
			ppMap.infoBox.open(ppMap.map, x);
		},

	/**
	showAuxInfo

	display auxilliary information in the side panel

	@param pt - object containing the data to be shown
		gets (and sets, if absent) the parameter pt.html

	*/

		showAuxInfo: function(pt){
			if (! pt.html){
				if (pt.genomes.length > 1) {
					return ppMap.showClstrAuxInfo(pt);
				}
				var g = pt.genomes[0];
				pt.html = '<h3>' + pt.geo_location + '</h3>'
				+ '<p>' + pt.latitude + ', ' + pt.longitude + '</p>'
				+ '<h5>' + g.taxon_display_name + '</h5>'
				+ '<dl>'
				+ '<dt>Genome type</dt>'
				+ '<dd>' + ( g.genome_type || 'not specified' ) + '</dd>'
				+ '<dt>Clade</dt>'
				+ '<dd>' + ( g.clade || 'not specified' ) + '</dd>';
				if (g.depth_string) {
					pt.html += '<dt>Depth</dt><dd>' + g.depth_string + '</dd>';
				}
				else if (g.altitude_string) {
					pt.html += '<dt>Altitude</dt><dd>' + g.altitude_string + '</dd>';
				}
				else if (g.depth !== '' && g.depth !== null) {
					pt.html += '<dt>Depth</dt><dd>' + g.depth + 'm</dd>';
				}
				else if (g.altitude !== '' && g.altitude !== null) {
					pt.html += '<dt>Altitude</dt><dd>' + g.altitude + 'm</dd>';
				}
				else {
					pt.html += '<dt>Altitude/depth</dt><dd>not specified</dd>';
				}
				pt.html += '<dt>Ecotype</dt>'
				+ '<dd>' + ( g.ecotype || 'not specified' ) + '</dd></dl>'
				+ '<p><a href="' + links.taxon + g.taxon_oid + '">View taxon details</a></p>';
			}
			ppMap.info_div.innerHTML = pt.html;
		},

	/**
	showClstrAuxInfo

	display auxilliary information about the genome in the side panel

	@param pt - the marker point

	*/

		showClstrAuxInfo: function(pt){
			var ml,
			i;
			pt.html = '<h3>' + pt.geo_location + '</h3>'
			+ '<p>' + pt.latitude + ', ' + pt.longitude + '</p>';
			pt.html += "<ul>";
			for (i=0,ml=pt.genomes.length;i<ml;i++) {
				pt.html += '<li><a href="' + links.taxon + pt.genomes[i].taxon_oid + '">' + pt.genomes[i].taxon_display_name + "</a>";
				if (pt.genomes[i].genome_type !== "") {
					pt.html += " (" + pt.genomes[i].genome_type + ")";
				}
			}
			pt.html += "</ul>";
			ppMap.info_div.innerHTML = pt.html;
		},


	/**
	getInfo

	create the content of the info box

	@param pt - object containing the data to be shown
		gets (and sets, if absent) the parameter pt.summary

	*/
		getInfo: function(pt){
			if (! pt.info) {
				var str = '<h6>' + pt.geo_location + '</h6>'
				+ '<p>' + pt.latitude + ', ' + pt.longitude + '</p>',
				g;
				if (pt.genomes.length > 1) {
					str += '<p>' + pt.genomes.length
						+ " samples from this location</p>";
				}
				else {
					g = pt.genomes[0];
					if (g.depth_string) {
						str += '<p>Depth: ' + g.depth_string + '</p>';
					}
					else if (g.altitude_string) {
						str += '<p>Altitude: ' + g.altitude_string + '</p>';
					}
					else if (g.depth !== '' && g.depth !== null) {
						str += '<p>Depth: ' + g.depth + 'm</p>';
					}
					else if (g.altitude !== '' && g.altitude !== null) {
						str += '<p>Altitude: ' + g.altitude + 'm</p>';
					}
					else {
						str += '<p>Altitude/depth not specified</p>';
					}
					str += '<p><a href="' + links.taxon + g.taxon_oid + '">' + g.taxon_display_name + '</a></p>';
				}
				pt.info = str;
			}
			return pt.info;
		},
	/**
	goMap

	does everything!

	@param data - array of json data
	*/
		goMap: function( arr ){
			var al = arr.length,
			i;
			if (al>1) {
				// cluster map
				for(i=0;i<al;i++){
					ppMap.makeMarker(arr[i]);
				}
				ppMap.makeClstrMap();
			//	ppMap.addSpiders();
				return;
			}
			// single point map
			i = ppMap.makeMap( 5, arr[0].latitude, arr[0].longitude );
			ppMap.makeMarker(arr[0], i);
		}
	};
	ppMap.goMap(res);
}

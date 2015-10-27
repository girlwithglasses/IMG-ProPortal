/*
api v3 we have to close the info window manually

http://stackoverflow.com/questions/2946165/google-map-api-v3-simply-close-an-infowindow

<link href="http://code.google.com/apis/maps/documentation/javascript/examples/default.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
*/
var openInfoWindow;

var markers = [];

function createMap(zoomlevel, lat, lon) {
    var centerLatlng = new google.maps.LatLng(lat, lon);
    var myOptions = {
      zoom: zoomlevel,
      center: centerLatlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }

    var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

    return map;
}

function addMarkerWithLabel(map, lat, lon, tooltip, contentString, label) {
    var myLatlng = new google.maps.LatLng(lat,lon);

    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });

    tooltip = unescape(tooltip);
    label = unescape(label);

    var marker = new MarkerWithLabel({
	position: myLatlng,
	map: map,
	title: tooltip,
	labelContent: label,
	labelAnchor: new google.maps.Point(16, 0), // half the width + 1
	labelClass: "maplabel", // the CSS class for the label
	labelStyle: {opacity: 1.0}
    });

    markers.push(marker);

    google.maps.event.addListener(marker, 'click', function() {
	if (openInfoWindow != null) {
	    openInfoWindow.close();
	}
	infowindow.open(map, marker);
	openInfoWindow = infowindow;
    });
}

function addMarker(map, lat, lon, tooltip, contentString) {
    var myLatlng = new google.maps.LatLng(lat,lon);
       
    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });

    tooltip = unescape(tooltip);
    var marker = new google.maps.Marker({
        position: myLatlng,
        map: map,
        title: tooltip
    });

    markers.push(marker);
    
    google.maps.event.addListener(marker, 'click', function() {
      if (openInfoWindow != null) {
          openInfoWindow.close();
      }
      infowindow.open(map, marker);
      openInfoWindow = infowindow;
    });
}

function cluster(map) {
    var markerCluster = new MarkerClusterer(map, markers);
}



/*
api v3 we have to close the info window manually

http://stackoverflow.com/questions/2946165/google-map-api-v3-simply-close-an-infowindow
<link href="http://code.google.com/apis/maps/documentation/javascript/examples/default.css" rel="stylesheet" type="text/css" />
*/
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>

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

function addMarker(map, lat, lon, tooltip, contentString, myData) {

    var myLatlng = new google.maps.LatLng(lat,lon);

    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });

    tooltip = unescape(tooltip);
    var marker = new google.maps.Marker({
        position: myLatlng,
        map: map,
        title: tooltip,
	customInfo: myData
    });

    markers.push(marker);

    google.maps.event.addListener(marker, 'click', function() {
      var info_panel = document.getElementById("detail_info_div");
      info_panel.innerHTML = marker.customInfo;

      if(openInfoWindow != null) {
        openInfoWindow.close();
      }
      /* infowindow.open(map,marker); */
      openInfoWindow = infowindow;
      });
}

function cluster(map) {
    var markerCluster = new MarkerClusterer(map, markers);
}



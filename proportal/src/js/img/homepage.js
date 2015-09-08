/**
 * open and close the sliding divs
 * @param divId
 */
function myDisplay(divId) {
   var divs = ["type", "location", "depth", "clade"];
   for(i = 0; i < divs.length; i++) {
       var f = document.getElementById(divs[i]);
       if(divs[i] == divId) {
           var x = f.style.display;
           if( x === undefined || x == '' || x == "none" ) {
               f.style.display = "inline-block";
               
               // TODO do a ajax call to get the data
               getByXDivData(divId);
               
               
           } else if(x == "inline-block") {
               f.style.display = "none";
           }
       } else {
           f.style.display = "none";
       }
   }
}

function getByXDivData(divId) {
    //var url =  "xml.cgi?section=ProPortal&page=kentestdiv";
    var url =  "xml.cgi?section=ProPortal&page=";
    if(divId == 'type') {
        url = url + 'datatypegraph';
    } else if(divId == 'location') {
        url = url + 'googlemap';
    } else if(divId == 'depth') {
        url = url + 'depthgraph';
    } else if(divId == 'clade') {
        url = url + 'cladegraph';
    }
    
    
    var callbacks = {
        success : function(o) {
            if(divId == 'type') {
                var e = document.getElementById('typeChart');
                e.innerHTML = o.responseText;

            } else if(divId == 'location') {
                var e = document.getElementById('locationChart');
                e.innerHTML = o.responseText;

            } else if(divId == 'depth') {
                var e = document.getElementById('depthChart');
                e.innerHTML = o.responseText;

            } else if(divId == 'clade') {
                var e = document.getElementById('cladeChart');
                e.innerHTML = o.responseText;

            }
        },
        failure : function(o) {
            if (!YAHOO.util.Connect.isCallInProgress(o)) {
                alert(o.responseText);
                alert("Error: " + o.statusText);
            } else if (o.status == -1) {
                alert("Connection Timeout: " + o.statusText);
            } else if (o.status == 0) {
                alert("Server Error: " + o.statusText);
            } else {
                alert("Failure: " + o.statusText);
            }            
        },
        timeout : 300000
    }

    YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
}
/*
 * $Id: cart.js 29739 2014-01-07 19:11:08Z klchu $
 */

/**
 * inner html http request successful
 * @param o http request object
 */
var handleSuccess = function(o) {
	var e = document.getElementById('tracker');
	e.innerHTML = o.responseText;
}

/**
 * inner html http request failure
 * @param o http request object
 */
var handleFailure = function(o) {
	if (o.status == -1) {
	    alert("Connection Timeout: " + o.statusText);
	} else if (o.status == 0) {
	    alert("Server Error: " + o.statusText);
	} else {
	    alert("Failure: " + o.statusText);
	}
}

/**
 * inner html pages http request callback object
 * time out set to 60000 msec
 */
var callback = {
        success : handleSuccess,
        failure : handleFailure,
        timeout : 80000
}

function addNeighborhoodCart(url, id) {
	var e = document.getElementById(id);
	if (e.checked == true) {
	    url = url + "&page=addNeighborhood";
	} else {
	    url = url + "&page=removeNeighborhood";
	}

	var request = YAHOO.util.Connect.asyncRequest('GET', unescape(url),
		      callback);
}

function addMyGeneCart(gene_oid) {
	var e = document.getElementById("geneselect");
	if (e.checked == true) {
	    var url = "xml.cgi?section=Cart&gene_oid=" + gene_oid
		    + "&page=addGeneCart";
	    var request = YAHOO.util.Connect.asyncRequest('GET', unescape(url),
		          callback);
	} else {
	    window.open("main.cgi?section=GeneDetail&page=geneDetail&gene_oid="
			+ gene_oid, "_blank");
	}
}

function refreshTracker() {
	var url = "xml.cgi?section=Cart&page=refresh";
	var request = YAHOO.util.Connect.asyncRequest('GET', unescape(url),
		      callback);
}


function clearGene() {
	var url = "xml.cgi?section=Cart&page=cleargene";
	var request = YAHOO.util.Connect.asyncRequest('GET', unescape(url),
		      callback);
}

function clearNeighborhood() {
	var f = document.mainForm;
	for ( var i = 0; i < f.length; i++) {
	    var e = f.elements[i];
	    if (e.type == "checkbox" && e.name == "plotbox") {
		e.checked = false;
	    }
	}

	var url = "xml.cgi?section=Cart&page=clearneigh";
	var request = YAHOO.util.Connect.asyncRequest('GET', unescape(url),
	              callback);
}

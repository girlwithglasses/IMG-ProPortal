/*
 $Id: treeFile.js 29739 2014-01-07 19:11:08Z klchu $
 */

var handleSuccess = function(o) {
	//var e = document.getElementById( 'status_line_z2' );
	// e.innerHTML = o.responseText;
	// alert(o.responseText);
}

var handleFailure = function(o) {
	if (o.status == -1) {
		alert("Connection Timeout: " + o.statusText);
	} else if (o.status == 0) {
		alert("Server Error: " + o.statusText);
	} else {
		alert("Failure: " + o.statusText);
	}
}

/*
 * callback must be after handleSuccess
 */
var callback = {
	success : handleSuccess,
	failure : handleFailure,
	timeout : 60000
}

function onChecked(id, url) {
	//alert("todo checked id=" + id);
	var e = document.getElementById(id);
	// alert(e.checked);
	if (e.checked == false) {
		url = url + "&remove=true";
	}

	var request = YAHOO.util.Connect.asyncRequest('GET', unescape(url),
			callback);
	// alert("hello " + request);
}

function myopen(url, id) {
	// i added time to get the page to reload with the # in the url
	// when you click the same button or url again and again
	var tmp = ctime();
	window.open(url + "&tmp=" + tmp + "#" + id, '_self', '', false);
}

//// cassette search
var handleSuccess2 = function(o) {
	var e = document.getElementById('clustertable');
	e.innerHTML = o.responseText;
}

var callback2 = {
	success : handleSuccess2,
	failure : handleFailure,
	timeout : 60000
}

function clusterSwitch(url) {
	var request = YAHOO.util.Connect.asyncRequest('GET', unescape(url),
			callback2);
	var e0 = document.getElementById("clustertable");
	e0.innerHTML = "<font color='red'><blink>Loading ...</blink><font>";
}

/*
 * update div with id treeviewer
 *
 */

var handleSuccess4 = function(o) {
	var e = document.getElementById('treeviewer');
	e.innerHTML = o.responseText;
}

var callback4 = {
	success : handleSuccess4,
	failure : handleFailure,
	timeout : 60000
}

function updateTreeDiv(url) {
	var request = YAHOO.util.Connect.asyncRequest('GET', unescape(url),
			callback4);
	var e0 = document.getElementById("treeviewer");
	e0.innerHTML = "<font color='red'><blink>Loading ...</blink><font>";
}

function myopen4(url, id) {
	// i added time to get the page to reload with the # in the url
	// when you click the same button or url again and again
	var tmp = ctime();
	updateTreeDiv(url + "&tmp=" + tmp + "#" + id, '_self', '', false);
}

function redisplay(url, value) {
	if(value != '-') {
		window.open(url + value, '_self');
	}

}

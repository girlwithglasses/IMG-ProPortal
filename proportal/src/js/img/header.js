/* code from header.html and footer.html */
function hideDiv(divId) {
    document.getElementById(divId).style.display='none';
}

function createRequestObjectOld() {
	var ro;
	var browser = navigator.appName;
	if (browser == "Microsoft Internet Explorer") {
		ro = new ActiveXObject("Microsoft.XMLHTTP");
	} else {
		ro = new XMLHttpRequest();
	}
	return ro;
}
function createRequestObject() {
	var ro;
	try {
		ro = new ActiveXObject("Msxml2.XMLHTTP");
	} catch (e) {
		try {
			ro = new ActiveXObject("Microsoft.XMLHTTP");
		} catch (oc) {
			ro = null;
		}
	}
	if (!ro && typeof XMLHttpRequest != "undefined") {
		ro = new XMLHttpRequest();
	}
	return ro;
}

var http = createRequestObject();
var http2 = createRequestObject();


function sendUrl(url, handler) {
	http.open("get", url);
	http.setRequestHeader("If-Modified-Since", "Jan 1, 2000 00:00:00 GMT");
	http.onreadystatechange = handler;
	http.send(null);
}
function sendUrl2(url, handler) {
	http2.open("get", url);
	http2.setRequestHeader("If-Modified-Since", "Jan 1, 2000 00:00:00 GMT");
	http2.onreadystatechange = handler;
	http2.send(null);
}


function setStatusBox(s) {
	var e = document.getElementById("genomes");
	e.innerHTML = s;
}

function printLoadingMessage() {
	var s = "<div id='status_line_z3'>"
			+ "<font color='red'><blink>js Loading ...</blink></font>"
			+ "</div>";
	document.write(s);
}
function printLoadedMessage() {
	/* --es hangs
	var s = "<div id='status_line_z3'>" +
	   "js Loaded." +
	   "</div>";
	document.write( s );
	 */
	var e = document.getElementById('status_line_z3');
	e.innerHMTL = "js Loaded.";
}

function ctime() {
	var now = new Date();
	var hour = now.getHours();
	var minute = now.getMinutes();
	var second = now.getSeconds();
	var x = second + (60 * minute) + (60 * 60 * hour) + (60 * 60 * 24 * hour);
	return x;
}

/* below code is from footer.html */
function selectAllCheckBoxes(x) {
	var f = document.mainForm;
	for ( var i = 0; i < f.length; i++) {
		var e = f.elements[i];
		if (e.name == "mviewFilter")
			continue;
		if (e.type == "checkbox") {
			e.checked = (x == 0 ? false : true);
		}
	}
}

function inverseSelection() {
	var f = document.mainForm;
	for ( var i = 0; i < f.length; i++) {
		var e = f.elements[i];
		if (e.name == "mviewFilter")
			continue;
		if (e.type == "checkbox") {
			e.checked = (e.checked ? false : true);
		}
	}
}

function selectAllByName(name, doSelect) { 
    var els = document.getElementsByName(name); 
    for ( var i = 0; i < els.length; i++) { 
        var e = els[i]; 
        if (e.type == "checkbox") { 
            e.checked = (doSelect == 0 ? false : true); 
        } 
    } 
} 
function selectAllOutputCol(x) {
	var els = document.getElementsByName("outputCol");
	for ( var i = 0; i < els.length; i++) {
		var e = els[i];
		if (e.type == "checkbox") {
			e.checked = (x == 0 ? false : true);
		}
	}
}
function selectCountOutputCol(x) {
    selectAllOutputCol(0);
    var els = document.getElementsByName("outputCol");
    for ( var i = 0; i < els.length; i++) {
        var e = els[i];
	if (e.type == "checkbox" && !e.value.match(/_pc$/)
	&& !e.value.match(/percentage$/) && !e.value.match(/^phylum$/)
	&& !e.value.match(/^ir_class$/) && !e.value.match(/^ir_order$/)
	&& !e.value.match(/^family$/) && !e.value.match(/^genus$/)) {
	    e.checked = (x == 0 ? false : true);
	}
    }
}

function selectAllTaxonsIn(formName, doSelect) { 
    my_forms = document.getElementsByName(formName);
    var f = my_forms[0].taxon_filter_oid;
    f.checked = (doSelect == 0 ? false : true); 
    for ( var i = 0; i < f.length; i++) {
        var e = f[i]; 
        if (e.type == "checkbox") { 
            e.checked = (doSelect == 0 ? false : true); 
        } 
    } 
} 
function selectAllTaxons(x) {
	var f = document.mainForm.taxon_filter_oid;
	f.checked = (x == 0 ? false : true);
	for ( var i = 0; i < f.length; i++) {
		var e = f[i];
		if (e.type == "checkbox") {
			e.checked = (x == 0 ? false : true);
		}
	}
}

function selectTaxonRange(begin, end, value) {
	if (end == 0 && begin != 0) {
		end = document.mainForm.taxon_filter_oid.length;
	}
	for ( var i = begin; i <= end; i++) {
		document.mainForm.taxon_filter_oid[i].checked = value;
	}
}

function selectPhyloProfileErr(lineNo) {
	var f = document.mainForm;
	var i = (lineNo - 1) * 4;
	var e = f.elements[i];
	if (e.type == "radio") {
		e.checked = false;
	}
	alert("Please select an individual genome, not a group.");
}

function selectPhyloGroupProfile(begin, end, offset) {
	var f = document.mainForm;
	var count = 0;
	var idx1 = begin * 4;
	var idx2 = end * 4;
	for ( var i = idx1; i < f.length && i <= idx2; i++) {
		var e = f.elements[i];
		if (e.type == "radio" && i % 4 == offset) {
			e.checked = true;
		}
	}
}

function resetPreferences() {
	document.preferencesForm.maxParalogGroups.selectedIndex = 0;
	document.preferencesForm.maxGeneListResults.selectedIndex = 2;
	document.preferencesForm.maxHomologResults.selectedIndex = 1;
	document.preferencesForm.maxNeighborhoods.selectedIndex = 1;
	document.preferencesForm.minHomologPercentIdentity.selectedIndex = 2;
	//document.preferencesForm.genePageDefaultHomologs.selectedIndex = 0;
	document.preferencesForm.hideViruses.selectedIndex = 0;
	document.preferencesForm.hidePlasmids.selectedIndex = 0;
	document.preferencesForm.hideGFragment.selectedIndex = 0;
	document.preferencesForm.hideZeroStats.selectedIndex = 0;
	//document.preferencesForm.hideObsoleteTaxon.selectedIndex = 0;
	try {
	document.preferencesForm.userCacheEnable.selectedIndex = 0;
	} catch(err) {
	    // do nothing cache was not enbled in UI
	}

    try {
        document.preferencesForm.topHomologHideMetag.selectedIndex  = 1;
     } catch(err) {
            // do nothing
     }
	
	document.preferencesForm.genomeListColPrefs.selectedIndex = 1;
}

/*
 * Display tool tip for lists in search Keyword
 */
function showTip(oSel, sFldName) {
  var sTip = "One or more keywords separated by commas";
  if (oSel.children[oSel.selectedIndex].text.match(/list/))
	document.getElementsByName(sFldName)[0].title = sTip;
  else
	document.getElementsByName(sFldName)[0].title = "";
}

/*
 * Returns false if no genomes were selected; true otherwise
 */
function isGenomeSelected(tbl) {
    var nRows = 0;
    if (tbl == "") { //Not YUI table
	var chkTaxons = document.getElementsByName("taxon_filter_oid");
	if (chkTaxons != undefined) {
	    for (var i=0; i < chkTaxons.length; i++) {
		if (chkTaxons[i].checked)
		    nRows++;
	    }
	}
    } else { //checkboxes are in a YUI table
	nRows = eval("oIMGTable_" + tbl  + ".rows");
    }
    if (nRows < 1 ) {
        alert ("No genomes were selected.\n\n" +
	       "Please select one or more genomes and try again.");
        return false;
    } else {
        return true;
    }
}

/*
 * message file --------------------------------------------------------
 */
var messageSuccess = function(o) {
    var data = o.responseText;
    if(data != null && data != "" && data != undefined) {
        var div = document.getElementById('message_content_file');
        div.style.display = "block";
        div.innerHTML = o.responseText;
    }
}

/*
 * show no message on error - ken
 */
var messageFailure = function(o) {
    if (o.status == -1) {
        //alert("Connection Timeout: " + o.statusText);
    } else if (o.status == 0) {
        //alert("Server Error: " + o.statusText);
    } else {
        //alert("Failure: " + o.statusText);
    }
}

var messageCallback = {
    success : messageSuccess,
    failure : messageFailure,
    timeout : 60000
}

function messageFile(url) {
    var request = YAHOO.util.Connect.asyncRequest('GET', unescape(url),
            messageCallback);    
}

/*
 * --------- NEWS ----------------------------
 */
var newsSuccess = function(o) {
    var data = o.responseText;
    if(data != null && data != "" && data != undefined) {
        var div = document.getElementById('news_proportal');
        if(div != null && div != undefined) {
            div.innerHTML = o.responseText;
        }
    }
}

/*
 * show no message on error - ken
 */
var newsFailure = function(o) {
    if (o.status == -1) {
        //alert("Connection Timeout: " + o.statusText);
    } else if (o.status == 0) {
        //alert("Server Error: " + o.statusText);
    } else {
        //alert("Failure: " + o.statusText);
    }
}

var newsCallback = {
    success : newsSuccess,
    failure : newsFailure,
    timeout : 60000
}

function newsFile(url) {
    var request = YAHOO.util.Connect.asyncRequest('GET', unescape(url),
            newsCallback);    
}

function uploadFileName(tagId) {
    var oTag = document.getElementById(tagId);
    if (oTag) {
	if (oTag.value == "") {
            alert ("Please specify a file to be uploaded.");
	    oTag.click();
            return false;
	}
    }
    return true;
}

function setSectionAndPage(section, page) {
    document.mainForm.section.value = section;
    document.mainForm.page.value = page;
}



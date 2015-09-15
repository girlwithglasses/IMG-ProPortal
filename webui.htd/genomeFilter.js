//for genome filter

function detectBrowser() {
	/* onpopstate does not work in Firefox 4 and 5 
	if (YAHOO.env.ua.gecko) {          
    	var version = YAHOO.env.ua.gecko;   
        //window.alert("gecko version: " + version);   
      	if (version >= 1.93) { //Gecko engine supoort replaceState() from revision number 1.9.3   
        	return true;   
      	}   
      	else {   
        	var agent = navigator.userAgent;   
          	//window.alert(agent);   
          	if (agent.indexOf("rv:")!= -1) { //Gecko engine revision number   
            	var idx = agent.indexOf("rv:");   
                var versionString = agent.substring(idx);   
                //window.alert("versionString: " + versionString);   
                var versionStr = versionString.match(/(\d+\.\d+\S*)/);   
                //window.alert("versionStr: " + versionStr);   
                if (versionStr != null && versionStr.length > 0) {   
                	var vNums = versionStr[0].split(".");   
                    var vNumStr = vNums[0] + "."; 
					for (var i=1; i<vNums.length; i++) {
						var vNumsNew = vNums[i].match(/(\d+)/);
						//window.alert("vNumsNew: " + vNumsNew);
						vNumStr += vNumsNew[0];
						if (vNumsNew[0].length != vNums[i].length)
							break;
					}
					//window.alert("vNumStr: " + vNumStr);
					version = parseFloat(vNumStr);
					if (version >= 1.93) {
						return true;
					}
				}
			}
    	}
    }
    */
    /* onpopstate does not work in Chrome 4.0.249.89
    else if (YAHOO.env.ua.webkit) {
    	var version = YAHOO.env.ua.webkit;
		//window.alert("webkit version: " + version);
    	if (version >= 528) { //webkit engine supoort replaceState() from revision number 528
			return true;
    	}
    }
    */
	return false;
}
var isHTML5Supported = detectBrowser();
//window.alert("isHTML5Supported " + isHTML5Supported);

var statusArray = new Array(4);
for (var i=0; i <statusArray.length; i++) {
    statusArray[i]=new Array(2);
}
statusArray[0][0] = "both";
statusArray[0][1] = "[All]";
statusArray[1][0] = "Finished";
statusArray[1][1] = "[F]";
statusArray[2][0] = "Permanent Draft";
statusArray[2][1] = "[P]";
statusArray[3][0] = "Draft";
statusArray[3][1] = "[D]";

var domainArray = new Array(8);
for (var i=0; i <domainArray.length; i++) {
    domainArray[i]=new Array(2);
}
domainArray[0][0] = "All";
domainArray[0][1] = "(All)";
domainArray[1][0] = "Bacteria";
domainArray[1][1] = "(B)";
domainArray[2][0] = "Archaea";
domainArray[2][1] = "(A)";
domainArray[3][0] = "Eukaryota";
domainArray[3][1] = "(E)";
domainArray[4][0] = "Vir";
domainArray[4][1] = "(V)";
domainArray[5][0] = "Plasmid";
domainArray[5][1] = "(P)";
domainArray[6][0] = "GFragment";
domainArray[6][1] = "(G)";
domainArray[7][0] = "Microbiome";
domainArray[7][1] = "(*)";

var selectName = 'genomeFilterSelections';
var titleSplitSym = ':::';
var isSingleSelect = false;

function setSelectName(name) {
	selectName = name;
}

function setTitleSplitSym(sym) {
	titleSplitSym = sym;
}

function setSingleSelect() {
	isSingleSelect = true;
}

var scanArray = new Array(1);
for (var i=0; i <scanArray.length; i++) {
    scanArray[i]=new Array(3);
}
scanArray[0][0] = "(reads databases)"; //text to scan
scanArray[0][1] = "blastp"; //select options that permit scaning
scanArray[0][2] = "blastx";

function checkScan() {
	var toScanObj = document.getElementById('toScan');
	if (toScanObj != null) {
        var selectedVal = toScanObj.options[toScanObj.selectedIndex].value;
	    for (var i=0; i<scanArray.length; i++) {
            for (var j=1; j<scanArray[i].length; j++) {
	            if (selectedVal == scanArray[i][j]) {
	            	return scanArray[i][0];
	            }
            }
	    }
	}
    return '';
}

var showOrHideArray = new Array(1);
for (var i=0; i <showOrHideArray.length; i++) {
    showOrHideArray[i]=new Array(2);
}
showOrHideArray[0][0] = "giNo_list"; //select options that permit hiding
showOrHideArray[0][1] = "gene_oid_list";

function checkHide() {
	var toHideObj = document.getElementById('toHide');
	if (toHideObj != null) {
        var selectedVal = toHideObj.options[toHideObj.selectedIndex].value;
	    for (var i=0; i<showOrHideArray.length; i++) {
            for (var j=0; j<showOrHideArray[i].length; j++) {
	            if (selectedVal == showOrHideArray[i][j]) {
	            	return true;
	            }
            }
	    }
	}
    return false;
}

function getDisplayContent() {
	var status = document.getElementById('seqstatus');
    var statusVal = status.options[status.selectedIndex].value;
    var domain = document.getElementById('domainfilter');
    var domainVal = domain.options[domain.selectedIndex].value;
    //var taxonChoice = "myGenomes";
    
    var allTaxonsLineValue = "<option value='-1'>No genomes match filter criteria</option>";
    if (document.getElementById('allGenomes') != null 
    && document.getElementById('allGenomes').style.display == 'block') {
    	//taxonChoice = "allGenomes";
    	if (document.getElementById('allTaxons') != null) {
	        allTaxonsLineValue = document.getElementById('allTaxons').value;
    	}
    	else {
    	    //window.alert("allTaxons in allGenomes null");
    		return;
    	}
    } else if (document.getElementById('myGenomes') != null
    && document.getElementById('myGenomes').style.display == 'block') {
    	if (document.getElementById('myTaxons') != null) {
        	allTaxonsLineValue = document.getElementById('myTaxons').value;
    	}
    	else {
    	    //window.alert("myTaxons in myGenomes null");
    		return;
    	}
    }

    var text = allTaxonsLineValue;
    var done = 0;
    var scanText = checkScan();
    for (var i=0; i<statusArray.length; i++) {
        if (done == 1) {
            break;
        }
        for (var j=0; j<domainArray.length; j++) {
            //window.alert("i: " + i + "\nj: " + j);
            if (statusVal == statusArray[i][0] 
            && domainVal == domainArray[j][0]) {
                var splitValue = "";
                if (i != 0 || j != 0 || scanText != '') {
                    splitValue = allTaxonsLineValue.split("\n");
                }
                    
                text = "";
                if (i != 0 && j != 0) {
                    for (var k=0; k<splitValue.length; k++) {
                        if (splitValue[k].indexOf(statusArray[i][1]) >= 0 
                        && splitValue[k].indexOf(domainArray[j][1]) >= 0
                        && (scanText == '' || splitValue[k].indexOf(scanText) < 0)) {
                            text += splitValue[k];
                            text += "\n";
                        }
                    }
                }
                else if (i != 0 && j == 0) {
                    for (var k=0; k<splitValue.length; k++) {
                        if (splitValue[k].indexOf(statusArray[i][1]) >= 0
                        && (scanText == '' || splitValue[k].indexOf(scanText) < 0)) {
                            text += splitValue[k];
                            text += "\n";
                        }
                    }
                }
                else if (i == 0 && j != 0) {
                    for (var k=0; k<splitValue.length; k++) {
                        if (splitValue[k].indexOf(domainArray[j][1]) >= 0
                        && (scanText == '' || splitValue[k].indexOf(scanText) < 0)) {
                            text += splitValue[k];
                            text += "\n";
                        }
                    }
                }
                else {
                	if (scanText != '') {
                        for (var k=0; k<splitValue.length; k++) {
                            if (splitValue[k].indexOf(scanText) < 0) {
                                text += splitValue[k];
                                text += "\n";
                            }
                        }
                	}
                	else {
                		text = allTaxonsLineValue;
                	}
                }
                done = 1;
                break;
            }
        }
    }
	
    return text;
}

function populateTaxonOptions() {
	var text = getDisplayContent();
	//alert( "text = " + text );
	
    var selectText = "";
    if (isSingleSelect) {
		selectText += "<select name='" + selectName + "' size='10' style='resize:horizontal; max-width: 800px;' >";
    }
    else {
        selectText += "<span id='genomeListCounter' style='font-size: 12px;'></span><br/>";
    	selectText += "<select name='" + selectName + "' size='10' onChange='return genomeCountSelected();'  style='resize:horizontal; max-width: 800px; overflow:scroll;' multiple >";
    }
    selectText += text;
    selectText += "</select>";
    if (document.getElementById("taxonDisplayArea") != null) {
    	document.getElementById("taxonDisplayArea").innerHTML = selectText;
    }
    //window.alert("taxonChoice: " + taxonChoice + "\nstatus: " + statusVal + "\ndomain: " + domainVal + "\nGenome Number: " + document.mainForm.elements['genomeFilterSelections'].options.length);
}

function buildTaxonTree() {
	var text = getDisplayContent();
	//alert( "text = " + text );

	var dataObj = {category:[{name:'domain', value:[]}]};
	var cObjs = dataObj.category;
	var vObjs = cObjs[0].value;
	var splitValue = text.split("\n");
	if (text != '' && splitValue.length > 0) {
	    for (var k = 0; k < splitValue.length; k++) {
	    	if (splitValue[k] == '' || splitValue[k].length == 0) {
	    		continue;
	    	}
	    	
	        var ranks;
	    	var idx1 = splitValue[k].indexOf("title=");
	    	var idx2 = splitValue[k].indexOf("value=");
	        if (idx1 >= 0 && idx2 >= 0 && idx1 < idx2) {
	        	var title = splitValue[k].substring(idx1+7, idx2-2);
	        	title = unescape(title);
	        	ranks = title.split(titleSplitSym);
	        }

	        var taxonName;
	    	var idx3 = splitValue[k].indexOf(">");
	    	var idx4 = splitValue[k].indexOf("</option>");
	        if (idx3 >= 0 && idx4 >= 0 && idx3 < idx4) {
	        	taxonName = splitValue[k].substring(idx3+1, idx4);
	        }

	        var taxonOid;
	        if (idx2 >= 0 && idx3 >= 0 && idx2 < idx3) {
	        	taxonOid = splitValue[k].substring(idx2+7, idx3-1);
	        }

	        if (ranks != null && taxonName != null && taxonOid != null) {
	        	var vAdded = 0;
	        	var numValues = vObjs.length;
	        	for ( var m = 0 ; m < numValues ; m++ ) {
	                if (ranks[0] == vObjs[m].label) {
	                	var upChildrenObj = vObjs[m];
	            	    //alert("start upChildrenObj = " + YAHOO.lang.JSON.stringify(upChildrenObj));
	             	    for (var i = 1; i < ranks.length; i++) {
	                    	var childrenAdded = 0;
	                    	var childrenObj = upChildrenObj.children;
	                	    //alert("childrenObj " + i + " = " + YAHOO.lang.JSON.stringify(childrenObj));
	                    	var numChildrenObjs = childrenObj.length;
	                    	for ( var n = 0 ; n < numChildrenObjs ; n++ ) {
	                    	    //alert("ranks[" + i + "] = " + ranks[i] + "\nchildrenObj[" + n + "].label = " + YAHOO.lang.JSON.stringify(childrenObj[n].label));
	                            if (ranks[i] == childrenObj[n].label) {
	                            	upChildrenObj = childrenObj[n];
	                            	childrenAdded = 1;
	                        	    break;
	                            }
	                    	}

	                    	if (childrenAdded == 0) {
	        	        		var data = getPackedData(taxonOid, taxonName, ranks, i, 0);
	                    	    //alert("upChildrenObj = " + YAHOO.lang.JSON.stringify(upChildrenObj));
	                    	    //alert("data = " + YAHOO.lang.JSON.stringify(data));
	                    	    upChildrenObj.children.push(data);
	                    	    break;
	                        }
	                        else {
	                            if (i == ranks.length - 1) {
		        	        		var data = getPackedData(taxonOid, taxonName, ranks, i, 1);
	                        	    upChildrenObj.children.push(data);
	                            }
	                        }
	            	    }
	            	    vAdded = 1;
	                	break;
	                }
	        	}
	        	
	        	if (vAdded == 0) {
	        		var data = getPackedData(taxonOid, taxonName, ranks, 0, 0);
	        		vObjs.push(data);
	        	}
	        } 
	        //if (k < 3) {
	    	//	alert( "splitValue[" + k + "] = " + splitValue[k] + "\ndataObj = " + YAHOO.lang.JSON.stringify(dataObj));
	    	//}
	                
	    }
	}
    //alert("dataObj = " + YAHOO.lang.JSON.stringify(dataObj));

    var selectText = "";
	selectText += "<p>";
	var cObjs = dataObj.category;
	var numCategories = cObjs.length;
	if (numCategories > 0){
	    if (document.getElementById('treeButtons') != null 
	    && document.getElementById('treeButtons').style.display == 'none') {
	    	document.getElementById('treeButtons').style.display = 'block';
	    }
		for ( var m = 0 ; m < numCategories ; m++ ) {
			var cName = cObjs[m].name;
		    if (isSingleSelect) {
		    	selectText += "<div id='" + cName + "'></div>\n";
		    }
		    else {
		    	selectText += "<div id='" + cName + "' class='ygtv-checkbox'></div>\n";
		    }
		}
	}
	else {
	    if (document.getElementById('treeButtons') != null 
	    && document.getElementById('treeButtons').style.display == 'block') {
	    	document.getElementById('treeButtons').style.display = 'none';
	    }
		selectText += "No genomes match filter criteria";
	}
    selectText += "</p>";
    if (document.getElementById("taxonDisplayArea") != null) {
        document.getElementById("taxonDisplayArea").innerHTML = selectText;
    }
    
    setJSObjects(dataObj);
    treeInit();
}

function getPackedData(taxonOid, taxonName, ranks, startIdx, isTaxonOnly) {
	var data = {};
    if (isSingleSelect) {
    	data.label = "<input type='radio' title=\"" + taxonName + "\" name='" + selectName + "' value='" + taxonOid + "' />" + taxonName;
    }
    else {
    	data.id = taxonOid;
    	data.label = taxonName;
    }	
	if (isTaxonOnly == 0) {
	    for (var j = ranks.length - 1; j >= startIdx; j--) {
	    	var newData = {};
	    	//newData.level = j;
	    	//newData.label = '<b>' + ranks[j] + '</b>'; too much time cost on expand/collapse
	    	newData.label = ranks[j];
	    	newData.children = [data];
	    	data = newData;
	    }
	}
    return data;
}

function determineDisplayType() {
	//alert( "into determineDisplayType" );

	var radioVal = "";
	var radioObj = document.mainForm.elements['displayType'];
	if (radioObj != null) {
		var radioLength = radioObj.length;
		//alert( "radioLength = " + radioLength);
		for (var i = 0; i < radioLength; i++) {
			if(radioObj[i].checked) {
				radioVal = radioObj[i].value;
				//alert( "radioVal = " + radioVal );
				break;
			}
		}	
	}
	
	if (radioVal == "tree") {
		buildTaxonTree(); 
	}
	else {
	    if (document.getElementById('treeButtons') != null 
	    && document.getElementById('treeButtons').style.display == 'block') {
	    	document.getElementById('treeButtons').style.display = 'none';
	    }
		populateTaxonOptions();
	}

	if (document.getElementById('genomeFilterArea') != null) {
	    var toHide = checkHide();
		if (toHide) {
	    	document.getElementById('genomeFilterArea').style.display = 'none';
		}
		else {
	    	document.getElementById('genomeFilterArea').style.display = 'block';
		}
	}

}

YAHOO.util.Event.on("toHideFalse", "change", function(e) {
	determineDisplayType();
});

YAHOO.util.Event.on("toHide", "change", function(e) {
	determineDisplayType();
});

YAHOO.util.Event.on("toScan", "change", function(e) {
	determineDisplayType();
});

YAHOO.util.Event.on("seqstatus", "change", function(e) {
	determineDisplayType();
});

YAHOO.util.Event.on("domainfilter", "change", function(e) {
	determineDisplayType();
});

YAHOO.util.Event.on("displayType1", "click", function(e) {
	determineDisplayType();
});

YAHOO.util.Event.on("displayType2", "click", function(e) {
	determineDisplayType();
});

//handle reset
YAHOO.util.Event.on("reset", "click", function(e) {
    if (document.getElementById('displayType1') != null) {
    	document.getElementById('displayType1').checked = true;
    }
	//setTimeout("populateTaxonOptions()", 1000);
	loadState("");
	clearProfileTaxonOidSelections();
});

function clearProfileTaxonOidSelections() {
    if ( document.mainForm.minPercIdent != null ) {
        document.mainForm.minPercIdent.selectedIndex = 0;
    }
    if ( document.mainForm.maxEvalue != null ) {
        document.mainForm.maxEvalue.selectedIndex = 0;
    }
    if ( document.mainForm.znorm != null ) {
        document.mainForm.znorm.checked = false;
    }
    if ( document.mainForm.orthologs != null ) {
        document.mainForm.orthologs.checked = false;
    }
}

function showAllGenomes(url) {
	if (document.getElementById('allGenomes') == null) {
		return;
	}

	if (document.getElementById('allGenomes').innerHTML == "") {
		showDiv('allGenomes', url);
	} else {
		document.getElementById('myGenomes').style.display = 'none';
		document.getElementById('allGenomes').style.display = 'block';
		document.getElementById('taxonChoice').value = 'All';
		determineDisplayType();
	}
}

function showSelectedGenomes(url) {
	if (document.getElementById('myGenomes') == null) {
		return;
	}

	if (document.getElementById('myGenomes').innerHTML == "") {
		showDiv('myGenomes', url);
	} else {
		document.getElementById('myGenomes').style.display = 'block';
		document.getElementById('allGenomes').style.display = 'none';
		document.getElementById('taxonChoice').value = 'Selected';
		determineDisplayType();
	}
}

function showDiv(id, url) {
    YAHOO.namespace("example.container");
    if (!YAHOO.example.container.wait) { 
    	initializeWaitPanel(); 
    } 
 
    var callback = {
    	success: handleSuccess,
        failure: function(req) { 
        	YAHOO.example.container.wait.hide();
        },
        argument: id
    };
            
    if (url != null && url != "") {
		//window.alert("showDiv url=" + url);
        YAHOO.example.container.wait.show(); 
        var request = YAHOO.util.Connect.asyncRequest('GET', url, callback);
    } 
}

function handleSuccess(req) {
    try { 
    	id = req.argument;
		//window.alert("handleSuccess id=" + id);
        response = req.responseXML.documentElement;
        var html = response.getElementsByTagName('div')[0].firstChild.data;
		//window.alert("handleSuccess html=\n" + html);
        document.getElementById(id).innerHTML = html;
        document.getElementById(id).style.display = 'block';
        if (id == "allGenomes") {
	        document.getElementById('myGenomes').style.display = 'none';
			document.getElementById('taxonChoice').value = 'All';
        }
        else if (id == "myGenomes") {
	        document.getElementById('allGenomes').style.display = 'none';
			document.getElementById('taxonChoice').value = 'Selected';
        }
        //populateTaxonOptions();
        determineDisplayType();
    } catch(e) {
    	//window.alert(e);
    }
    YAHOO.example.container.wait.hide();
}

var stateSplitSym = " :: ";
var dState = "myGenomes";
if (typeof(isAllState) != "undefined" && isAllState) {
	dState = "allGenomes";
}
var defaultState = dState + stateSplitSym + statusArray[0][0] + stateSplitSym + domainArray[0][0];

function getDisplayState() {
    var taxonChoice = '';
	if (typeof(isAllState) != "undefined" && isAllState) {
	    taxonChoice = 'allGenomes';
	    if (document.getElementById('myGenomes') != null
	    && document.getElementById('myGenomes').style.display == 'block') {
	    	taxonChoice = 'myGenomes';
	    } 
	}
	else {
	    var taxonChoice = 'myGenomes';
	    if (document.getElementById('allGenomes') != null
	    && document.getElementById('allGenomes').style.display == 'block') {
	    	taxonChoice = 'allGenomes';
	    }
	}
	
    var statusVal = statusArray[0][0];
	var status = document.getElementById('seqstatus');
	if (status != null 
	&& status.options[status.selectedIndex].value != ""){
	    statusVal = status.options[status.selectedIndex].value;		
	}

    var domainVal = domainArray[0][0];
    var domain = document.getElementById('domainfilter');
    if (domain != null 
    && domain.options[domain.selectedIndex].value != "") {
        domainVal = domain.options[domain.selectedIndex].value;
    }

    var displayState = taxonChoice + stateSplitSym + statusVal + stateSplitSym + domainVal;
    return displayState;
}

//load and display the specified state in the page.
function getTranslatedState(splitValue) {
	var taxonChoice = splitValue[0];
	if (typeof(isAllState) != "undefined" && isAllState) {
		if (taxonChoice == "myGenomes") {
	    	taxonChoice = "Selected Genomes"
	    }
	    else {
	    	taxonChoice = "All Genomes"
	    }
	}
	else {
		if (taxonChoice == "allGenomes") {
	    	taxonChoice = "All Genomes"
	    }
	    else {
	    	taxonChoice = "Selected Genomes"
	    }
	}
    
    var seqstatus = splitValue[1];
    for (var i=0; i<statusArray.length; i++) {
    	if (seqstatus == statusArray[i][0]) {
    		seqstatus = statusArray[i][1];
    	}
    }
    
    var domainfilter = splitValue[2];
    for (var i=0; i<domainArray.length; i++) {
    	if (domainfilter == domainArray[i][0]) {
    		domainfilter = domainArray[i][1];
    	}
    }
    
    return taxonChoice + " " + seqstatus + " " + domainfilter;
}

//load and display the specified state in the page.
function loadState(state) {
	//window.alert("loadState: " + state);

	if (state == null || state == "" || state.split(stateSplitSym).length != 3) {
		state = defaultState;
	}
    var splitValue = state.split(stateSplitSym);
	
    var orgTitle = document.title;
    var idx = orgTitle.indexOf(stateSplitSym);
    if (idx >=0 ) {
    	orgTitle = orgTitle.substring(0, idx);
    }
    //document.title = orgTitle + stateSplitSym + getTranslatedState(splitValue);

    var taxonChoice = splitValue[0];
	if (typeof(isAllState) != "undefined" && isAllState) {
	    if (taxonChoice == 'myGenomes') {
	    	clickShowButton('myGenomes')
	    }
	    else {
	    	var url = "xml.cgi?section=genomeListFilter&page=allGenomes";
	    	showAllGenomes(url);
	    }
	}
	else {
	    if (taxonChoice == 'allGenomes') {
	    	//var url = "xml.cgi?section=genomeListFilter&page=allGenomes";
	    	//showAllGenomes(url); //doesn't work
	    	clickShowButton('allGenomes')
	    }
	    else {
	    	var url = "xml.cgi?section=genomeListFilter&page=myGenomes";
	    	showSelectedGenomes(url);
	    }
	}
    
	if (document.getElementById('seqstatus') == null || document.getElementById('domainfilter') == null) {
		return;
	}    
    
    var seqstatus = splitValue[1];
	var status = document.getElementById('seqstatus');
    var statusVal = status.options[status.selectedIndex].value;
    if (statusVal != seqstatus) {
    	for (i=0; i<status.length;i++) {
	    	if (status.options[i].value == seqstatus) {
	    		status.options[i].selected = true;
	    	}
    	}
    }

    var domainfilter = splitValue[2];
    var domain = document.getElementById('domainfilter');
    var domainVal = domain.options[domain.selectedIndex].value;
    if (domainVal != domainfilter) {
    	for (i=0; i<domain.length;i++) {
	    	if (domain.options[i].value == domainfilter) {
	    		domain.options[i].selected = true;
	    	}
    	}
    }

    determineDisplayType();
}

function clickShowButton(type) {
	var buttonID = '';
	var taxonChoiceValue = '';
	if (type == 'allGenomes') {
		buttonID = 'showAllGenomesButton';
		taxonChoiceValue = 'All';
	}
	else if (type == 'myGenomes') {
		buttonID = 'showSelectedGenomesButton';
		taxonChoiceValue = 'Selected';
	}
	
	if (document.getElementById(buttonID) != null) {
		document.getElementById('taxonChoice').value = taxonChoiceValue;
		if (document.getElementById(buttonID).dispatchEvent) {
			var e = document.createEvent("MouseEvents"); 
			e.initEvent("click", true, true);
			document.getElementById(buttonID).dispatchEvent(e); 
		} else {
			document.getElementById(buttonID).click(); 
		}
	}
}

function handleNavigation() {
    var newState = getDisplayState();

    if (isHTML5Supported) {
	    var stateObj = newState;
	    var splitValue = newState.split(stateSplitSym);
	    var titleState = getTranslatedState(splitValue);
	    var currentState = "";
	    var orgTitle = document.title;
	    var idx = orgTitle.indexOf(stateSplitSym);
	    if (idx >=0 ) {
	    	orgTitle = orgTitle.substring(0, idx);
	    	currentState = orgTitle.substring(idx + 4);
	    }
	    if (titleState != currentState ) {
	        newTitle = orgTitle + stateSplitSym + titleState;
	    	window.history.replaceState(stateObj, newTitle);
	    }
    } else {
        try {
    	    var currentState = YAHOO.util.History.getCurrentState("genomeListFilter");
    	    if (currentState == null || currentState == "" || newState != currentState ) {
    	    	//window.alert("currentState: " + currentState + "\nnewState: " + newState);
    	    	YAHOO.util.History.navigate("genomeListFilter", newState );
    		    //window.alert("bookmarkedState: " + YAHOO.util.History.getBookmarkedState("genomeListFilter"));
    	    }
        } catch(e) {
        	//window.alert(e);
        }
    }

}

if (isHTML5Supported) {
	window.onpopstate = function(event) {
		//alert("title: " + document.title + ", state: " + JSON.stringify(event.state));
		var state = JSON.stringify(event.state);
		if (state != null) {
			state = state.substring(1, state.length - 1);
		}
		loadState(state);
	};
}
else {
	var bookmarkedState = YAHOO.util.History.getBookmarkedState("genomeListFilter");
	var initialState = bookmarkedState || defaultState; 
	//window.alert("bookmarkedState: " + bookmarkedState + "<br/>defaultState: " + defaultState + "<br/>initialState: " + defaultState);

	// Register the module
	YAHOO.util.History.register("genomeListFilter", initialState, function(state) {
	    // Update the UI of your module according to the "state" parameter
	    loadState(state);
	});

	//Use the Browser History Manager onReady method to initialize the application.
	YAHOO.util.History.onReady(function () {
	    try {
	    	var currentState = YAHOO.util.History.getCurrentState("genomeListFilter");
	    	//window.alert("OnReady currentState: " + currentState);
		    loadState(currentState);
	    } catch(e) {
	    	//window.alert(e);
	    }
	});

	// Initialize the browser history management library.
	if (typeof(hasYuiTable) != "undefined" && hasYuiTable) {
		//sacrifice history management
	}
	else {
		try {
			YAHOO.util.History.initialize("genomeListFilter-history-field", "genomeListFilter-history-iframe");
		} catch (e) {
			//window.alert(e);
		}		
	}
}

window.onbeforeunload = function() {
	handleNavigation();
}


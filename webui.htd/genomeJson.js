// store the json object of genome list
var taxonsList;
// yui root tree node
var tree1;
/**
 * Sort by taxon name
 * 
 * @param a
 * @param b
 * @returns {Number}
 */
function Comparator(a, b) {
    if (a[1] < b[1])
        return -1;
    if (a[1] > b[1])
        return 1;
    return 0;
}

/**
 * Genome list selection update the number of user selected genomes
 * 
 * @returns {Boolean}
 */
function genomeCountSelected(form_id) {
    var f = document.getElementById('displayType2').checked;
    var oList = document.getElementById("genomeListCounter");
    var el = document.getElementById("genomelist");

    if (form_id !== undefined && form_id != '' && form_id != null) {
        var startElement = document.getElementById(form_id);

        var els = startElement.getElementsByTagName("span");
        for (var i = 0; i < els.length; i++) {
            var e = els[i];
            if (e.id == "genomeListCounter") {
                oList = e;
            }
        }
        var els = startElement.getElementsByTagName("select");
        for (var i = 0; i < els.length; i++) {
            var e = els[i];
            if (e.id == "tax") {
                tax_selectorEl = e;
            }
        }
	var els = startElement.getElementsByTagName("input");
	for (var i = 0; i < els.length; i++) {
	    var e = els[i];
	    if (e.id == "displayType2") {
		f = e.checked;
	    }
	}
    }

    if (f) {
        // tree
        //alert('here in tree');
    } else {

        if (el == null) {
            el = document.mainForm.referenceGenomes;
        }
        if (el == null) {
            el = document.mainForm.genomesToSelect;
        }
        if (el == null) {
            el = document.mainForm.queryGenomes;
        }
        if (el == null) {
            el = document.mainForm.imgBlastDb;
        }
        if (el == null) {
            return true;
        }
    }

    if (oList == null) {
        return true;
    }
    var cnt = getSelectedGenomeCount(form_id);
    if (cnt > 0) {
        oList.innerHTML = "Selected: " + cnt;
    } else {
        oList.innerHTML = "";
    }
}
/**
 * gets number of selected genomes
 */
function getSelectedGenomeCount(form_id) {
    var cnt = 0;
    var f = document.getElementById('displayType2').checked;
    var myForm = document.mainForm;

    if (form_id !== undefined && form_id != '' && form_id != null) {
        myForm = document.getElementById(form_id);
        var startElement = document.getElementById(form_id);
        var els = startElement.getElementsByTagName("input");
        for (var i = 0; i < els.length; i++) {
            var e = els[i];
            if (e.id == "displayType2") {
                f = e.checked;
            }
        }
    }
    if (f) {
        // tree
        if (tree1 === undefined || tree1 == null) {
            return 0;
        }
        var hiLit = tree1.getNodesByProperty('highlightState', 1);
        if (YAHOO.lang.isNull(hiLit)) {
            return 0;
        } else {
            for ( var i = 0; i < hiLit.length; i++) {
                if (hiLit[i].children == '') {
                    // leaf node
                    cnt++;
                }
            }
        }
    } else {
        var el = myForm.genomeFilterSelections;
        if (el == null || el === undefined) {
            return 0;
        }
        for ( var i = 0; i < el.options.length; i++) {
            if (el.options[i].selected) {
                cnt++;
            }
        }
    }
    return cnt;
}
/**
 * Custom form submit. For tree view find all users genomes and create hidden
 * inputs in div hiddenlist
 * 
 * @param section
 * @param page
 * @returns {Boolean}
 */
function mySubmitJson(section, page, form_id) {
    var myForm = document.mainForm;

    if (form_id === undefined) { form_id = ''; }
    var f = document.getElementById('displayType2').checked;
    var asid = "myGenomeSearchInput"+form_id;
    var autoselect1 = document.getElementById(asid);

    if (form_id !== undefined && form_id != '' && form_id != null) {
        myForm = document.getElementById(form_id);
        var startElement = document.getElementById(form_id);
        var els = startElement.getElementsByTagName("input");
        for (var i = 0; i < els.length; i++) {
            var e = els[i];
            if (e.id == "displayType2") {
                f = e.checked;
            }
            else if (e.id == asid) {
                autoselect1 = e;
            }
	}
    }

    if (section != '') {
        myForm.section.value = section;
    }
    if (page != '') {
        myForm.page.value = page;
        var paramMatchJson = document.getElementById("paramMatchJson");
        paramMatchJson.value = page;
        paramMatchJson.name = page;
    }
    if (f) {
        // tree
        if (tree1 === undefined || tree1 == null) {
            alert('Please select a genome - (tree1)');
            return true;
        }
        var hiLit = tree1.getNodesByProperty('highlightState', 1);
        var hiddenDiv = document.getElementById("hiddenlist");
        if (YAHOO.lang.isNull(hiLit)) {
            alert('Please select a genome - (tree2)');
            return true;
        } else {
            var str = ''; // define it s.t. the undefined is not printed in
            // the ui
            for ( var i = 0; i < hiLit.length; i++) {
                if (hiLit[i].children == '') {
                    // leaf node
                    str += "<input type='hidden' "
			+ "name='genomeFilterSelections' value='"
			+ hiLit[i].labelElId + "'> ";
                }
            }
            hiddenDiv.innerHTML = str;
        }

    } else if (autoselect1 != null && autoselect1 !== undefined &&
               autoselect1 != '' &&
               autoselect1.value !== undefined &&
               autoselect1.value != '') {
	// got an autocomplete value
    } else {
        // list
        var cnt = getSelectedGenomeCount(form_id);
        if (cnt == 0) {
            alert('Please select a genome - (list)');
            return true;
        }
    }
    myForm.submit();
}

/*
 * if no genomes select then blast all
 */
function mySubmitJsonBlast(section, page) {
    if (section != '') {
        document.mainForm.section.value = section;
    }
    if (page != '') {
        document.mainForm.page.value = page;
        var paramMatchJson = document.getElementById("paramMatchJson");
        paramMatchJson.value = page;
        paramMatchJson.name = page;
    }
    var f = document.getElementById('displayType2').checked;
    if (f) {
        // tree
        if (tree1 === undefined || tree1 == null) {
            //alert('Please select a genome - (tree1)');
            //return true;
	    document.mainForm.submit();
        }
        var hiLit = tree1.getNodesByProperty('highlightState', 1);
        var hiddenDiv = document.getElementById("hiddenlist");
        if (YAHOO.lang.isNull(hiLit)) {
            //alert('Please select a genome - (tree2)');
            //return true;
        	 document.mainForm.submit();
        } else {
            var str = ''; // define it s.t. the undefined is not printed in
            // the ui
            for ( var i = 0; i < hiLit.length; i++) {
                if (hiLit[i].children == '') {
                    // leaf node
                    str += "<input type='hidden' name='genomeFilterSelections' value='"
                            + hiLit[i].labelElId + "'> ";
                }
            }
            hiddenDiv.innerHTML = str;
        }
    } else {
        // list
        var cnt = getSelectedGenomeCount();
        if (cnt == 0) {
            //alert('Please select a genome - (list)');
            //return true;
	    document.mainForm.submit();
        }
    }
    document.mainForm.submit();
}

/**
 * User presses the "Show" button
 * 
 * @param baseUrl
 * @param prefix
 *            "t:" or "b:" without quotes
 * @param from - which form the call can from optional
 * @returns {Boolean}
 */
function printSelectType(xmlCgiUrl, prefix, style, from, form_id) {
    // reset user selected count
    var seqstatus;
    var file;
    var showButtonEl;
    var blast;
    var f = false;
    var tax_selectorEl;

    if (form_id !== undefined && form_id != '' && form_id != null) {
	var startElement = document.getElementById(form_id);
	var els = startElement.getElementsByTagName("span");
	for (var i = 0; i < els.length; i++) {
	    var e = els[i];
	    if (e.id == "genomeListCounter") {
		e.innerHTML = "";
	    }
	}
	var els = startElement.getElementsByTagName("select");
	for (var i = 0; i < els.length; i++) {
	    var e = els[i];
	    if (e.id == "seqstatus") {
		seqstatus = e.options[e.selectedIndex].value;
	    }
	    else if (e.id == "domainfilter") {
		file = e.options[e.selectedIndex].value;
	    }
	    else if (e.id == "tax") {
		tax_selectorEl = e;
	    }
	}
        var els = startElement.getElementsByTagName("input");
        for (var i = 0; i < els.length; i++) {
            var e = els[i];
            if (e.id == "showButton") {
                showButtonEl = e;
            }
	    else if (e.id == "blastTaxonOid") {
		blast = e;
	    } 
	    else if (e.id == "displayType2") {
		f = e.checked;
	    }
        }

    } else {
	var oList = document.getElementById("genomeListCounter");
	oList.innerHTML = "";
	var e = document.getElementById("seqstatus");
	seqstatus = e.options[e.selectedIndex].value;
	var e = document.getElementById("domainfilter");
	file = e.options[e.selectedIndex].value;

	showButtonEl = document.getElementById("showButton");
	blast = document.getElementById("blastTaxonOid");
	f = document.getElementById('displayType2').checked;
        tax_selectorEl = document.getElementById('tax');
    }

    var dt = 'list';
    if (f) {
        dt = 'tree';
    } else {
        if (tree1 != null) {
            tree1.destroy();
        }
        tree1 = null;
    }

    var url = xmlCgiUrl + "?section=GenomeListJSON&page=json&displayType=" + dt
            + "&domainfilter=" + file + "&seqstatus=" + seqstatus;

    if (from != '' && from != null) {
        url = url + "&from=" + from;
    }

    showButtonEl.style.cursor = "wait";
    //document.body.style.cursor = "wait";

    var callbacks = {
        success : function(o) {
            try {
                taxonsList = YAHOO.lang.JSON.parse(o.responseText);
                if (f) {
                    printTree(prefix, form_id);
                } else {
                    printSelect(prefix, style, form_id);
                    
                    // is the BLAST coming from a genome detail page?
                    if (blast  !== undefined && blast != null) {
                        selectItemByValue(tax_selectorEl, blast.value);
                    }
                    
                }
                cartSelectAll(file, f, form_id);
                showButtonEl.style.cursor = "default";
		//document.body.style.cursor = "default";
            } catch (x) {
                alert("JSON Parse failed! " + x);
                alert(o.responseText);
                showButtonEl.style.cursor = "default";
                //document.body.style.cursor = "default";
                return;
            }
        },
        failure : function(o) {
            if (!YAHOO.util.Connect.isCallInProgress(o)) {
                alert("Async call failed!");
                alert(o.responseText);
            }
            showButtonEl.style.cursor = "default";
	    //document.body.style.cursor = "default";
        },
        timeout : 60000
    }
    // Make the call to the server for JSON data
    YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
}

function cartSelectAll(file, listOrTree, form_id) {
    if (file == 'cart') {
        var selectBox = document.getElementById('selectedGenome1');
        if (selectBox !== undefined && selectBox != null) {
	    // this is XDiv form
	    return;
        } 	
    	
    	if (listOrTree) {
	    // tree
    	} else {
	    // list - 'genomeFilterSelections'
            var selectBox = document.getElementById('tax');
	    if (form_id !== undefined && form_id != '' && form_id != null) {
		var startElement = document.getElementById(form_id);
		for (var i = 0; i < els.length; i++) {
		    var e = els[i];
		    if (e.id == "tax") {
			selectBox = e;
		    }
		}
	    }

            if (selectBox == null) {
                return;
            }
            if (selectBox.options.length < 1) {
                return;
            } else { 
                for (var i = 0; i < selectBox.options.length; i++) { 
                     selectBox.options[i].selected = true;
                } 
            }
    	}
    	genomeCountSelected(form_id);
    }
}

function findMatch(val, form_id) {
    var genomeList = document.getElementById("tax");
    var oList = document.getElementById("genomeListCounter");
    if (form_id !== undefined && form_id != '' && form_id != null) {
        var startElement = document.getElementById(form_id);
        var els = startElement.getElementsByTagName("select");
        for (var i = 0; i < els.length; i++) {
            var e = els[i];
	    if (e.id == "tax") {
                genomeList = e;
            }
        }
        var els = startElement.getElementsByTagName("span");
        for (var i = 0; i < els.length; i++) {
            var e = els[i];
            if (e.id == "genomeListCounter") {
                oList = e;
            }
        }
    }

    if (genomeList == null) {
	return;
    }

    if (genomeList.options.length < 1) {
	return;
    } else {
	var count = 0;
	for (var i = 0; i < genomeList.options.length; i++) {
	    var option = genomeList.options[i];
	    if (val.trim() == '') {
		option.selected = false;
		continue;
	    }
	    if (option.text.toLowerCase().indexOf(val.toLowerCase()) != -1) {
		option.selected = true;
		count++;
	    } else {
		option.selected = false;
	    }
	}

	//var oList = document.getElementById("genomeListCounter");
	if (oList == null) {
	    return true;
	}
	if (count > 0) {
	    oList.innerHTML = "Selected: " + count;
	} else {
	    oList.innerHTML = "";
	}
    }
 
}

/**
 * print genome list view
 */
function printSelect(prefix, style, form_id) {
    if (style === undefined || style == null || style == '') {
        style = 'resize: horizontal; width: 600px; overflow:scroll;';
    }
    var s = document.getElementById("domainfilter");
    var d = s.options[s.selectedIndex].value;

    if (form_id === undefined) { form_id = ''; }
    var acid = "myAutoCompleteX"+form_id;
    var ac = document.getElementById(acid);
    var genomelistEl = document.getElementById("genomelist");
    var treeid = "treeDiv1"+form_id;
    var treedivEl = document.getElementById(treeid);

    if (form_id !== undefined && form_id != '' && form_id != null) {
        var startElement = document.getElementById(form_id);
        var els = startElement.getElementsByTagName("span");
        for (var i = 0; i < els.length; i++) {
            var e = els[i];
            if (e.id == "genomeListCounter") {
                e.innerHTML = "";
            }
        }
        var els = startElement.getElementsByTagName("select");
        for (var i = 0; i < els.length; i++) {
            var e = els[i];
            if (e.id == "domainfilter") {
                d = e.options[e.selectedIndex].value;
            }
        }
        var els = startElement.getElementsByTagName("div");
        for (var i = 0; i < els.length; i++) {
            var e = els[i];
            if (e.id == "genomelist") {
                genomelistEl = e;
            }
            else if (e.id == acid) {
                ac = e;
            }
            else if (e.id == treeid) {
		treedivEl = e;
	    }
        }
    }

    if (form_id === undefined) { form_id = ''; }
    var text = "<div style='width:100%;display:table; font-family: Helvetica, Arial, sans-serif; font-size: 12px;'><label style='display:table-cell;white-space: nowrap; width:1%;'>Search for: </label><span style='display:table-cell;padding:0 0 0 5px;' ><input type='text' id='searchField' placeholder='<enter a genome name to search>' onkeyup='findMatch(this.value, \""+form_id+"\")' style='width:99%;' /></span></div>";

    var genomeFilterSelections = 'genomeFilterSelections';
    text += "<select id='tax' size='10'  style='" + style  
	+ "' name='" + genomeFilterSelections
	+ "' onchange='return genomeCountSelected(\"" 
	+ form_id + "\");'  multiple='multiple'>";

    var cnt = 0;
    // sort by taxon name if d != All
    // if (d != 'All') {
    // taxonsList = taxonsList.sort(Comparator);
    // }
    for ( var i = 0; i < taxonsList.length; i++) {
        var taxon_oid = prefix + taxonsList[i][0];
        var taxon_name = taxonsList[i][1];
        var domain = taxonsList[i][2];
        var phylum = taxonsList[i][3];
        var ir_class = taxonsList[i][4];
        var ir_order = taxonsList[i][5];
        var family = taxonsList[i][6];
        var genus = taxonsList[i][7];
        var species = taxonsList[i][8];
        var seq_status = taxonsList[i][9]; // Draft, Finished, Permanent Draft
        var sub = domain.substring(0, 1);
        var sub2 = seq_status.substr(0, 1);
        cnt++;
        var title = taxon_name + ' (' + sub + ') [' + sub2 + ']';
        text += "<option value='" + taxon_oid + "' title='" + title + "'>";
        text += taxon_name + ' (' + sub + ') [' + sub2 + ']';
        text += "</option>";
    }
    text += "</select>";

    if (ac !== undefined && ac != '' && ac != null) {
	ac.style.display = "block";
    }

    genomelistEl.innerHTML = text;
    treedivEl.innerHTML = "";
}
/**
 * expand tree
 */
function myExpandAll() {
    document.getElementById("expandAll").style.cursor = "wait";
    document.body.style.cursor = "wait";
    tree1.expandAll();
    document.getElementById("expandAll").style.cursor = "default";
    document.body.style.cursor = "default";
}
/**
 * collapse tree
 */
function myCollapseAll() {
    document.getElementById("collapseAll").style.cursor = "wait";
    document.body.style.cursor = "wait";
    tree1.collapseAll();
    document.getElementById("collapseAll").style.cursor = "default";
    document.body.style.cursor = "default";
}
/**
 * print tree view
 */
function printTree(prefix, form_id) {
    if (form_id === undefined) { form_id = ''; }

    var g = document.getElementById("genomelist");
    var acid = "myAutoCompleteX"+form_id;
    var ac = document.getElementById(acid);

    if (form_id !== undefined && form_id != '' && form_id != null) {
        var startElement = document.getElementById(form_id);
        var els = startElement.getElementsByTagName("div");
        for (var i = 0; i < els.length; i++) {
            var e = els[i];
            if (e.id == "genomelist") {
                g = e;
            }
	    else if (e.id == acid) {
		ac = e;
	    }
        }
    }

    if (ac !== undefined && ac != '' && ac != null) {
	ac.style.display = "none";
    }

    var str = "<br/> <input id='expandAll' type='button' value='Expand All' onclick='myExpandAll();'>";
    str += "&nbsp;&nbsp;";
    str += "<input id='collapseAll' type='button' value='Collapse All' onclick='myCollapseAll();'>";
    g.innerHTML = str;

    if (form_id === undefined) { form_id = ''; }
    var treeid = "treeDiv1"+form_id;
    tree1 = new YAHOO.widget.TreeView(treeid);
    var parent = tree1.getRoot();
    var cnt = 0;
    for ( var i = 0; i < taxonsList.length; i++) {
        var taxon_oid = prefix + taxonsList[i][0];
        var taxon_name = taxonsList[i][1];
        var domain = taxonsList[i][2];
        var phylum = taxonsList[i][3];
        var ir_class = taxonsList[i][4];
        var ir_order = taxonsList[i][5];
        var family = taxonsList[i][6];
        var genus = taxonsList[i][7];
        var species = taxonsList[i][8];
        var seq_status = taxonsList[i][9]; // Draft, Finished, Permanent Draft
        var sub = domain.substring(0, 1);
        var sub2 = seq_status.substr(0, 1)
        var lastdomain;
        var lastphylum;
        var lastir_class;
        var lastir_order;
        var lastfamily;
        var lastgenus;
        var lastspecies;
        var tmpNodeDomain;
        var tmpNodePhylum;
        var tmpNodeIr_class;
        var tmpNodeIr_order;
        var tmpNodeFamily;
        var tmpNodeGenus;
        cnt++;
        if (domain != lastdomain) {
            // new domain
            tmpNodeDomain = new YAHOO.widget.TextNode(domain, parent);
            //tmpNodeDomain = new YAHOO.widget.TaskNode(domain, parent, false);
            lastdomain = domain;
            tmpNodePhylum = '';
            tmpNodeIr_class = '';
            tmpNodeIr_order = '';
            tmpNodeFamily = '';
            lastphylum = '';
            lastir_class = '';
            lastir_order = '';
            lastfamily = '';
            lastgenus = '';
            lastspecies = '';
        }
        if (phylum != lastphylum) {
            tmpNodePhylum = new YAHOO.widget.TextNode(phylum, tmpNodeDomain);
            //tmpNodeDomain = new YAHOO.widget.TaskNode(phylum, tmpNodeDomain, false);
            lastphylum = phylum;
            tmpNodeIr_class = '';
            tmpNodeIr_order = '';
            tmpNodeFamily = '';
            lastir_class = '';
            lastir_order = '';
            lastfamily = '';
            lastgenus = '';
            lastspecies = '';
        }
        if (ir_class != lastir_class) {
            tmpNodeIr_class = new YAHOO.widget.TextNode(ir_class, tmpNodePhylum);
            //tmpNodeIr_class = new YAHOO.widget.TaskNode(ir_class, tmpNodePhylum, false);
            lastir_class = ir_class;
            tmpNodeIr_order = '';
            tmpNodeFamily = '';
            lastir_order = '';
            lastfamily = '';
            lastgenus = '';
            lastspecies = '';
        }
        if (ir_order != lastir_order) {
            tmpNodeIr_order = new YAHOO.widget.TextNode(ir_order, tmpNodeIr_class);
            //tmpNodeIr_order = new YAHOO.widget.TaskNode(ir_order, tmpNodeIr_class, false);
            lastir_order = ir_order;
            tmpNodeFamily = '';
            lastfamily = '';
            lastgenus = '';
            lastspecies = '';
        }
        if (family != lastfamily) {
            tmpNodeFamily = new YAHOO.widget.TextNode(family, tmpNodeIr_order);
            //tmpNodeFamily = new YAHOO.widget.TaskNode(family, tmpNodeIr_order, false);
            lastfamily = family;
            lastgenus = '';
            lastspecies = '';
        }
        if (lastgenus != genus) {
            tmpNodeGenus = new YAHOO.widget.TextNode(genus, tmpNodeFamily);
            //tmpNodeGenus = new YAHOO.widget.TaskNode(genus, tmpNodeFamily, false);
            lastgenus = genus;
            lastspecies = species;
        }
        var tmpNodeTaxon = new YAHOO.widget.TextNode(taxon_name + ' (' + sub + ') [' + sub2 + ']', tmpNodeGenus);
        //var tmpNodeTaxon = new YAHOO.widget.TaskNode(taxon_name + ' (' + sub + ') [' + sub2 + ']', tmpNodeGenus, false);
        var title = domain + ' : ' + seq_status;
        tmpNodeTaxon.labelElId = taxon_oid;
        tmpNodeTaxon.title = title;
    }
    tree1.setNodesProperty('propagateHighlightUp', true);
    tree1.setNodesProperty('propagateHighlightDown', true);
    tree1.subscribe('clickEvent', tree1.onEventToggleHighlight);
    // listener to display the number of user selected genomes
    tree1.subscribe('highlightEvent', function(node) {
        genomeCountSelected(form_id);
        });
    tree1.render();
    //tree.draw(); // For TaskNode.js
}

/*
 * change the selection box to another value
 */
function selectItemByValue(elmnt, value) {
    for (var i=0; i < elmnt.options.length; i++) {
        if (elmnt.options[i].value == value) {
            elmnt.selectedIndex = i;
        }
    }
}

/**
 * to select all in selectBox.type == "select-multiple"
 * 
 * does nto really work because of the race condition between the show button and the items to display
 * 
 * @param selectBox
 */
function selectAllItems(selectBox) {
    //alert('here');
    //alert(selectBox.options.length);
    for (var i=0; i < selectBox.options.length; i++) {
        //selectBox.options[i].selected = true;
    }
}


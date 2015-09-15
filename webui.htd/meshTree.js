var list;

// yui root tree node
// http://yui.github.io/yui2/docs/yui_2.9.0_full/treeview/index.html
//
var tree1;
var bcTypeTree;

var listANIPhylo;
var treeANIPhylo;

var listBcPhylo;
var treeBcPhylo;

var listNpPhylo;
var treeNpPhylo;

/*
 * because ec and bc tree on the same page
 */
var listEc;
var treeEc;

var listAct;
var treeAct;


function initTreeAct(xmlCgiUrl, imgCompoundId) {
    var url = xmlCgiUrl + "?section=MeshTree&page=jsonActAll";
    if (imgCompoundId > 0) {
        url = url + '&compoundId=' + imgCompoundId
    }
    
    var callbacks = {
        success : function(o) {
            try {
                listAct = YAHOO.lang.JSON.parse(o.responseText);
                printTreeAct(imgCompoundId);
            } catch (x) {
                alert("JSON Parse failed! " + x);
                alert(o.responseText);
                return;
            }
        },
        failure : function(o) {
            if (!YAHOO.util.Connect.isCallInProgress(o)) {
                alert("Async call failed!");
                alert(o.responseText);
            }
        },
        timeout : 300000
    }
    // Make the call to the server for JSON data
    YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
}

/*
 * type: both, experimental or predicated default is both
 */
function initTreeEc(xmlCgiUrl, type) {
    var url = xmlCgiUrl + "?section=MeshTree&page=jsonEcAll&type=" + type;
    
    var callbacks = {
        success : function(o) {
            try {
                listEc = YAHOO.lang.JSON.parse(o.responseText);
                printTreeEc(type);
            } catch (x) {
                alert("JSON Parse failed! " + x);
                alert(o.responseText);
                return;
            }
        },
        failure : function(o) {
            if (!YAHOO.util.Connect.isCallInProgress(o)) {
                alert("Async call failed!");
                alert(o.responseText);
            }
        },
        timeout : 300000
    }
    // Make the call to the server for JSON data
    YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
}

function initTreeBc(xmlCgiUrl) {
    var url = xmlCgiUrl + "?section=MeshTree&page=jsonBcAll";

    var callbacks = {
        success : function(o) {
            try {
                list = YAHOO.lang.JSON.parse(o.responseText);
                printTreeBc();
            } catch (x) {
                alert("JSON Parse failed! " + x);
                alert(o.responseText);
                return;
            }
        },
        failure : function(o) {
            if (!YAHOO.util.Connect.isCallInProgress(o)) {
                alert("Async call failed!");
                alert(o.responseText);
            }
        },
        timeout : 60000
    }
    // Make the call to the server for JSON data
    YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
}

function initTreeOne(xmlCgiUrl, imgCompoundId) {
    var url = xmlCgiUrl + "?section=MeshTree&page=jsonOne&compoundId="
            + imgCompoundId;

    var callbacks = {
        success : function(o) {
            try {
                list = YAHOO.lang.JSON.parse(o.responseText);
                printTree(imgCompoundId, 0);
            } catch (x) {
                alert("JSON Parse failed! " + x);
                alert(o.responseText);
                return;
            }
        },
        failure : function(o) {
            if (!YAHOO.util.Connect.isCallInProgress(o)) {
                alert("Async call failed!");
                alert(o.responseText);
            }
        },
        timeout : 60000
    }
    // Make the call to the server for JSON data
    YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
}

function initTree(xmlCgiUrl, checkboxSelectionMode) {
    var url = xmlCgiUrl + "?section=MeshTree&page=jsonAll&selectionMode=" + checkboxSelectionMode;

    var callbacks = {
        success : function(o) {
            try {
                list = YAHOO.lang.JSON.parse(o.responseText);
                printTree(-1, checkboxSelectionMode);
            } catch (x) {
                alert("JSON Parse failed! " + x);
                alert(o.responseText);
                return;
            }
        },
        failure : function(o) {
            if (!YAHOO.util.Connect.isCallInProgress(o)) {
                alert("Async call failed!");
                alert(o.responseText);
            }
        },
        timeout : 60000
    }
    // Make the call to the server for JSON data
    YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
}

function initTreeANIPhylo(xmlCgiUrl, domainVal, seqstatus, cbmode) {
    var url;
    if (!domainVal || !seqstatus) {
	return;
    }

    url = xmlCgiUrl
	+ "?section=MeshTree&page=jsonANIPhylo&domainfilter="
	+ domainVal + "&seqstatus=" + seqstatus;

    var callbacks = {
        success : function(o) {
            try {
                listANIPhylo = YAHOO.lang.JSON.parse(o.responseText);
                printTreeANIPhylo(cbmode);
            } catch (x) {
                alert("JSON Parse failed! " + x);
                alert(o.responseText);
                return;
            }
        },
        failure : function(o) {
            if (!YAHOO.util.Connect.isCallInProgress(o)) {
                alert("Async call failed!");
                alert(o.responseText);
            }
        },
        timeout : 180000
    }
    // Make the call to the server for JSON data
    YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
}

function initTreeBcPhylo(xmlCgiUrl, domainVal, seqstatus, checkboxSelectionMode) {
    var url;
    if ( domainVal ) {
	url = xmlCgiUrl
	    + "?section=MeshTree&page=jsonBcPhylo&domainfilter="
	    + domainVal + "&seqstatus=" + seqstatus;
    }
    else {
	return;
    }

    var callbacks = {
        success : function(o) {
            try {
                listBcPhylo = YAHOO.lang.JSON.parse(o.responseText);
                printTreeBcPhylo(checkboxSelectionMode);
            } catch (x) {
                alert("JSON Parse failed! " + x);
                alert(o.responseText);
                return;
            }
        },
        failure : function(o) {
            if (!YAHOO.util.Connect.isCallInProgress(o)) {
                alert("Async call failed!");
                alert(o.responseText);
            }
        },
        timeout : 180000
    }
    // Make the call to the server for JSON data
    YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
}

function initTreeNpPhylo(xmlCgiUrl, domainVal, seqstatus, checkboxSelectionMode) {
    var url;
    if ( domainVal ) {
	url = xmlCgiUrl
	    + "?section=MeshTree&page=jsonNpPhylo&domainfilter="
	    + domainVal + "&seqstatus=" + seqstatus;
    }
    else {
	return;
    }

    var callbacks = {
        success : function(o) {
            try {
                listNpPhylo = YAHOO.lang.JSON.parse(o.responseText);
                printTreeNpPhylo(checkboxSelectionMode);
            } catch (x) {
                alert("JSON Parse failed! " + x);
                alert(o.responseText);
                return;
            }
        },
        failure : function(o) {
            if (!YAHOO.util.Connect.isCallInProgress(o)) {
                alert("Async call failed!");
                alert(o.responseText);
            }
        },
        timeout : 180000
    }
    // Make the call to the server for JSON data
    YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
}


/**
 * expand tree
 */
function myExpandAll(tree) {
    tree.expandAll();
}
/**
 * collapse tree
 */
function myCollapseAll(tree) {
    tree.collapseAll();
}

function printTree(imgCompoundId, checkboxSelectionMode) {
    var g = document.getElementById("meshtreediv");
    if (list.length < 1) {
        var str = "no tree";
        g.innerHTML = str;
        return;
    }

    // buttons to expand all and collapase all

    var str = "<br/> <input id='expandAll' type='button' value='Expand All' onclick='myExpandAll(tree1);'>";
    str += "&nbsp;&nbsp;";
    str += "<input id='collapseAll' type='button' value='Collapse All' onclick='myCollapseAll(tree1);'>";
    g.innerHTML = str;

    tree1 = new YAHOO.widget.TreeView("treeDiv1");
    var parent = tree1.getRoot();
    var lastarray = [];
    var tmpNodes = [];

    var subarray = list[0];
    for ( var j = 0; j < subarray.length; j++) {
        lastarray[j] = '';
        tmpNodes[j] = '';
    }

    var imgCompoundIdUrl = '';
    if (imgCompoundId > -1) {
        imgCompoundIdUrl = '&compoundId=' + imgCompoundId;
    }

    var meshUrl = 'main.cgi?section=MeshTree&page=compound&meshId=';
    var bcCountUrl ='main.cgi?section=MeshTree&page=bcCompound&meshId=';
    for ( var i = 0; i < list.length; i++) {
        var subarray = list[i];

        for ( var j = 0; j < subarray.length; j++) {
            var obj = list[i][j];
            if (obj == "-") {
                break;
            } else if (typeof (obj) == "object") {
                var name = obj.name;
                var key = obj.key;
                var count = obj.count;
                var isLeaf = obj.isLeaf;
                var bcCount = obj.bcCount;

                var myobj;
                if (j == 0) {
                    // root node
                    if (isLeaf == 'true') {
                        if (key == '-1') {
                            var nameUri = '&name=' + encodeURIComponent(name);
                            var countUrl = "<a href='" + meshUrl + key
                                    + nameUri + imgCompoundIdUrl + "'>" + count
                                    + "</a>";
                            //var bcUrl = "<a href='" + bcCountUrl + "'>" + bcCount + "</a>";
                            myobj = {
                                label : '<b>' + name + ' [SM:' + countUrl
                                          + ']</b>',
                                isLeaf : true,
                                myOid : key
                            };

                        } else {
                            var nameUri = '&name=' + encodeURIComponent(name);
                            var countUrl = "<a href='" + meshUrl + key
                                    + nameUri + imgCompoundIdUrl + "'>" + count
                                    + "</a>";
                            var bcUrl = "<a href='" + bcCountUrl + key + nameUri + imgCompoundIdUrl + "'>" + bcCount + "</a>";
                            myobj = {
                                label : '<b>' + name + ' (' + key + ') [SM:'
                                        + countUrl + ' BC:'+ bcUrl  + ']</b>',
                                title : key + ' IMG Compound count: ' + count,
                                isLeaf : true,
                                myOid : key
                            };
                        }
                    } else {
                        var countUrl = "<a href='" + meshUrl + key
                                + imgCompoundIdUrl + "'>" + count + "</a>";
                        var bcUrl = "<a href='" + bcCountUrl + key + imgCompoundIdUrl + "'>" + bcCount + "</a>";
                        myobj = {
                            label : '<b>' + name + ' (' + key + ') [SM:'
                                    + countUrl + ' BC:'+ bcUrl  + ']</b>',
                            title : key
                        };
                    }
                } else if (isLeaf == 'true') {
                    var nameUri = '&name=' + encodeURIComponent(name);
                    var countUrl = "<a href='" + meshUrl + key + nameUri
                            + imgCompoundIdUrl + "'>" + count + "</a>";
                    var bcUrl = "<a href='" + bcCountUrl + key + nameUri + imgCompoundIdUrl + "'>" + bcCount + "</a>";
                    var str = '<span style="color: #006600;">' + name + ' ('
                            + key + ') [SM:' + countUrl + ' BC:'+ bcUrl  + ']</span>';
                    myobj = {
                        label : str,
                        title : key + ' IMG Compound count: ' + count,
                        isLeaf : true,
                        myOid : key
                    };
                } else {
                    var countUrl = "<a href='" + meshUrl + key
                            + imgCompoundIdUrl + "'>" + count + "</a>";
                    var bcUrl = "<a href='" + bcCountUrl + key + imgCompoundIdUrl + "'>" + bcCount + "</a>";
                    myobj = {
                        label : name + ' (' + key + ') [SM:' + countUrl + ' BC:'+ bcUrl  + ']',
                        title : key
                    };
                }

                /*
                 * BUG the last should be key not names so testname = key not
                 * name???
                 */
                var testname = key + name;
                if (j == 0 && testname != lastarray[0]) {
                    // new node
                    tmpNodes[j] = new YAHOO.widget.TextNode(myobj, parent);
                } else if (testname != lastarray[j]) {
                    tmpNodes[j] = new YAHOO.widget.TextNode(myobj,
                            tmpNodes[j - 1]);
                }
                lastarray[j] = testname;
            } else {
                alert("unknown type");
            }
        } // end for j loop

        // var url = taxon_name + ' (' + sub + ') [' + sub2 + '] '
        // + "<a href='http://www.google.com'>google</a>";
        // var title2 = domain + ' : ' + seq_status;
        // var myobj = {
        // label : url,
        // isLeaf : true,
        // title : title2,
        // myHref : "http://www.google.com"
        // };
        // var tmpNodeTaxon = new YAHOO.widget.TextNode(myobj, tmpNodeGenus);
        // tmpNodeTaxon.labelElId = taxon_oid;
    }

    if ( checkboxSelectionMode ) {
    	tree1.subscribe('dblClickEvent', function(oArgs) {
        	oArgs.node.expand();
        	oArgs.node.expandAll();
        });
        tree1.subscribe('clickEvent', tree1.onEventToggleHighlight);
        tree1.setNodesProperty("propagateHighlightUp", true);
        tree1.setNodesProperty("propagateHighlightDown", true);    	
    }
    else {
        tree1.subscribe('clickEvent', function(o) {
            var x = o.node.isLeaf;
            // alert(x);
            if (x) {
                // alert('leaf node - Mesh Id:' + o.node.data.myOid);
                return false;
            }
            // non-leaf nodes behave as normal
            // return true;
            return false;
        });    	
    }

    tree1.render();
}

function printTreeBc() {
    var g = document.getElementById("meshtreediv");
    if (list.length < 1) {
        var str = "no tree";
        g.innerHTML = str;
        return;
    }

    // buttons to expand all and collapase all

    var str = "<br/> <input id='expandAll' type='button' value='Expand All' onclick='myExpandAll(tree1);'>";
    str += "&nbsp;&nbsp;";
    str += "<input id='collapseAll' type='button' value='Collapse All' onclick='myCollapseAll(tree1);'>";
    g.innerHTML = str;

    tree1 = new YAHOO.widget.TreeView("treeDiv1");
    var parent = tree1.getRoot();
    var lastarray = [];
    var tmpNodes = [];

    var subarray = list[0];
    for ( var j = 0; j < subarray.length; j++) {
        lastarray[j] = '';
        tmpNodes[j] = '';
    }

    var meshUrl = 'main.cgi?section=MeshTree&page=cluster&meshId=';
    for ( var i = 0; i < list.length; i++) {
        var subarray = list[i];

        for ( var j = 0; j < subarray.length; j++) {
            var obj = list[i][j];
            if (obj == "-") {
                break;
            } else if (typeof (obj) == "object") {
                var name = obj.name;
                var key = obj.key;
                var count = obj.count;
                var isLeaf = obj.isLeaf;

                var myobj;
                if (j == 0) {
                    // root node
                    if (isLeaf == 'true') {
                        if (key == '-1') {
                            var nameUri = '&bcid=' + name; // bc cluster id
                            var countUrl = "<a href='" + meshUrl + key
                                    + nameUri + "'>" + count + "</a>";
                            myobj = {
                                label : '<b>' + name + ' ['
                                        + countUrl + ']</b>',
                                isLeaf : true,
                                myOid : key,
                                myHerf : countUrl
                            };
                        } else {

                            var nameUri = '&bcid=' + name; // bc cluster id
                            var countUrl = "<a href='" + meshUrl + key
                                    + nameUri + "'>" + count + "</a>";
                            myobj = {
                                label : '<b>' + name + ' (' + key + ') ['
                                        + countUrl + ']</b>',
                                title : key + ' BC count: ' + count,
                                isLeaf : true,
                                myOid : key,
                                myHerf : countUrl
                            };
                        }
                    } else {
                        var countUrl = "<a href='" + meshUrl + key + "'>"
                                + count + "</a>";
                        myobj = {
                            label : '<b>' + name + ' (' + key + ') ['
                                    + countUrl + ']</b>',
                            title : key
                        };
                    }
                } else if (isLeaf == 'true') {
                    var nameUri = '&bcid=' + name; // bc cluster id
                    var countUrl = "<a href='" + meshUrl + key + nameUri + "'>"
                            + count + "</a>";
                    var str = '<span style="color: #006600;">' + name + ' ('
                            + key + ') [' + countUrl + ']</span>';
                    myobj = {
                        label : str,
                        title : key + ' BC count: ' + count,
                        isLeaf : true,
                        myOid : key,
                        myHerf : countUrl
                    };
                } else {
                    var countUrl = "<a href='" + meshUrl + key + "'>" + count
                            + "</a>";
                    myobj = {
                        label : name + ' (' + key + ') [' + countUrl + ']</b>',
                        title : key
                    };
                }

                /*
                 * BUG the last should be key not names so testname = key not
                 * name???
                 */
                var testname = key + name;
                if (j == 0 && testname != lastarray[0]) {
                    // new node
                    tmpNodes[j] = new YAHOO.widget.TextNode(myobj, parent);
                } else if (testname != lastarray[j]) {
                    tmpNodes[j] = new YAHOO.widget.TextNode(myobj,
                            tmpNodes[j - 1]);
                }
                lastarray[j] = testname;
            } else {
                alert("unknown type");
            }
        } // end for j loop
    }

    tree1.subscribe('clickEvent', function(o) {
        return false;
    });

    tree1.render();
}

/* This function is for loading a flat tree of bc types. */
function loadBCTypeTree(mytree) { 
    var mytreearray = mytree;
    try {
	mytreearray = YAHOO.lang.JSON.parse(mytree);
    } catch (x) {
	alert("JSON Parse failed! " + x);
	return;
    }

    var g = document.getElementById("meshtree_static");
    if (mytreearray.length < 1) {
        var str = "no tree";
        g.innerHTML = str;
	return;
    }

    // search type: exact or inexact
    var nbsp = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
    var str = "<table border='0'><tr><td>";
    str += "<input id='bcsearch1' type='radio' style='vertical-align: text-bottom;' ";
    str += "value='exact' name='bcsearch_type' checked/>";
    str += "Exact search"+nbsp+nbsp+"<br/>"+nbsp+"e.g. 'melanin;nrps'</td>";
    str += "<td><input id='bcsearch2' type='radio' style='vertical-align: text-bottom;' ";
    str += "value='inexact_and' name='bcsearch_type' />";
    str += "Inexact search \"AND\" <br/>"+nbsp+"e.g. '%melanin%' AND '%nrps%' </td>";
    str += "<td><input id='bcsearch2' type='radio' style='vertical-align: text-bottom;' ";
    str += "value='inexact_or' name='bcsearch_type' />";
    str += "Inexact search \"OR\" <br/>"+nbsp+"e.g. '%melanin%' OR '%nrps%' <br/></td></tr></table>";
    g.innerHTML = str;

    bcTypeTree = new YAHOO.widget.TreeView("treeDiv1BCType");
    var parent = bcTypeTree.getRoot();
    var topObj = {
    	label : '<b>All BC Types</b>',
    	title : 'all'
    };
    var topNode = new YAHOO.widget.TextNode(topObj, parent);
    topNode.propagateHighlightDown = true;	

    for (var i = 0; i < mytreearray.length; i++) {
        var obj = mytreearray[i];	
	
	if (typeof(obj) == "object") {
	    var key = obj.key;
	    var name = obj.name;
	    var isLeaf = obj.isLeaf;
	    
	    if (isLeaf == 'true') {
		var str = name + ' [' + key + ']';
		var myobj = {
		    label : str,
		    title : key,
		    isLeaf : true,
		    myOid : key
		};
	    
		// make a new leaf node
		var node = new YAHOO.widget.TextNode(myobj, topNode);
	    }
	}
    }
	    
    bcTypeTree.subscribe('clickEvent', bcTypeTree.onEventToggleHighlight);
    bcTypeTree.render();
}


function printTreeEc(type) {
    //alert("todo printTreeEc");
    var g = document.getElementById("meshtreedivEC");
    if (listEc.length < 1) {
        var str = "no tree";
        g.innerHTML = str;
        return;
    }

    // buttons to expand all and collapase all
    var str = "<br/> <input id='expandAll' type='button' value='Expand All' onclick='myExpandAll(treeEc);'>";
    str += "&nbsp;&nbsp;";
    str += "<input id='collapseAll' type='button' value='Collapse All' onclick='myCollapseAll(treeEc);'>";
    g.innerHTML = str;    
    
    treeEc = new YAHOO.widget.TreeView("treeDiv1Ec");
    var parent = treeEc.getRoot();
    var lastarray = [];
    var tmpNodes = [];

    var subarray = listEc[0];
    for ( var j = 0; j < subarray.length; j++) {
        lastarray[j] = '';
        tmpNodes[j] = '';
    }

    var typeurl = "&type=" + type;
    var meshUrl = 'main.cgi?section=MeshTree' + typeurl + '&page=ec&ecId=';
    var leafUrl = 'main.cgi?section=MeshTree' + typeurl + '&page=ecClusterList&ecId=';
    for ( var i = 0; i < listEc.length; i++) {
        var subarray = listEc[i];

        for ( var j = 0; j < subarray.length; j++) {
            var obj = listEc[i][j];
            if (obj == "-") {
                break;
            } else if (typeof (obj) == "object") {
                var name = obj.name;
                var key = obj.key;
                var count = obj.count;
                var isLeaf = obj.isLeaf;

                var myobj;
                if (j == 0) {
                    // root node
                    if (isLeaf == 'true') {
                        if (key == '-1') {
                            var countUrl = "<a href='" + meshUrl + key  + "'>" + count + "</a>";
                            myobj = {
                                label : '<b>' + name + ' [' + countUrl + ']</b>',
                                isLeaf : true,
                                myOid : key,
                                myHerf : countUrl
                            };
                        } else {
                            var countUrl = "<a href='" + meshUrl + key  + "'>" + count + "</a>";
                            myobj = {
                                label : '<b>(' + key + ') ' + name + ' [' + countUrl + ']</b>',
                                title : key + ' count: ' + count,
                                isLeaf : true,
                                myOid : key,
                                myHerf : countUrl
                            };
                        }
                    } else {
                        var countUrl = "<a href='" + meshUrl + key  + "'>" + count + "</a>";
                        myobj = {
                            label : '<b>(' + key + ') ' + name + ' [' + countUrl + ']</b>',
                            title : key
                        };
                    }
                } else if (isLeaf == 'true') {
                    var countUrl = "<a href='" + leafUrl + key  + "'>" + count + "</a>";
                    var str = '<span style="color: #006600;">(' + key + ') ' + name + ' [' + countUrl + ']</span>';
                    myobj = {
                        label : str,
                        title : key + ' count: ' + count,
                        isLeaf : true,
                        myOid : key,
                        myHerf : countUrl
                    };
                } else {
                    var countUrl = "<a href='" + meshUrl + key  + "'>" + count + "</a>";
                    myobj = {
                        label : '(' + key + ') ' + name + ' [' + countUrl + ']</b>',
                        title : key
                    };
                }

                /*
                 * BUG the last should be key not names so testname = key not
                 * name???
                 */
                var testname = key + name;
                if (j == 0 && testname != lastarray[0]) {
                    // new node
                    tmpNodes[j] = new YAHOO.widget.TextNode(myobj, parent);
                } else if (testname != lastarray[j]) {
                    tmpNodes[j] = new YAHOO.widget.TextNode(myobj,
                            tmpNodes[j - 1]);
                }
                lastarray[j] = testname;
            } else {
                alert("unknown type");
            }
        } // end for j loop
    }

    treeEc.subscribe('clickEvent', function(o) {
        return false;
    });

    treeEc.render();
    
}


function printTreeANIPhylo(cbmode) {
    var delim = '||';

    var g = document.getElementById("treediv1ANI");
    if (listANIPhylo.length < 1) {
        var str = "no tree";
        g.innerHTML = str;
        return;
    }

    // buttons to expand all and collapase all
    str = "<br/><input id='expandAll' type='button' value='Expand All' onclick='myExpandAll(treeANIPhylo);' />";
    str += "&nbsp;&nbsp;";
    str += "<input id='collapseAll' type='button' value='Collapse All' onclick='myCollapseAll(treeANIPhylo);' />";
    g.innerHTML = str;

    treeANIPhylo = new YAHOO.widget.TreeView("treediv2ANI");
    var parent = treeANIPhylo.getRoot();
    var lastarray = [];
    var tmpNodes = [];

    var aniPhyloUrl_base = 'main.cgi?section=ANI';

    var seqstatus = getSeqStatus();
    var aniSpeciesUrl = 'main.cgi?section=ANI&page=infoForGenusSpecies'
	+ '&seqstatus=' + seqstatus + '&genus_species=';

    for ( var i = 0; i < listANIPhylo.length; i++) {
        var subarray = listANIPhylo[i];

        for ( var j = 0; j < subarray.length; j++) {
            var obj = listANIPhylo[i][j];
            if (obj == "-") {
                break;
            } else if (typeof (obj) == "object") {
                var key = obj.key;
                var name = obj.name;
                var tooltip = obj.tooltip;
                var isLeaf = obj.isLeaf;
		var count = obj.count;

		var leafUrl;
                if ( isLeaf == 'true') {
		    leafUrl = "<a href='" + aniSpeciesUrl + key + "'>" + count + "</a>";
                }
                else {
                    var aniPhyloUrl = aniPhyloUrl_base;
		    if ( key ) {
			//split into domain, phylum, ir_class, ir_order, family, genus
			var term = key.split(delim);
			if ( term[0] != null && term[0] != undefined ) {
			    aniPhyloUrl += "&domain=" + term[0];
			}
			if ( term[1] != null && term[1] != undefined ) {
			    aniPhyloUrl += "&phylum=" + term[1];
			}
			if ( term[2] != null && term[2] != undefined ) {
			    aniPhyloUrl += "&ir_class=" + term[2];
			}
			if ( term[3] != null && term[3] != undefined ) {
			    aniPhyloUrl += "&ir_order=" + term[3];
			}
			if ( term[4] != null && term[4] != undefined ) {
			    aniPhyloUrl += "&family=" + term[4];
			}
			if ( term[5] != null && term[5] != undefined ) {
			    aniPhyloUrl += "&family=" + term[5];
			}
		    }
                }
                var myobj;
                if (j == 0) {
                    // root node
                    if (isLeaf == 'true') {
                        if (key == '-1') {
                            myobj = {
                                label : '<b>' + name + '</b>',
                                isLeaf : true,
                                myOid : key
                            };

                        } else {
                            myobj = {
                                label : '<b>' + name + '</b>',
                                title : key,
                                isLeaf : true,
                                myOid : key
                            };
                        }
                    } else {
                        myobj = {
                            label : '<b>' + name + '</b>',
                            title : key
                        };
                    }
                } else if (isLeaf == 'true') {
                    var str = '<span style="color: #006600;">' 
			+ name + ' [' + leafUrl + ']</span>';
                    myobj = {
                        label : str,
                        title : tooltip,
                        isLeaf : true,
                        myOid : key
                    };
                } else {
                    myobj = {
                        label : name,
                        title : key
                    };
                }

                var testname = key + name;
                if (j == 0 && testname != lastarray[0]) {
                    // new node
                    tmpNodes[j] = new YAHOO.widget.TextNode(myobj, parent);
                } else if (testname != lastarray[j]) {
                    tmpNodes[j] = new YAHOO.widget.TextNode(myobj, tmpNodes[j - 1]);
                }
                lastarray[j] = testname;
            } else {
                alert("unknown type");
            }
        } // end for j loop
    }

    if (cbmode) {
        treeANIPhylo.subscribe('dblClickEvent', function(oArgs) {
            oArgs.node.expand();
	    oArgs.node.expandAll();
	});
        treeANIPhylo.subscribe('clickEvent', treeANIPhylo.onEventToggleHighlight);
        treeANIPhylo.setNodesProperty("propagateHighlightUp", true);
        treeANIPhylo.setNodesProperty("propagateHighlightDown", true);
    }
    else {
        treeANIPhylo.subscribe('clickEvent', function(o) {
	    var x = o.node.isLeaf;
	    if (x) {
		return false;
	    }
	    return false;
	});
    }

    treeANIPhylo.render();
}

function printTreeBcPhylo(checkboxSelectionMode) {
    var delim = '||';

    var g = document.getElementById("treedivBcPhylo");
    if (listBcPhylo.length < 1) {
        var str = "no tree";
        g.innerHTML = str;
        return;
    }

    // buttons to expand all and collapase all
    str = "<br/> <input id='expandAll' type='button' value='Expand All' onclick='myExpandAll(treeBcPhylo);'>";
    str += "&nbsp;&nbsp;";
    str += "<input id='collapseAll' type='button' value='Collapse All' onclick='myCollapseAll(treeBcPhylo);'>";
    g.innerHTML = str;

    treeBcPhylo = new YAHOO.widget.TreeView("treediv1BcPhylo");
    var parent = treeBcPhylo.getRoot();
    var lastarray = [];
    var tmpNodes = [];

    var subarray = listBcPhylo[0];
    for ( var j = 0; j < subarray.length; j++) {
        lastarray[j] = '';
        tmpNodes[j] = '';
    }

    var bcPhyloUrl_base = 'main.cgi?section=BiosyntheticStats&page=clustersByPhylo';
    var bcTaxonUrl = 'main.cgi?section=BiosyntheticDetail&page=biosynthetic_clusters&taxon_oid=';
    for ( var i = 0; i < listBcPhylo.length; i++) {
        var subarray = listBcPhylo[i];

        for ( var j = 0; j < subarray.length; j++) {
            var obj = listBcPhylo[i][j];
            if (obj == "-") {
                break;
            } else if (typeof (obj) == "object") {
                var key = obj.key;
                var name = obj.name;
                var status = obj.status;
                var count = obj.count;
                var isLeaf = obj.isLeaf;
                //var nameUri = '&name=' + encodeURIComponent(name);

                var countUrl;
                if ( isLeaf == 'true') {
		    countUrl = "<a href='" + bcTaxonUrl + key + "'>" + count + "</a>";
                }
                else {
                    var bcPhyloUrl = bcPhyloUrl_base;
                    if ( key ) {
                    	//split into domain, phylum, ir_class, ir_order, family, genus
                    	var term = key.split(delim);
                    	if ( term[0] != null && term[0] != undefined ) {
                        	bcPhyloUrl += "&domain=" + term[0];
                        }
                    	if ( term[1] != null && term[1] != undefined ) {
                        	bcPhyloUrl += "&phylum=" + term[1];
                        }
                    	if ( term[2] != null && term[2] != undefined ) {
                        	bcPhyloUrl += "&ir_class=" + term[2];
                        }
                    	if ( term[3] != null && term[3] != undefined ) {
                        	bcPhyloUrl += "&ir_order=" + term[3];
                        }
                    	if ( term[4] != null && term[4] != undefined ) {
                        	bcPhyloUrl += "&family=" + term[4];
                        }
                    	if ( term[5] != null && term[5] != undefined ) {
                        	bcPhyloUrl += "&family=" + term[5];
                        }
                    }
		    //countUrl = "<a href='" + bcPhyloUrl + "'>" + count + "</a>";                	
		    countUrl = count;
                }
                
                var myobj;
                if (j == 0) {
                    // root node
                    if (isLeaf == 'true') {
                        if (key == '-1') {
                            myobj = {
                                label : '<b>' + name + ' [' + countUrl
                                        + ']</b>',
                                isLeaf : true,
                                myOid : key
                            };

                        } else {
                            myobj = {
                                label : '<b>' + name + ' ' + status 
                                	+ ' (' + key + ') [' + countUrl + ']</b>',
                                title : key + ' count: ' + count,
                                isLeaf : true,
                                myOid : key
                            };
                        }
                    } else {
                        myobj = {
                            label : '<b>' + name + ' [' + countUrl + ']</b>',
                            title : key
                        };
                    }
                } else if (isLeaf == 'true') {
                    var str = '<span style="color: #006600;">' + name + ' ' + status 
                    	+ ' (' + key + ') [' + countUrl + ']</span>';
                    myobj = {
                        label : str,
                        title : key + ' count: ' + count,
                        isLeaf : true,
                        myOid : key
                    };
                } else {
                    myobj = {
                        label : name + ' [' + countUrl + ']',
                        title : key
                    };
                }

                /*
                 * BUG the last should be key not names so testname = key not
                 * name???
                 */
                var testname = key + name;
                if (j == 0 && testname != lastarray[0]) {
                    // new node
                    tmpNodes[j] = new YAHOO.widget.TextNode(myobj, parent);
                } else if (testname != lastarray[j]) {
                    tmpNodes[j] = new YAHOO.widget.TextNode(myobj,
                            tmpNodes[j - 1]);
                }
                lastarray[j] = testname;
                //if ( i == 0 || i == 1 ) {
                //    alert("lastarray[" + j + ']=' + lastarray[j] + ' key=' + key);                	
                //}
            } else {
                alert("unknown type");
            }
        } // end for j loop

        // var url = taxon_name + ' (' + sub + ') [' + sub2 + '] '
        // + "<a href='http://www.google.com'>google</a>";
        // var title2 = domain + ' : ' + seq_status;
        // var myobj = {
        // label : url,
        // isLeaf : true,
        // title : title2,
        // myHref : "http://www.google.com"
        // };
        // var tmpNodeTaxon = new YAHOO.widget.TextNode(myobj, tmpNodeGenus);
        // tmpNodeTaxon.labelElId = taxon_oid;
    }

    if ( checkboxSelectionMode ) {
    	treeBcPhylo.subscribe('dblClickEvent', function(oArgs) {
        	oArgs.node.expand();
        	oArgs.node.expandAll();
        });
    	treeBcPhylo.subscribe('clickEvent', treeBcPhylo.onEventToggleHighlight);
    	treeBcPhylo.setNodesProperty("propagateHighlightUp", true);
    	treeBcPhylo.setNodesProperty("propagateHighlightDown", true);    	
    }
    else {
    	treeBcPhylo.subscribe('clickEvent', function(o) {
            var x = o.node.isLeaf;
            // alert(x);
            if (x) {
                // alert('leaf node - Mesh Id:' + o.node.data.myOid);
                return false;
            }
            // non-leaf nodes behave as normal
            // return true;
            return false;
        });    	
    }

    treeBcPhylo.render();
}

function printTreeNpPhylo(checkboxSelectionMode) {
    var delim = '||';

    var g = document.getElementById("treedivNpPhylo");
    if (listNpPhylo.length < 1) {
        var str = "no tree";
        g.innerHTML = str;
        return;
    }

    // buttons to expand all and collapase all
    str = "<br/> <input id='expandAll' type='button' value='Expand All' onclick='myExpandAll(treeNpPhylo);'>";
    str += "&nbsp;&nbsp;";
    str += "<input id='collapseAll' type='button' value='Collapse All' onclick='myCollapseAll(treeNpPhylo);'>";
    g.innerHTML = str;

    treeNpPhylo = new YAHOO.widget.TreeView("treediv1NpPhylo");
    var parent = treeNpPhylo.getRoot();
    var lastarray = [];
    var tmpNodes = [];

    var subarray = listNpPhylo[0];
    for ( var j = 0; j < subarray.length; j++) {
        lastarray[j] = '';
        tmpNodes[j] = '';
    }

    var npPhyloUrl_base = 'main.cgi?section=NaturalProd&page=npsByPhylo';
    var npTaxonUrl = 'main.cgi?section=NaturalProd&page=taxonNPList&taxon_oid=';
    for ( var i = 0; i < listNpPhylo.length; i++) {
        var subarray = listNpPhylo[i];

        for ( var j = 0; j < subarray.length; j++) {
            var obj = listNpPhylo[i][j];
            if (obj == "-") {
                break;
            } else if (typeof (obj) == "object") {
                var key = obj.key;
                var name = obj.name;
                var status = obj.status;
                var count = obj.count;
                var isLeaf = obj.isLeaf;
                //var nameUri = '&name=' + encodeURIComponent(name);

                var countUrl;
                if ( isLeaf == 'true') {
		    countUrl = "<a href='" + npTaxonUrl + key + "'>" + count + "</a>";
                }
                else {
                    var npPhyloUrl = npPhyloUrl_base;
                    if ( key ) {
                    	//split into domain, phylum, ir_class, ir_order, family, genus
                    	var term = key.split(delim);
                    	if ( term[0] != null && term[0] != undefined ) {
                        	npPhyloUrl += "&domain=" + term[0];
                        }
                    	if ( term[1] != null && term[1] != undefined ) {
                        	npPhyloUrl += "&phylum=" + term[1];
                        }
                    	if ( term[2] != null && term[2] != undefined ) {
                        	npPhyloUrl += "&ir_class=" + term[2];
                        }
                    	if ( term[3] != null && term[3] != undefined ) {
                        	npPhyloUrl += "&ir_order=" + term[3];
                        }
                    	if ( term[4] != null && term[4] != undefined ) {
                        	npPhyloUrl += "&family=" + term[4];
                        }
                    	if ( term[5] != null && term[5] != undefined ) {
                        	npPhyloUrl += "&family=" + term[5];
                        }
                    }
		    countUrl = "<a href='" + npPhyloUrl + "'>" + count + "</a>";                	
		    //countUrl = count;
                }
                
                var myobj;
                if (j == 0) {
                    // root node
                    if (isLeaf == 'true') {
                        if (key == '-1') {
                            myobj = {
                                label : '<b>' + name + ' [' + countUrl
                                        + ']</b>',
                                isLeaf : true,
                                myOid : key
                            };

                        } else {
                            myobj = {
                                label : '<b>' + name + ' ' + status 
                                	+ ' (' + key + ') [' + countUrl + ']</b>',
                                title : key + ' count: ' + count,
                                isLeaf : true,
                                myOid : key
                            };
                        }
                    } else {
                        myobj = {
                            label : '<b>' + name + ' [' + countUrl + ']</b>',
                            title : key
                        };
                    }
                } else if (isLeaf == 'true') {
                    var str = '<span style="color: #006600;">' + name + ' ' + status 
                    	+ ' (' + key + ') [' + countUrl + ']</span>';
                    myobj = {
                        label : str,
                        title : key + ' count: ' + count,
                        isLeaf : true,
                        myOid : key
                    };
                } else {
                    myobj = {
                        label : name + ' [' + countUrl + ']',
                        title : key
                    };
                }

                /*
                 * BUG the last should be key not names so testname = key not
                 * name???
                 */
                var testname = key + name;
                if (j == 0 && testname != lastarray[0]) {
                    // new node
                    tmpNodes[j] = new YAHOO.widget.TextNode(myobj, parent);
                } else if (testname != lastarray[j]) {
                    tmpNodes[j] = new YAHOO.widget.TextNode(myobj,
                            tmpNodes[j - 1]);
                }
                lastarray[j] = testname;
                //if ( i == 0 || i == 1 ) {
                //    alert("lastarray[" + j + ']=' + lastarray[j] + ' key=' + key);                	
                //}
            } else {
                alert("unknown type");
            }
        } // end for j loop

        // var url = taxon_name + ' (' + sub + ') [' + sub2 + '] '
        // + "<a href='http://www.google.com'>google</a>";
        // var title2 = domain + ' : ' + seq_status;
        // var myobj = {
        // label : url,
        // isLeaf : true,
        // title : title2,
        // myHref : "http://www.google.com"
        // };
        // var tmpNodeTaxon = new YAHOO.widget.TextNode(myobj, tmpNodeGenus);
        // tmpNodeTaxon.labelElId = taxon_oid;
    }

    if ( checkboxSelectionMode ) {
    	treeNpPhylo.subscribe('dblClickEvent', function(oArgs) {
        	oArgs.node.expand();
        	oArgs.node.expandAll();
        });
    	treeNpPhylo.subscribe('clickEvent', treeNpPhylo.onEventToggleHighlight);
    	treeNpPhylo.setNodesProperty("propagateHighlightUp", true);
    	treeNpPhylo.setNodesProperty("propagateHighlightDown", true);    	
    }
    else {
    	treeNpPhylo.subscribe('clickEvent', function(o) {
            var x = o.node.isLeaf;
            // alert(x);
            if (x) {
                // alert('leaf node - Mesh Id:' + o.node.data.myOid);
                return false;
            }
            // non-leaf nodes behave as normal
            // return true;
            return false;
        });    	
    }

    treeNpPhylo.render();
}

function printLoadingTreePhylo(baseUrl, treeType) {
    var g;
    if ( treeType == 'np' ) {
	g = document.getElementById("treedivNpPhylo");
    }
    else if ( treeType == 'ani' ) {
	g = document.getElementById("treediv1ANI");
    }
    else {
	g = document.getElementById("treedivBcPhylo");
    }
    if ( g != null && g != undefined ) {
        var str = "<p> Loading Tree...";
        str += "<img src='" + baseUrl + 
	    "/images/yui_progressbar.gif' alt='loading tree' title='Please wait tree is loding'>";
        g.innerHTML = str;
    }
}

function printEmptyPhylo(treeType) {
    var g;
    var h;
    if ( treeType == 'np' ) {
	g = document.getElementById("treedivNpPhylo");
	h = document.getElementById("treediv1NpPhylo");
    }
    else if ( treeType == 'ani' ) {
        g = document.getElementById("treediv1ANI");
        h = document.getElementById("treediv2ANI");
    }
    else {
	g = document.getElementById("treedivBcPhylo");
	h = document.getElementById("treediv1BcPhylo");
    }
    if ( g != null && g != undefined ) {
        var str = "<br/><br/><br/>";
        g.innerHTML = str;
    }
    if ( h != null && h != undefined ) {
        h.innerHTML = '';
    }		
}

function getSeqStatus() {
    var e = document.getElementById("seqstatus");
    var seqstatus;
    if ( e != null && e != undefined ) {
        seqstatus = e.options[e.selectedIndex].value;
    }
    return seqstatus;
}

function getDomainVal() {
    // find domain type user selected and load the correct json file
    var e = document.getElementById("domainfilter");
    var domainVal;
    if ( e != null && e != undefined ) {
	domainVal = e.options[e.selectedIndex].value;		
    }
    return domainVal;
}

function showButtonClicked(baseUrl, xmlCgiUrl, cbmode, treeType) {
    printEmptyPhylo(treeType);
    //find domain type user selected and load the correct json file
    var domainVal = getDomainVal();
    var seqstatus = getSeqStatus();

    if ( domainVal ) {
	printLoadingTreePhylo(baseUrl, treeType);
	if ( treeType == 'np' ) {
	    initTreeNpPhylo(xmlCgiUrl, domainVal, seqstatus, cbmode);
	}
        else if ( treeType == 'ani' ) {
            initTreeANIPhylo(xmlCgiUrl, domainVal, seqstatus, cbmode);
        }
	else {
	    initTreeBcPhylo(xmlCgiUrl, domainVal, seqstatus, cbmode);
	}
    }
}

YAHOO.util.Event.on("go_bc", "click", function(e) {
    var trees = new Array(treeBcPhylo, tree1, bcTypeTree);
    handleGo(trees);
});

YAHOO.util.Event.on("go_np", "click", function(e) {
    var trees = new Array(treeNpPhylo, tree1);
    handleGo(trees);
});

// handle Go button clicked
function handleGo(trees) {
    var selectNames = new Array('genomeFilterSelections', 'npTypes', 'bcTypes');

    if (trees != null && trees != undefined) {
	for (var i=0; i<trees.length; i++) {
	    if ( trees[i] != null && trees[i] != undefined ) {
		var hiLit = trees[i].getNodesByProperty('highlightState', 1);

		if (!YAHOO.lang.isNull(hiLit)) {
		    var values = new Array();
		    for (var j = 0; j < hiLit.length; j++) {
		        if (!hiLit[j].hasChildren(false)) {
		            var nodeData = hiLit[j].data;
		            //alert("nodeData:" + YAHOO.lang.JSON.stringify(nodeData));
		            if (YAHOO.lang.hasOwnProperty(nodeData, 'myOid')) {
		                if (nodeData.myOid) {
			            values.push(nodeData.myOid);
		                }
		            }
		        }
		    }
		    //alert("values: " + values);
		    if (values.length > 0) {
		        //var taxonLimit = 1000;
		        //if ( i==0 && trees[0] == treeBcPhylo ) {
		        //if ( values.length >= taxonLimit ) {
		    	//alert("Your taxon selection in Phylogentic Option is " + values.length + ".\n" 
		    	//+ "Please the number to less than " + taxonLimit + " .");
		    	//        return;
		        //	}
		        //}
		        
			var hiddenField = document.createElement("input");
			hiddenField.setAttribute("type", "hidden");
			hiddenField.setAttribute("name", selectNames[i]);
			hiddenField.setAttribute("value", values.toString());
			document.mainForm.appendChild(hiddenField);
		    }
		}	    		
	    }
	}
    }
	
    document.mainForm.submit();
}

function printTreeAct(imgCompoundId) {
    var g = document.getElementById("meshtreedivAct");
    if (listAct.length < 1) {
        var str = "no tree";
        g.innerHTML = str;
        return;
    }

    // buttons to expand all and collapase all

    var str = "<br/> <input id='expandAll' type='button' value='Expand All' onclick='myExpandAll(treeAct);'>";
    str += "&nbsp;&nbsp;";
    str += "<input id='collapseAll' type='button' value='Collapse All' onclick='myCollapseAll(treeAct);'>";
    g.innerHTML = str;

    treeAct = new YAHOO.widget.TreeView("treeDiv1Act");
    var parent = treeAct.getRoot();
    var lastarray = [];
    var tmpNodes = [];

    var subarray = listAct[0];
    for ( var j = 0; j < subarray.length; j++) {
        lastarray[j] = '';
        tmpNodes[j] = '';
    }

    var imgCompoundIdUrl = '';
    if (imgCompoundId > -1) {
        imgCompoundIdUrl = '&compoundId=' + imgCompoundId;
    }
    
    var meshUrl = 'main.cgi?section=MeshTree&page=activity&meshId=';
    for ( var i = 0; i < listAct.length; i++) {
        var subarray = listAct[i];

        for ( var j = 0; j < subarray.length; j++) {
            var obj = listAct[i][j];
            if (obj == "-") {
                break;
            } else if (typeof (obj) == "object") {
                var name = obj.name;
                var key = obj.key;
                var count = obj.count;
                var isLeaf = obj.isLeaf;

                var myobj;
                if (j == 0) {
                    // root node
                    if (isLeaf == 'true') {
                        if (key == '-1') {
                            var nameUri = '&name=' + encodeURIComponent(name);
                            var countUrl = "<a href='" + meshUrl + key
                            + nameUri + imgCompoundIdUrl + "'>" + count
                                    + "</a>";
                            myobj = {
                                label : '<b>' + name + ' [' + countUrl
                                        + ']</b>',
                                isLeaf : true,
                                myOid : key
                            };

                        } else {
                            var nameUri = '&name=' + encodeURIComponent(name);
                            var countUrl = "<a href='" + meshUrl + key
                                    + nameUri + imgCompoundIdUrl + "'>" + count
                                    + "</a>";

                            myobj = {
                                label : '<b>' + name + ' (' + key + ') ['
                                        + countUrl + ']</b>',
                                title : key + ' IMG Compound count: ' + count,
                                isLeaf : true,
                                myOid : key
                            };
                        }
                    } else {
                        var countUrl = "<a href='" + meshUrl + key
                        + imgCompoundIdUrl + "'>" + count + "</a>";

                        myobj = {
                            label : '<b>' + name + ' (' + key + ') ['
                                    + countUrl + ']</b>',
                            title : key
                        };
                    }
                } else if (isLeaf == 'true') {
                    /*
                    var url = 'main.cgi?section=NaturalProd&page=subCategory&stat_type=NP Activity&stat_val='
                     + encodeURIComponent(name);
                    var countUrl = "<a href='" + url
                    + imgCompoundIdUrl + "'>" + count + "</a>";
                    */
                    var countUrl = "<a href='" + meshUrl + key + "&name=" + encodeURIComponent(name) 
                    + imgCompoundIdUrl + "'>" + count + "</a>";
                    
                    var str = '<span style="color: #006600;">' + name + ' ('
                            + key + ') [' + countUrl + ']</span>';
                    myobj = {
                        label : str,
                        title : key + ' IMG Compound count: ' + count,
                        isLeaf : true,
                        myOid : key
                    };
                } else {
                    var countUrl = "<a href='" + meshUrl + key
                    + imgCompoundIdUrl + "'>" + count + "</a>";
                    myobj = {
                        label : name + ' (' + key + ') [' + countUrl + ']',
                        title : key
                    };
                }

                /*
                 * BUG the last should be key not names so testname = key not
                 * name???
                 */
                var testname = key + name;
                if (j == 0 && testname != lastarray[0]) {
                    // new node
                    tmpNodes[j] = new YAHOO.widget.TextNode(myobj, parent);
                } else if (testname != lastarray[j]) {
                    tmpNodes[j] = new YAHOO.widget.TextNode(myobj,
                            tmpNodes[j - 1]);
                }
                lastarray[j] = testname;
            } else {
                alert("unknown type");
            }
        } // end for j loop
    }

    treeAct.subscribe('clickEvent', function(o) {
            return false;
        });     

    treeAct.render();
}

function ecMeshTreeSelector(xmlCgiUrl, image) {
    var e = document.getElementById("ecMeshTreeSelect");
    var val;
    if ( e != null && e != undefined ) {
        val = e.options[e.selectedIndex].value;       
    }
    
    //alert(val);
    var x = document.getElementById('treeDiv1Ec');
    x.innerHTML = '';
    var g = document.getElementById("meshtreedivEC");
    var str = "<div id='treeDiv1Ec'>Loading Tree... <img src='" + image +  "'>  </div>";
    g.innerHTML = str;
    
    initTreeEc(xmlCgiUrl, val);
}

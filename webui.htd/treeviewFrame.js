//basics to build YUI tree

var jsObjects;
var trees;
var isMultipleLevel = false;
var toExpandAll = false;

function setMultipleLevel() {
	isMultipleLevel = true;
}

function setExpandAll() {
	toExpandAll = true;
}

function setJSObjects(categoriesObj) {
    //alert("categoriesObj=" + YAHOO.lang.JSON.stringify(categoriesObj));
	var objs = categoriesObj.category;
	var numCategories = objs.length;
	jsObjects = new Array(numCategories);
	for ( var i = 0 ; i < numCategories ; i++ ) {
        jsObjects[i] = {};
        jsObjects[i] = objs[i];
	}
	trees = new Array(numCategories);
    //alert("setJSObjects done");
}

// anonymous function wraps the remainder of the logic:
function treeInit() {
	initSomeTrees(trees, jsObjects, isMultipleLevel);
}

function initSomeTrees(sTrees, sJsObjects, dblFlag) {
    if (sTrees != null && sTrees != undefined) {
        //alert("sTrees not null");
	    for (var i=0; i<sTrees.length; i++) {
	    	sTrees[i] = new YAHOO.widget.TreeView(sJsObjects[i].name, sJsObjects[i].value);
	    	if (dblFlag) {
		    	sTrees[i].subscribe('dblClickEvent', function(oArgs) {
		        	oArgs.node.expand();
		        	oArgs.node.expandAll();
		        });
	    	}
	    	sTrees[i].subscribe('clickEvent', sTrees[i].onEventToggleHighlight);
	    	sTrees[i].setNodesProperty("propagateHighlightUp", true);
	    	sTrees[i].setNodesProperty("propagateHighlightDown", true);
	    	sTrees[i].render();
	    }
    }
}

// handler for expanding all nodes
YAHOO.util.Event.on("expand", "click", function(e) {
    if (trees != null && trees != undefined) {
	    for (var i=0; i<trees.length; i++) {
	        trees[i].expandAll();
	    }
    }
    YAHOO.util.Event.preventDefault(e);   
});

// handler for collapsing all nodes
YAHOO.util.Event.on("collapse", "click", function(e) {
    if (trees != null && trees != undefined) {
	    for (var i=0; i<trees.length; i++) {
	        trees[i].collapseAll();
	    }
    }
    YAHOO.util.Event.preventDefault(e);   
});

// Add an onDOMReady handler to build the tree when the document is ready
//YAHOO.util.Event.onDOMReady(treeInit);

var moreJsObjects;
var moreTrees;

function setMoreJSObjects(categoriesObj) {
    //alert("more categoriesObj=" + YAHOO.lang.JSON.stringify(categoriesObj));
	var objs = categoriesObj.category;
	var numCategories = objs.length;
	moreJsObjects = new Array(numCategories);
	for ( var i = 0 ; i < numCategories ; i++ ) {
        moreJsObjects[i] = {};
        moreJsObjects[i] = objs[i];
	}
	moreTrees = new Array(numCategories);
    //alert("setMoreJSObjects done");
}

// anonymous function wraps the remainder of the logic:
function moreTreeInit() {
	initSomeTrees(moreTrees, moreJsObjects, false);
	if (toExpandAll) {
		expandAllMoreTrees();
	}
}

function expandAllMoreTrees() {
    if (moreTrees != null && moreTrees != undefined) {
	    for (var i=0; i<moreTrees.length; i++) {
	        moreTrees[i].expandAll();
	    }
    }
}

function collapseAllMoreTrees() {
    if (moreTrees != null && moreTrees != undefined) {
	    for (var i=0; i<moreTrees.length; i++) {
	        moreTrees[i].collapseAll();
	    }
    }
}


//handler for expanding all nodes of more trees
YAHOO.util.Event.on("moreExpand", "click", function(e) {
    //apply to cases only moreTrees exit
    expandAllMoreTrees();
    YAHOO.util.Event.preventDefault(e);   
});

// handler for collapsing all nodes of more trees
YAHOO.util.Event.on("moreCollapse", "click", function(e) {
	//apply to cases only with moreTrees exit
    collapseAllMoreTrees();
    YAHOO.util.Event.preventDefault(e);   
});

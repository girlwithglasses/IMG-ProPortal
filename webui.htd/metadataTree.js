//continue from treeviewFrame.js, apply to 'Metadata Search'

// handle reset
YAHOO.util.Event.on("reset", "click", function(e) {
    if (trees != null && trees != undefined) {
	    for (var i=0; i<trees.length; i++) {
	        var hiLit = trees[i].getNodesByProperty('highlightState', 1);
	        if (!YAHOO.lang.isNull(hiLit)) {
	            for (var j = 0; j < hiLit.length; j++) {   
	                hiLit[j].unhighlight(true);
	            }
	        }
	        trees[i].collapseAll();
	    }
    }
});

// handle go
YAHOO.util.Event.on("go", "click", function(e) {
    if (trees != null && trees != undefined) {
	    for (var i=0; i<trees.length; i++) {
	        var hiLit = trees[i].getNodesByProperty('highlightState', 1);
	        if (!YAHOO.lang.isNull(hiLit)) {
	            var values = new Array();
	            for (var j = 0; j < hiLit.length; j++) {
	                if (!hiLit[j].hasChildren(false)) {
	                    var nodeData = hiLit[j].data;
	                    //alert("nodeData:" + YAHOO.lang.JSON.stringify(nodeData));
	                    if (YAHOO.lang.hasOwnProperty(nodeData, 'term_oid')) {
	                        values.push(nodeData.term_oid);
	                    } else {
	                        values.push(hiLit[j].label);
	                    }
	                }
	            }
	            //alert("values: " + values);
	            var rootNodeData = trees[i].getNodeByProperty("level", 0).data;
	            var param = rootNodeData.param;
	            //alert("param: " + param);
	            var hiddenField = document.createElement("input");
	            hiddenField.setAttribute("type", "hidden");
	            hiddenField.setAttribute("name", param);
	            hiddenField.setAttribute("value", values.toString());
	            document.metadataForm.appendChild(hiddenField);
	        }
	    }
    }
});

//handle moreReset
YAHOO.util.Event.on("moreReset", "click", function(e) {
    if (moreTrees != null && moreTrees != undefined) {
	    for (var i=0; i<moreTrees.length; i++) {
	        var hiLit = moreTrees[i].getNodesByProperty('highlightState', 1);
	        if (!YAHOO.lang.isNull(hiLit)) {
	            for (var j = 0; j < hiLit.length; j++) {   
	                hiLit[j].unhighlight(true);
	            }
	        }
	        moreTrees[i].collapseAll();
	    }
    }
});

//handle moreGo
YAHOO.util.Event.on("moreGo", "click", function(e) {
    //alert("moreGo clicked");
    if (moreTrees != null && moreTrees != undefined) {
        //alert("to gather value");
        var values = new Array();
	    for (var i=0; i<moreTrees.length; i++) {
	        var hiLit = moreTrees[i].getNodesByProperty('highlightState', 1);
	        if (!YAHOO.lang.isNull(hiLit)) {
	            for (var j = 0; j < hiLit.length; j++) {
	                if (!hiLit[j].hasChildren(false)) {
	                    var nodeData = hiLit[j].data;
	                    //alert("nodeData:" + YAHOO.lang.JSON.stringify(nodeData));
	                    if (YAHOO.lang.hasOwnProperty(nodeData, 'id')) {
	                        values.push(nodeData.id);
	                    }
	                }
	            }
	        }
	    }
        //alert("values: " + values);
	    if (values.length > 0) {
	        var hiddenField = document.createElement("input");
	        hiddenField.setAttribute("type", "hidden");
	        hiddenField.setAttribute("name", "outputCol");
	        hiddenField.setAttribute("value", values.toString());
	        if (document.mainForm_Pangenome_Composition != null) {
	        	document.mainForm_Pangenome_Composition.appendChild(hiddenField);
	        }
	        else {
	        	document.mainForm.appendChild(hiddenField);
	        }
	    }
    }
});


//handle Select All for moreTrees
YAHOO.util.Event.on("selAll", "click", function(e) {
    if (moreTrees != null && moreTrees != undefined) {
	    for (var i=0; i<moreTrees.length; i++) {
	        var unhiLit = moreTrees[i].getNodesByProperty('highlightState', 0);
	        if (!YAHOO.lang.isNull(unhiLit)) {
	            for (var j = 0; j < unhiLit.length; j++) {   
	                unhiLit[j].highlight(true);
	            }
	        }
	    }
    }
});

//handle Select Count Only for moreTrees
YAHOO.util.Event.on("selCnt", "click", function(e) {
	handleTypeSelect(1);
});

//handle Select Percentage Only for moreTrees
YAHOO.util.Event.on("selPerc", "click", function(e) {
	handleTypeSelect(2);
});

function handleTypeSelect(t) {
    if (moreTrees != null && moreTrees != undefined) {
	    for (var i=0; i<moreTrees.length; i++) {
	        var hiLit = moreTrees[i].getNodesByProperty('highlightState', 1);
	        if (!YAHOO.lang.isNull(hiLit)) {
	            for (var j = 0; j < hiLit.length; j++) {   
	                hiLit[j].unhighlight(true);
	            }
	        }
	        var tpNode = moreTrees[i].getNodesByProperty('tp', t);
	        if (!YAHOO.lang.isNull(tpNode)) {
	            for (var j = 0; j < tpNode.length; j++) {   
	            	tpNode[j].highlight(true);
	            }
	        }	        
	    }
    }	
}

//handle Clear All for moreTrees
YAHOO.util.Event.on("clrAll", "click", function(e) {
    if (moreTrees != null && moreTrees != undefined) {
	    for (var i=0; i<moreTrees.length; i++) {
	        var hiLit = moreTrees[i].getNodesByProperty('highlightState', 1);
	        if (!YAHOO.lang.isNull(hiLit)) {
	            for (var j = 0; j < hiLit.length; j++) {   
	                hiLit[j].unhighlight(true);
	            }
	        }
	    }
    }
});

//continue from treeviewFrame.js, apply to 'Gene Search'

// handle reset
YAHOO.util.Event.on("reset", "click", function(e) {
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

// handle go
YAHOO.util.Event.on("go", "click", function(e) {
    //alert("moreGo clicked");
    if (moreTrees != null && moreTrees != undefined) {
        //alert("to gather value");
	    for (var i=0; i<moreTrees.length; i++) {
	        var hiLit = moreTrees[i].getNodesByProperty('highlightState', 1);
	        if (!YAHOO.lang.isNull(hiLit)) {
	            var values = new Array();
	            for (var j = 0; j < hiLit.length; j++) {
	                if (!hiLit[j].hasChildren(false)) {
	                    var nodeData = hiLit[j].data;
	                    //alert("nodeData:" + YAHOO.lang.JSON.stringify(nodeData));
	                    if (YAHOO.lang.hasOwnProperty(nodeData, 'id')) {
	                        values.push(nodeData.id);
	                    }
	                }
	            }
	            //alert("values: " + values);
	            var hiddenField = document.createElement("input");
	            hiddenField.setAttribute("type", "hidden");
		        hiddenField.setAttribute("name", "outputCol");
	            hiddenField.setAttribute("value", values.toString());
	            document.mainForm.appendChild(hiddenField);
	        }
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

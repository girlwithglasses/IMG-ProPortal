//continue from treeviewFrame.js, apply to 'Genome Filter'

YAHOO.util.Event.on("go", "click", function(e) {
	handleGo();
});
YAHOO.util.Event.on("go1", "click", function(e) {
	handleGo();
});
YAHOO.util.Event.on("go2", "click", function(e) {
	handleGo();
});
YAHOO.util.Event.on("go3", "click", function(e) {
	handleGo();
});
YAHOO.util.Event.on("go4", "click", function(e) {
	handleGo();
});
YAHOO.util.Event.on("go5", "click", function(e) {
	handleGo();
});

//handle go
function handleGo() {
    //alert("go clicked");
    if (document.getElementById('displayType2') != null 
    && document.getElementById('displayType2').checked == true 
    && trees != null && trees != undefined) {
        //alert("to gather value");
	    for (var i=0; i<trees.length; i++) {
	        var hiLit = trees[i].getNodesByProperty('highlightState', 1);
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
	            if (values.length > 0) {
		            var hiddenField = document.createElement("input");
		            hiddenField.setAttribute("type", "hidden");
		            hiddenField.setAttribute("name", selectName);
		            hiddenField.setAttribute("value", values.toString());
		            document.mainForm.appendChild(hiddenField);
	            }
	        }
	    }
    }
}


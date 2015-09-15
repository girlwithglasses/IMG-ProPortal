//continue from genomeFilter.js and genomeFilterTree.js, apply to 'Genome Filter' in several Abundance UI pages

YAHOO.util.Event.on("toQueryG", "click", function(e) {
	handleToGenome(0);
});

YAHOO.util.Event.on("toReferenceG", "click", function(e) {
	handleToGenome(1);
});

function handleToGenome(t) {
	var type = t;
	var selectGenomeText = '';
	var selectGenomeVal = '';
	
    if (document.getElementById('displayType2') != null 
    && document.getElementById('displayType2').checked == true 
    && trees != null && trees != undefined) {
        //alert("to gather value");
	    if (isSingleSelect > 0) {
	    	var radioGenomeObj = document.mainForm.genomesToSelect;
	    	//alert( "radioGenomeObj = " + radioGenomeObj.length );
	    	if (radioGenomeObj != null && radioGenomeObj.length > 0) {
		    	for (i = 0; i < radioGenomeObj.length; i++){
		    		//if (i < 3) alert( "radioGenomeObj[" + i + "] = " + radioGenomeObj[i].toString() );
		    		if (radioGenomeObj[i].checked == true) {
		    	    	selectGenomeVal = radioGenomeObj[i].value;
			            selectGenomeText = radioGenomeObj[i].title;
			            break;
		    		}
		        }
	    	}
    	}
    	else {
		    for (var i=0; i<trees.length; i++) {
		        var hiLit = trees[i].getNodesByProperty('highlightState', 1);
		        if (!YAHOO.lang.isNull(hiLit)) {
		            var values = new Array();
		            for (var j = 0; j < hiLit.length; j++) {
		                if (!hiLit[j].hasChildren(false)) {
		                    var nodeData = hiLit[j].data;
		                    //alert("nodeData: " + YAHOO.lang.JSON.stringify(nodeData));
		                    if (YAHOO.lang.hasOwnProperty(nodeData, 'id')) {
		                        values.push(nodeData.id);
		                        if (values.length == 1) selectGenomeText = hiLit[j].label;
		                        if (type == 0) break;
		                    }
		                }
		            }
		            //alert("values: " + values);
		        	selectGenomeVal = values.toString();
		        	if (values.length > 1) {
		        		selectGenomeText = values.length + ' selected.';
		        	}
		        }
		    }
    	}
    }
    else if (document.getElementById('displayType1') != null 
    	    && document.getElementById('displayType1').checked == true) {
        if (isSingleSelect > 0 || type == 0) {
	    	var selectGenomeObj = document.mainForm.elements[selectName];
	    	var selectedGenomeIndex = selectGenomeObj.selectedIndex;
	        selectGenomeVal = selectGenomeObj.options[selectedGenomeIndex].value;
	        selectGenomeText = selectGenomeObj.options[selectedGenomeIndex].text;
        }
        else if (type == 1) {
	    	var selectGenomeObj = document.mainForm.elements[selectName];
	    	var selectedValues = new Array();
	    	for (i = 0; i < selectGenomeObj.options.length; i++) {       
	    		if (selectGenomeObj.options[i].selected == true) {
	    			selectedValues.push(selectGenomeObj.options[i].value);
	    			if (selectedValues.length == 1) selectGenomeText = selectGenomeObj.options[i].text;
	    	    }
	    	}
	        selectGenomeVal = selectedValues.toString();
	        //alert( "selectGenomeVal = " + selectGenomeVal );
	        if (selectedValues.length > 1) {
        		selectGenomeText = selectedValues.length + ' selected.';
	        }
        }
    }
    //alert( "selectGenomeText = " + selectGenomeText );

    var inputObj;
    if (type == 0) {
        document.getElementById("queryG").innerHTML = selectGenomeText;
    	inputObj = document.mainForm.queryGenomes;
    } else if (type == 1) {
        document.getElementById("referenceG").innerHTML = selectGenomeText;
    	inputObj = document.mainForm.referenceGenomes;
    }
    inputObj.value = selectGenomeVal;
}
